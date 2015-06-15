% Routine for tomography. This procedure evaluates the gradient 
%
%      (grad f)(x) = A^T A x - A^T m 
%
% of the quadratic form f(x) = 1/2 (Ax - m)^T (Ax - m).
%
% Arguments:
% x         Evaluation point (image of size NxN)
% m         Measured data
% measang   Measurement angles
% corxn     Correction factor needed for using iradon.m to compute adjoints
%
% Returns:
% grad 		gradient of the discrepancy function at point x
%
% Samuli Siltanen February 2011

function grad = XR_misfit_grad(x,m,measang,corxn)

Ax   = radon(x,measang);
ATAx = iradon(Ax,measang,'none');
ATAx = ATAx(2:end-1,2:end-1);
ATAx = corxn*ATAx;

ATm = iradon(m,measang,'none');
ATm = ATm(2:end-1,2:end-1);
ATm = corxn*ATm;

grad  = ATAx - ATm;
