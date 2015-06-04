% Plot simulated data creatd by routine DC2_discretedata_comp.m.
% 
% The routines DC1_cont_data_comp.m and DC2_discretedata_comp.m must be 
% executed before running this code.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Load precomputed results
load DC2_discretedata A x n m mn mIC sigma

% Plot parameters. Modify only if the line width, font size or point size
% in the plots are not optimal.
fsize  = 12;
lwidth = .5;
msize  = 8;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First plot: sampled no-crime convolution data with and without noise

% Create plot window
figure(1)
clf
subplot(1,2,1)

% Plot target and its convolution
targ = DC_target(xx);
plot(xx,targ,'k','linewidth',lwidth)
hold on
plot(xx,Af,'r','linewidth',lwidth)

% Plot the noisy data points
plot(x,m,'r.','markersize',msize)

% Axis settings
axis([0 1 -.2 2.6])
box off
%set(gca,'ytick',[0,.5,1,1.5],'fontsize',fsize)
set(gca,'xtick',[0,.5,1],'fontsize',fsize)
set(gca,'PlotBoxAspectRatio' , [2 1 1])
title('No-crime data with no added noise')

% Create subplot 
subplot(1,2,2)

% Plot target and its convolution
plot(xx,targ,'k','linewidth',lwidth)
hold on
plot(xx,Af,'r','linewidth',lwidth)

% Plot the noisy data points
plot(x,mn,'r.','markersize',msize)

% Axis settings
%axis([0 1 -.2 2.6])
box off
%set(gca,'ytick',[0,.5,1,1.5],'fontsize',fsize)
%set(gca,'yticklabel',{},'fontsize',fsize)
set(gca,'xtick',[0,.5,1],'fontsize',fsize)
set(gca,'PlotBoxAspectRatio' , [2 1 1])
title(['No-crime data with ', num2str(round(100*sigma)), '% noise'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second plot: convolution matrix

% Create plot window
figure(2)
clf

% Show nonzero entries of matrix A
spy(A)
title('Nonzero elements of convolution matrix A')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Third plot: sampled data with inverse crime

% Create plot window
figure(3)
clf

% Plot target and its convolution
targ = DC_target(xx);
plot(xx,targ,'k','linewidth',lwidth)
hold on
plot(xx,Af,'r','linewidth',lwidth)

% Plot the noisy data points
plot(x,mIC,'b.','markersize',msize)

% Axis settings
axis([0 1 -.2 2.6])
box off
%set(gca,'ytick',[0,.5,1,1.5],'fontsize',fsize)
set(gca,'xtick',[0,.5,1],'fontsize',fsize)
set(gca,'PlotBoxAspectRatio' , [2 1 1])
title('Data with inverse crime')

