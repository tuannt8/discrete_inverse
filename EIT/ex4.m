%% Init
close all;
load b1.mat lambdaN;

n = length(lambdaN);

m = 100;
dr = 1/(m-1);
r = 0:dr:1;

%% Build matrix A, b
A = zeros(n,m);
for i = 1:n
    for j = 1:m
        A(i,j) = 2*i^2 * dr * r(j)^(2*i-1);
    end
end
A(:,1) = A(:,1)/2;
A(:,m) = A(:,m)/2;

b = lambdaN';

% Add noise
noise_level = 0.01;
% b = b + noise_level*max(abs(b))*randn(size(b));

% %% Naive solving
% x = A\b;
% 
% sigma = 1 + x./r';
% figure(1);
% % subplot(1,3,1);
% plot(sigma);title('Naive');

%% TSVD
addpath('../regu_tool');
[U s V] = csvd(A);
k = 1:n;
[x_k,rho,eta] = tsvd(U,s,V,b,k);

opt_k = 7;
x = x_k(:,opt_k);
sigma = 1 + x./r';

% figure(2);
% surf(x_k);

figure(3);
subplot(1,2,1);
plot(r,sigma);title(['TSVD, k = ' num2str(opt_k)]);
subplot(1,2,2);
% loglog(eta, rho); title('L-curve');xlabel('eta');ylabel('residual');
hold on;
for i = 1:10
    plot(r, x_k(:,i));
end

%% Tikhonov
alpha = logspace(1, -5, 50);
[x_lambda,rho,eta] = tikhonov(U,s,V,b,alpha);

% figure(4);
% surf(x_lambda);

[reg_c,rho_c,eta_c] = l_corner(rho,eta,alpha,U,s,b);
[xx,rho,eta] = tikhonov(U,s,V,b,reg_c);

figure(6);
sigma = 1 + xx./r';
plot(r, sigma);title(['\sigma with \lambda = ' num2str(reg_c)]);

% figure(5);
% loglog(eta, rho); title('L-curve');xlabel('eta');ylabel('residual');

%% Total variation
