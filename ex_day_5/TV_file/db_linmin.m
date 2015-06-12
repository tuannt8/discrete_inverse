function [t,fx] = db_linmin(x, m, row, col, PSF, regparam, beta, direc, TOL)

% Line minimization routine. Minimizes a function of several variables along a 1-D line in the 
% high-dimensional argument space. It is almost a direct translation of a routine in 
% "Numerical Recipes in C" book.
%
% Arguments:
% x         Evaluation point
% m         Measured image
% row       Number of rows in original image
% col       Number of columns in original image
% PSF			Point spread function
% regparam  Regularization parameter (positive real constant)
% beta    	Smoothing parameter for approximate total variation prior
% direc     Direction vector along which we minimize
% TOL       Tolerance for stopping 
%
% Returns:
% t         Real number telling the steplength taken
% fx        Objective function value at minimum point x + t*direc
%
% Samuli Siltanen Sept 2001

global POINT DIRECTION MEAS_IMAG ROW COL REGPARAM BETA G_PSF

% Give values to the global variables
POINT     = x;
DIRECTION = direc;
MEAS_IMAG = m;
ROW       = row;
COL       = col;
G_PSF     = PSF;
REGPARAM  = regparam;
BETA      = beta;

% Bracket first the minimum.
[ax,bx,cx,af,bf,cf] = db_mnbrak('db_f1dim');

% Line minimization along direction xi.
[t,fx] = db_brent(ax,bx,cx,'db_f1dim',TOL);
