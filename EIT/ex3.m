

%% Compute A and R
l1 = 0.65;
l2 = 0.55;

R2 = l2*(2+l1)/l1/(4+l2);
A = 2*l1 / ((2+l1)*R2 - l1);
R = sqrt(R2);

disp(['A = ' num2str(A) '; R = ' num2str(R)]);
%% Compute lambda
n=1:100;

lambda = (R.^(2*n).*n*2*A)./(2 + A*(1-R.^(2*n)));

%% Plot
% Exponential decrease
plot(n,lambda);
title('Decay of \lambda');xlabel('n');ylabel('\lambda');