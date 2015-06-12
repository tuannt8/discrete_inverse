%%
close all;
clear;

global im_name noiselevel Npsf delta;

im_name = 'test_image/peppers256.png';
noiselevel = 0.03;
Npsf = 5;

% Generate noisy image
gen;

%% Tikhonov
num_delta_scale = 1;
delta_a = logspace(1, -5, 12); % Will draw 5 image
recn_a = cell(size(delta_a));
error_a = zeros(size(delta_a));
for i = 1:length(delta_a)
    delta = delta_a(i);
    DB2_Tikhonov;
    recn_a{i} = recn;
    error_a(i) = norm(X - recn, 2);
end

figure;
title('Tikhonov');
subplot(3,4,1);
semilogx(delta_a, error_a);
title('Error and coeficient');

for i = 2:12
    subplot(3,4,i);
    imagesc(recn_a{i*num_delta_scale});
    colormap gray;
    axis square;
    axis off;
    title(['\delta  = ' num2str(delta_a(i*num_delta_scale))]);
end

%% total variation
addpath('TV_file');

%% Total variation
global regparam;
global plot_flag;
regparam_a = logspace(-1, 2, 10);

plot_flag = 0;
if(length(regparam_a) == 1) 
    plot_flag = 1;
end

orig = X;

img_out = cell(size(regparam_a));
error_2 = zeros(size(regparam_a));
for i = 1:length(regparam_a)
    regparam = regparam_a(i);
    DB3_aTV_4;
    img_out{i} = final;
    error_2(i) = norm(final - orig, 2);
end

%% PLot
% 
if plot_flag == 0
    figure;
    subplot(3,4,1);
    semilogx(regparam_a, error_2);
    title('Error norm 2');
    for i=1:10
        subplot(3,4,i+1);
        imagesc(img_out{i});
        title(['With regparam = ' num2str(regparam_a(i))]);
        colormap gray
        axis equal
        axis off
    end
    subplot(3,4,12);
            imagesc(orig);
        title(['Origin']);
        colormap gray
        axis equal
        axis off
end