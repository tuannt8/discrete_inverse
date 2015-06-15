%% clear
close all;
clear;
addpath('../regu_tool');

%% Init
n = 64;
band = 10; % Blurring
sigma = 1.4; % Noise
[A, b, x] = blur(n, band, sigma);

noise = 0.1/n*norm(b, 2)*randn(size(b));
bn = b + noise;

%% Solve for L curve
k = 60;
[X rho eta] = cgls(A,bn,k); % No reorder

[reg_c,rho_c,eta_c] = l_corner(rho,eta);
%% L curve 1
subplot(2,2,1);
plot(eta, rho); 
hold;
plot(eta(reg_c), rho(reg_c), '*');
title('L curve');

subplot(2,2,3);
img_x = reshape(x, n, n);
imagesc(img_x);
colormap gray;
axis image;
title('exact');

subplot(2,2,4);
img_xb = reshape(X(:,reg_c), n, n);
imagesc(img_xb);
colormap gray;
axis image;
title('best');

