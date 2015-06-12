function result = db_f1dim(t)

% This is a help routine for automatic evaluation of objective function along
% a 1-dimensional line in space. This way the objective function can be disguised
% as a function of one variable for mnbrak and brent routines.
%
% Arguments:
% t       1-dimensional parameter (real number) giving the steplength for evaluation
%         of objective function.
%
% Returns:
% result  value of objective function at POINT + t*DIRECTION; here POINT and DIRECTION
%         are passed for this function as global variables
%
% Samuli Siltanen Feb 2001

global POINT DIRECTION MEAS_IMAG ROW COL G_PSF REGPARAM BETA

result = db_aTV_feval(POINT + t*DIRECTION,MEAS_IMAG,ROW,COL,G_PSF,REGPARAM,BETA);

