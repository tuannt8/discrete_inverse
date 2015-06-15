% Routine for tomography. This procedure evaluates  
%
%       A^T A f - A^T m, 
%
% which is the gradient of the quadratic form 1/2 (Af - m)^T (Af - m).
%
% Arguments:
% f         Evaluation point (image of size NxN)
% m         Measured data
% A         Measurement matrix (sparse)
%
% Returns:
% grad 		gradient of the discrepancy function at f
%
% Samuli Siltanen March 2011

function grad = XRMH_misfit_grad(f,m,A)

% Record size of image f
[row,col] = size(f);

% Compute gradient using the sparse matrix A 
grad  = A.'*(A*f(:)) - A.'*m(:);

% Reshape the result to same shape than argument image f
grad = reshape(grad,row,col);
