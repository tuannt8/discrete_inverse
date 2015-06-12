% This file defines a piecewise linear target function on the interval 
% [0,1]. The function will be used in the one-dimensional deconvolution
% example.
%
% Arguments:
% x   vector of real numbers
%
% Returns: values of f at the points specified in argument vector x. Note
% that the target function is thought to be 1-periodic; if the argument
% vector contains points outside the interval [0,1], then periodicity is
% used to evaluate f.
%
% Jennifer Mueller and Samuli Siltanen, October 2012


function f = DC_target(x)

%f = ones(size(x))*2;

% Initialize result
f = zeros(size(x));

% Enforce periodicity by taking only decimal part of each real number given
% as element of the argument vector x
x = x-floor(x); 

% Set values of f wherever it does not equal zero
f((x >= 0.12) & (x <= 0.15)) = 1.5;
f((x >= 0.2) & (x <= 0.25)) = 1.3;
f((x >= 0.75) & (x <= 0.85)) = 1;
ind    = (x >= 0.35) & (x <= 0.55);
f(ind) = 5*(x(ind)-0.35);


