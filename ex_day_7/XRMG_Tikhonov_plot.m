% Plot the results of routine XRMG_Tikhonov_comp.m
%
% Arguments:
% N    resolution of the image is N x N
%
% Jennifer Mueller and Samuli Siltanen, October 2012

function XRMG_Tikhonov_plot(N)

% Plot parameters
fsize     = 12;
thinline  = .5;
thickline = 2;

% Load reconstruction
eval(['load XRMG_Tikhonov', num2str(N), ' recn alpha target comptime err_sup err_squ']);

% Plot and save reconstruction image
figure(1)
clf
imagesc([target,recn],[0,1])
colormap gray
axis equal
axis off
title(['Tikhonov: relative error ', num2str(round(err_squ*100)), '%'])

% Display computation time
disp(['Computation time was ', num2str(comptime), ' seconds'])