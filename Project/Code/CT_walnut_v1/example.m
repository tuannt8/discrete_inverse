% Load the measurement matrix and the sinogram from
% file Data164.mat
load Data164 A m

% Compute a Tikhonov regularized reconstruction using
% conjugate gradient algorithm pcg.m
N     = sqrt(size(A,2));
alpha = 10; % regularization parameter
fun   = @(x) A.'*(A*x)+alpha*x;
b     = A.'*m(:);
x     = pcg(fun,b);

% Compute a Tikhonov regularized reconstruction from only
% 20 projections
[mm,nn] = size(m);
ind     = [];
for iii=1:nn/6
    ind = [ind,(1:mm)+(6*iii-6)*mm];
end
m2    = m(:,1:6:end);
A     = A(ind,:);
alpha = 10; % regularization parameter
fun   = @(x) A.'*(A*x)+alpha*x;
b     = A.'*m2(:);
x2    = pcg(fun,b);

% Take a look at the sinograms and the reconstructions
figure
subplot(2,2,1)
imagesc(m)
colormap gray
axis square
axis off
title('Sinogram, 120 projections')
subplot(2,2,3)
imagesc(m2)
colormap gray
axis square
axis off
title('Sinogram, 20 projections')
subplot(2,2,2)
imagesc(reshape(x,N,N))
colormap gray
axis square
axis off
title({'Tikhonov reconstruction,'; '120 projections'})
subplot(2,2,4)
imagesc(reshape(x2,N,N))
colormap gray
axis square
axis off
title({'Tikhonov reconstruction,'; '20 projections'})