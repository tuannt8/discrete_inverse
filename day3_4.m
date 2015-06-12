addpath('regu_tool');

n = 80;
[A b x] = wing(n);

% Trunscate
[U s V] = csvd(A);
r = [1 2 5 10 20 30 40 50 60 70];
[x_tr,rho,eta] = tsvd(U,s,V,b, r);
errort = zeros(size(r));
for i = 1:length(errort)
    errort(i) = norm(x_tr(:,i)-x, 2);
end
figure;
plot(r,errort);


% Tikhonov
alpha=logspace(1, -5, 40);
X_ti =tikhonov(U,s,V,b,alpha);

error = zeros(length(alpha));
for i = 1: length(alpha)
    error(i) = norm(X_ti(:,i) - x, 2);
end
figure;
semilogx(alpha, error);

% total variation
