% We plot naive reconstructions (deconvolutions) from simulated 1D
% convolution data with no inverse crime.
%
% The routines DC1_cont_data_comp.m and DC2_discretedata_comp.m must be 
% executed before running this code.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Plot parameters
fsize  = 10;
lwidth = .5;
msize = 6;

ylimit = 2.6;

% Load precomputed results
load DC2_discretedata A x n m mn mIC sigma

% Construct original signal for comparison
targ = DC_target(xx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute reconstruction from data with inverse crime
reco = inv(A)*mIC(:);

% Create plot window
figure(2)
clf

% Plot original target 
plot(xx,targ,'k','linewidth',lwidth)
hold on

% Plot the naive reconstruction
plot(x,reco,'b.','markersize',msize)
plot(x,reco,'b')

% Axis settings
%axis([0 1 -.2 ylimit])
box off
%set(gca,'ytick',[0,.5,1,1.5],'fontsize',fsize)
%set(gca,'xtick',[0,.5,1],'fontsize',fsize)
%set(gca,'PlotBoxAspectRatio' , [2 1 1])
title('Naive reconstruction from ideal data with inverse crime')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute reconstruction from ideal data without inverse crime
reco = inv(A)*m(:);

% Create plot window
figure(3)
clf

% Plot original target 
plot(xx,targ,'k','linewidth',lwidth)
hold on

% Plot the naive reconstruction
plot(x,reco,'b.','markersize',msize)
plot(x,reco,'b')

% Axis settings
%axis([0 1 -.2 ylimit])
box off
%set(gca,'ytick',[0,.5,1,1.5],'fontsize',fsize)
%set(gca,'xtick',[0,.5,1],'fontsize',fsize)
%set(gca,'PlotBoxAspectRatio' , [2 1 1])
title('Naive reconstruction from ideal data without inverse crime')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute reconstruction from noisy data without inverse crime
recon = inv(A)*mn(:);

% Create plot window
figure(4)
clf

% Plot original target 
plot(xx,targ,'k','linewidth',lwidth)
hold on

% Plot the naive reconstruction
plot(x,recon,'b.','markersize',msize)
plot(x,recon,'b')

% Axis settings
%axis([0 1 -.2 ylimit])
box off
%set(gca,'ytick',[0,.5,1,1.5],'fontsize',fsize)
%set(gca,'xtick',[0,.5,1],'fontsize',fsize)
%set(gca,'PlotBoxAspectRatio' , [2 1 1])
title('Naive reconstruction from noisy data without inverse crime')
