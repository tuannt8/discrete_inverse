function grad = lhgrad_db(x,m,row,col,PSF)

% Routine for statistical deconvolution. This procedure evaluates the gradient 
%
%      (grad f)(x) 	= A^T A x - A^T m
%							= A^2 x - Am
%
% of the quadratic form (absolute value of log-likelihood function of statistical inversion theory)
%
%      f(x) = 1/2 (Ax - m)^T (Ax - m).
%
% Here A is a convolution matrix, so A^T=A.
%
% Arguments:
% x				evaluation point of size [row*col,1], where [row,col] is size of the pixel image 
% m				measured image, size [row*col,1]
% row				Number of rows in image x
% col				Number of columns in image x
% PSF				Point spread function
%
% Returns:
% grad 		gradient of the log-likelihood function at point x (vector of size (row*col) x 1)
%
% Samuli Siltanen Sept 2001


[rowPSF,colPSF] = size(PSF);
m     = reshape(m(:),[row,col]);
x     = reshape(x(:),[row,col]);

xtmp = conv2(x,PSF,'same');
xtmp(1:round(rowPSF/2),:)       = x(1:round(rowPSF/2),:);
xtmp(row-round(rowPSF/2):row,:) = x(row-round(rowPSF/2):row,:);
xtmp(:,1:round(colPSF/2))       = x(:,1:round(colPSF/2));
xtmp(:,col-round(colPSF/2):col) = x(:,col-round(colPSF/2):col);
xtmp = conv2(xtmp,PSF,'same');
xtmp(1:round(rowPSF/2),:)       = x(1:round(rowPSF/2),:);
xtmp(row-round(rowPSF/2):row,:) = x(row-round(rowPSF/2):row,:);
xtmp(:,1:round(colPSF/2))       = x(:,1:round(colPSF/2));
xtmp(:,col-round(colPSF/2):col) = x(:,col-round(colPSF/2):col);

mtmp = conv2(m,PSF,'same');
mtmp(1:round(rowPSF/2),:)       = m(1:round(rowPSF/2),:);
mtmp(row-round(rowPSF/2):row,:) = m(row-round(rowPSF/2):row,:);
mtmp(:,1:round(colPSF/2))       = m(:,1:round(colPSF/2));
mtmp(:,col-round(colPSF/2):col) = m(:,col-round(colPSF/2):col);

grad  = (xtmp(:)-mtmp(:));
