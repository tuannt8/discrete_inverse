% Plot the results of routine XRMH_aTV_comp.m
%
% Arguments:
% N    resolution of the image is N x N
%
% Jennifer Mueller and Samuli Siltanen, October 2012

function XRMH_aTV_plot(N)

% Plot parameters
fsize     = 12;
thinline  = .5;
thickline = 2;

% Load reconstruction
eval(['load XRMH_aTV', num2str(N), ' recn alpha beta target obj comptime err_sup err_squ']);

% Plot and save reconstruction image
figure(1)
clf
imagesc([target,recn],[0,1])
colormap gray
axis equal
axis off
title(['Approximate total variation reconstruction: relative error ', num2str(round(err_squ*100)), '%'])

% Plot evolution of objective function
figure(3)
clf
semilogy(obj,'k*-')
xlim([1 length(obj)])
axis square
box off
title('Convergence of Barzilai-Borwein minimization method')

% Display computation time
disp(['aTV: Computation time ', num2str(comptime), ' seconds'])