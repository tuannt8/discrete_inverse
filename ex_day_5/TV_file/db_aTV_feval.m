function f = db_aTV_feval(x,m,row,col,PSF,regparam,beta)

% This function evaluates the objective function with approximate TV prior.
%
% Arguments:
% x         Evaluation point
% m         Measured image
% row       Number of rows in original image
% col       Number of columns in original image
% PSF			Point spread function 
% regparam  Regularization parameter (positive real constant)
% beta      Smoothing parameter for approximate total variation prior
%
% Returns:
% f        Value of likelihood(x) + regularization_parameter * prior(x)
%
% Samuli Siltanen Feb 2001

f = lh_db(x,m,row,col,PSF) + regparam*p_aTV(x,row,col,beta);

