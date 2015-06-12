addpath('regu_tool');

close all;
clear;

N = 32;
ds = pi / (N-1);
s = -pi/2:ds:pi/2;
t = -pi/2:ds:pi/2;

%% A
A = zeros(N,N);

for i = 1:N
    for j = 1:N
        A(i,j) = ds*ds*K(s(i), t(j));
    end
end

%% m
f = zeros(N,1);
for i = 1:N
    f(i) = compute_f(t(i));
end

m = A*f;

[As,bs,xs] = shaw(32);
A = As;
m = bs;
f = xs;

noise = 0.03*norm(m,'inf')*randn(size(m));
mn = m + noise;


%% Exercise day 3/2
alpha=logspace(1, -5, 20);
[U,s,V] = csvd(A);
X=tikhonov(U,s,V,mn,alpha);


% error norm
T_a = zeros(size(alpha));
ATm_a = zeros(size(alpha));
error = zeros(size(alpha));
for i = 1:length(alpha)
    T_a(i) = norm(X(:,i),2);
    ATm_a(i) = norm(A*X(:,i) - mn, 2);
    error(i) = norm(X(:,i) - f, 2);
end

figure;
subplot(2,2,1);
plot(ATm_a, T_a);
title('|T_a|');

subplot(2,2,2);
semilogx(alpha, ATm_a);
title('|ATm_a|');

subplot(2,2,3);
semilogx(alpha, error);
title('error');
xlabel('alpha');

subplot(2,2,4);
mesh(X);
title('T(a)');
ylabel('s');
xlabel('alpha');
%% SVD A = USV'
% Exercise day 2/6
% [U,s,V] = csvd(A);
% 
% 
% subplot (2,1,1); 
% picard (U,s,m); title('origin');
% subplot (2,1,2); 
% picard (U,s,m_e); title('noise')