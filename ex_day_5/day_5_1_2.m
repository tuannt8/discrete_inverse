%% Init and global variable
close all;
clear;

global noiselevel delta;

%% Draw setting


%% 1. Create noisy image
noiselevel = 0.04; % default 0.04
DB1_data_comp;

% Plot and compare noise image
if 0 
    figure(1);
    subplot(2,2,1);
    surf(psf); title('psf');
    subplot(2,2,2);
    imagesc(m); 
    colormap gray;
    axis square;
    axis off;
    title('original image');
    subplot(2,2,4);
    imagesc(mn); 
    colormap gray;
    axis square;
    axis off;
    title('Blurred image');
end

%% 2. Regularization with Tikhonov
num_delta_scale = 1;
delta_a = logspace(3, -5, num_delta_scale*12); % Will draw 5 image
recn_a = cell(length(delta_a), 1);
error_a = zeros(length(delta_a));
for i = 1:length(delta_a)
    delta = delta_a(i);
    DB2_Tikhonov;
    recn_a{i} = recn;
    error_a(i) = norm(X - recn, 2);
end

%% Plot the reconstruction image
if 1 
    figure;
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
end

