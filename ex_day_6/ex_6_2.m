%% Start
close all;
clear;
addpath('../regu_tool');

%% Init data
n = 128; % Discretization

[A b x] = phillips(n);
x = x - 0.5;
x(x<0) = 0;
b = A*x;
b = b + 0.1*norm(b,2)/n*randn(n,1);

%% Landweber
iter = 1000;
[U,s,V] = csvd(A);
omega = 0.99*2/s(1)^2;

xc = zeros(size(x));
At = A';
error = zeros(iter, 1);
for i = 1:iter
    xc = xc + At*(b - A*xc)*omega;
    error(i) = norm(xc - x, 2);
end

figure;
subplot(2,2,1);
plot(xc);
hold;
plot(x, 'r--');
legend('result', 'exact');
title(['Landweber with \omega = ' num2str(omega) ', ' num2str(iter) ' iters']);
% subplot(2,2,2);
% plot(error);
% title('Landweber');

%% Argumented
xc = zeros(size(x));
At = A';
M = eye(n);
error2 = zeros(iter, 1);
for i = 1:iter
    xc = xc + At*M*(b - A*xc)*omega;
    xc(xc<0) = 0;
    error2(i) = norm(xc - x, 2);
end

subplot(2,2,3);
plot(xc);
hold;
plot(x, 'r--');
legend('result', 'exact');
title(['Argumented with \omega = ' num2str(omega) ', ' num2str(iter) ' iters']);
subplot(2,2,4);
plot(error);
hold;
plot(error2, 'r--');
title('Error');
legend('Landweber', 'Argumented');


%% Cimino
% omega2 = 1; % Larger than 2/sigma(1)
% D = zeros(n,n);
% for i = 1:n
%     nai = norm(A(i,:),2)^2;
%     if nai == 0
%         D(i,i) = 0;
%     else
%         D(i,i) = 1/n/nai;
%     end
% end
% 
% xc2 = zeros(size(x));
% error2 = zeros(iter, 1);
% for i = 1:iter
%     xc2 = xc2 + At*D*(b - A*xc2)*omega2;
%     error2(i) = norm(xc2 - x, 2);
% end
% 
% %% Plot
% subplot(2,2,3);
% plot(xc2);
% hold;
% plot(x, 'r--');
% legend('result', 'exact');
% title(['Cimino with \omega = ' num2str(omega2) ', ' num2str(iter) ' iters']);
% subplot(2,2,4);
% plot(error2);
% hold;
% plot(error, 'r--');
% title('Cimino');

