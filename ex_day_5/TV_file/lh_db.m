function result = lh_db(x,m,row,col,PSF)

% Routine for statistical deconvolution. This procedure evaluates the quadratic form 
% (absolute value of log-likelihood function of statistical inversion theory)
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
% result 		value of the log-likelihood function at point x
%
% Samuli Siltanen Sept 2001

[rowPSF,colPSF] = size(PSF);
x     = reshape(x,[row,col]);

xtmp = conv2(x,PSF,'same');
xtmp(1:round(rowPSF/2),:)       = x(1:round(rowPSF/2),:);
xtmp(row-round(rowPSF/2):row,:) = x(row-round(rowPSF/2):row,:);
xtmp(:,1:round(colPSF/2))       = x(:,1:round(colPSF/2));
xtmp(:,col-round(colPSF/2):col) = x(:,col-round(colPSF/2):col);

result = 1/2 * (xtmp(:)-m(:)).' * (xtmp(:)-m(:));