% Evaluates objective function related to approximate total variation
% regularization
%
% Arguments:
% f         Evaluation point (image of size NxN)
% m         Measured data
% A         Measurement matrix
% alpha     Regularization parameter (positive real constant)
% beta   	Smoothing parameter for approximate total variation prior
%
% Returns:
% f        Value of data_misfit(x) + alpha * aTV_penalty(x)
%
% Samuli Siltanen March 2011

function result = XRMH_aTV_feval(f,m,A,alpha,beta)

result = XRMH_misfit(f,m,A) + alpha*XRMH_aTV(f,beta);

