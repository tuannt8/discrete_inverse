close all;
clear;
addpath('TV_file');

%% Total variation
global regparam;
global plot_flag;
%regparam_a = logspace(-1, 3, 15);
regparam_a = [2.2];

plot_flag = 0;
if(length(regparam_a) == 1) 
    plot_flag = 1;
end

orig      = imread('Edelweiss.png','png');
orig      = double(orig);

img_out = cell(size(regparam_a));
error_2 = zeros(size(regparam_a));
for i = 1:length(regparam_a)
    regparam = regparam_a(i);
    DB3_aTV;
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
    for i=1:11
        subplot(3,4,i+1);
        imagesc(img_out{i});
        title(['With regparam = ' num2str(regparam_a(i))]);
        colormap gray
        axis equal
        axis off
    end
end