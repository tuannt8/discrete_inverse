% addpath('regu_tool');

close all;
clear;

%% shaw problem
n = 100;
[A b x] = shaw(n);
[U s V] = csvd(A);

% Add noise to right-hand side?
eta = 0.00001;
noise = randn(size(b)) * eta;
bn = b + noise;

%% Generalized cross validation
figure;
[reg_min,G,reg_param1] = gcv(U,s,bn,'Tikh');

%% L curve
figure;
[reg_corner,rho,eta,reg_param2] = l_curve(U,s,bn,'Tikh');



%% Error
%close all;
lamda_a = logspace(1, -5, 200);
x_bias = zeros(size(lamda_a));
x_pert = zeros(size(lamda_a));
s_i = zeros(n,n);
for i = 1:n
    s_i(i,i) = 1/s(i);
end
I = eye(n);

for i = 1:length(lamda_a)
    lamda = lamda_a(i);
    phi = zeros(n,n);
    for j = 1:n
        phi(j,j) = s(j)*s(j) / (s(j)*s(j) + lamda*lamda);
    end
    
    x_bias(i) = norm( V*(I-phi)*V'*x , 2);
    x_pert(i) = norm( V*phi*s_i*U'*noise , 2);
end

semilogx(lamda_a, x_bias);
hold;
semilogx(lamda_a, x_pert, 'r--');
legend('bias', 'pertu');
title(['Gcv lamda = ' num2str(reg_min) ' L-curve = ' num2str(reg_corner)]);