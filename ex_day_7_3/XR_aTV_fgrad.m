% This function evaluates gradient of the tomographic objective function
% with approximate total variation penalty.
%
% Arguments:
% x         Evaluation point (image of size NxN)
% m         Measured data
% measang   Measurement angles
% corxn     Correction factor needed for using iradon.m to compute adjoints
% alpha     Regularization parameter (positive real constant)
% beta   	Smoothing parameter for approximate total variation prior
%
% Returns:
% grad      gradient of the deblur objective function
%
% Samuli Siltanen February 2011

function grad = XR_aTV_fgrad(x,m,measang,corxn,alpha,beta)

grad = XR_misfit_grad(x,m,measang,corxn) + alpha*XR_aTV_grad(x,beta);


