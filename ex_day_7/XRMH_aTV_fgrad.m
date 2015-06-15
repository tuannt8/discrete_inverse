% This function evaluates gradient of the tomographic objective function
% with approximate total variation penalty.
%
% Arguments:
% f         Evaluation point (image of size NxN)
% m         Measured data
% A         Measurement matrix
% alpha     Regularization parameter (positive real constant)
% beta   	Smoothing parameter for approximate total variation prior
%
% Returns:
% grad      gradient of the objective function
%
% Samuli Siltanen March 2011

function grad = XRMH_aTV_fgrad(f,m,A,alpha,beta)

grad = XRMH_misfit_grad(f,m,A) + alpha*XRMH_aTV_grad(f,beta);


