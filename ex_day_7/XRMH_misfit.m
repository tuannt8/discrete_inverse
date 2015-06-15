% This procedure evaluates the quadratic form 
%
%      1/2 (Af - m)^T (Af - m).
%
% Arguments:
% f         Evaluation point (image of size NxN)
% m         Measured data
% A         Measurement matrix (sparse)
%
% Returns:
% result 		value of the discrepancy function at f
%
% Samuli Siltanen March 2011

function result = XRMH_misfit(f,m,A)

Ax_m = A*f(:)-m(:);

result = (Ax_m(:).'*Ax_m(:))/2;