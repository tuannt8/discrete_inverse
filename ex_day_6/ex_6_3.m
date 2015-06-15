%% clear
close all;
clear;
addpath('../regu_tool');

%% Init
n = 64;
band = 10;
sigma = 1.4;
[A, b, x] = blur(n, band, sigma);

%% Plot original image
img_x = reshape(x, n, n);
img_b = reshape(b,n,n);


%% Solve noise free
k = 30;
[X rho] = cgls(A,b,k); % No reorder

%% Plot
figure;
subplot(3,4,1);
plot(rho);
title('residual norm');
rr = [1 2 4 7 9 11 13 17 20 25 30];
for i = 1:length(rr)
    subplot(3,4,i+1);
    im = reshape(X(:,rr(i)), n ,n);
    imagesc(im);
    colormap gray;
    axis image;
    title(['k= ' num2str(rr(i)) ' e = ' num2str(rho(rr(i)))]);
end

%% Solve with noise
noise = 0.1/n*norm(b, 2)*randn(size(b));
bn = b + noise;

clear X;
clear rho;
[X rho] = cgls(A,bn,k); % No reorder
%% Plot
figure;
subplot(3,4,1);
plot(rho);
title('residual norm with noise');
rr = [1 2 4 7 9 11 13 17 20 25 30];
for i = 1:length(rr)
    subplot(3,4,i+1);
    im = reshape(X(:,rr(i)), n ,n);
    imagesc(im);
    colormap gray;
    axis image;
    title(['k= ' num2str(rr(i)) ' e = ' num2str(rho(rr(i)))]);
end

img_bn = reshape(bn, n,n);

figure;
subplot(1,3,1);
imagesc(img_x);
colormap gray;
axis image;
title('Original');

subplot(1,3,2);
imagesc(img_b);
colormap gray;
axis image;
title('Blurred');

subplot(1,3,3);
imagesc(img_bn);
colormap gray;
axis image;
title('noise');
