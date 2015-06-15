% This procedure evaluates the quadratic form 
%
%      f(x) = 1/2 (Ax - m)^T (Ax - m).
%
% Arguments:
% x         Evaluation point (image of size NxN)
% m         Measured data
% measang   Measurement angles
%
% Returns:
% result 		value of the discrepancy function at point x
%
% Samuli Siltanen February 2011

function result = XR_misfit(x,m,measang)

Ax_m = radon(x,measang)-m;

result = (Ax_m(:).'*Ax_m(:))/2;