function grad = db_aTV_fgrad(x,m,row,col,PSF,regparam,beta)

% This function evaluates gradient of the objective function with L2-Laplace prior.
%
% Arguments:
% x         Evaluation point
% m         Measured image
% row       Number of rows in original image
% col       Number of columns in original image
% PSF			Point spread function 
% regparam  Regularization parameter (positive real constant)
% beta   	Smoothing parameter for approximate total variation prior
%
% Returns:
% grad      grad(likelihood)(x) + regparam * grad(prior)(x)
%
% Samuli Siltanen Sept 2001

grad = lhgrad_db(x,m,row,col,PSF) + regparam * pgrad_aTV(x,row,col,beta);


