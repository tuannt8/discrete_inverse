% Evaluates objective function
%
% Arguments:
% x         Evaluation point (image of size NxN)
% m         Measured data
% measang   Measurement angles
% alpha     Regularization parameter (positive real constant)
% beta   	Smoothing parameter for approximate total variation prior
%
% Returns:
% f        Value of data_misfit(x) + alpha * aTV_penalty(x)
%
% Samuli Siltanen February 2011

function f = XR_aTV_feval(x,m,measang,alpha,beta)

f = XR_misfit(x,m,measang) + alpha*XR_aTV(x,beta);

