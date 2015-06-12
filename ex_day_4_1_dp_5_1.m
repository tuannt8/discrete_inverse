addpath('regu_tool');

close all;
clear;

%% shaw problem
n = 100;
[A b x] = shaw(n);
[U s V] = csvd(A);

% Add noise to right-hand side?
eta = 0.001;
noise = randn(size(b)) * eta;
bn = b + noise;

%% discrepancy principle
vdp = 1;
delta = vdp * sqrt(n)*eta;

[x_delta lamda] = discrep(U,s,V,bn,delta);

%%
plot(x_delta);
hold;
plot(x,'r--');