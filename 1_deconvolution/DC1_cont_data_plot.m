% Plot the point spread function (PSF) used in the 1D deconvolution
% example. Routine DC1_cont_data_comp.m must be computed before this file.
% 
% Jennifer Mueller and Samuli Siltanen, October 2012

% Plot parameters
fsize  = 10;
lwidth = 1;

% Load precomputed results
load DC_cont_data xx Af a Ca psf xxp

% Construct the target function
targ = DC_target(xx);

% Create plot window
figure(1)
clf

% Plot the target
plot(xx,targ,'k','linewidth',lwidth)
hold on
plot(xx,Af,'r','linewidth',lwidth)

% Axis settings
% axis([0 1 0 1.6])
% box off
% set(gca,'ytick',[0,.5,1,1.3,1.5],'fontsize',fsize)
% set(gca,'xtick',[0,.5,1],'fontsize',fsize)
% set(gca,'PlotBoxAspectRatio' , [2 1 1])


