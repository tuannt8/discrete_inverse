%% clear
close all;
clear;
addpath('../regu_tool');

%% Init
n = 64;
band_a = 3:15; % Blurring
sigma = 1.4; % Noise
x_best = cell(size(band_a));

for i = 1:length(band_a)
    band = band_a(i);
    [A, b, x] = blur(n, band, sigma);

    noise = 0.1/n*norm(b, 2)*randn(size(b));
    bn = b + noise;

    % Solve for L curve
    k = 60;
    [X rho eta] = cgls(A,bn,k); % No reorder
    [reg_c,rho_c,eta_c] = l_corner(rho,eta);
    
    x_best{i} = reshape(X(:,reg_c), n, n);
end

%% Plot
for i = 1:12
    subplot(3,4,i);
    imagesc(x_best{i});
    colormap gray;
    axis image;
    title(['band = ' num2str(band_a(i))]);
end