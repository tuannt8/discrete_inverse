% Plot the results of routine XRMD_naive_comp.m. 
%
% Arguments:
% N    resolution of the image is N x N
%
% Jennifer Mueller and Samuli Siltanen, October 2012

function XRMD_naive_plot(N)

% Plot parameters
fsize = 10;

% Load precomputed results at resolution N
eval(['load XRMD_', num2str(N), ' A measang target N naive_recon naive_recon2 relerr relerr2 m mn']);

% Take a look at the naive reconstruction from ideal data
figure(1)
clf
subplot(1,2,1)
imagesc(target)
colormap gray
axis off
axis square
title([num2str(N),'x',num2str(N),' phantom'],'fontsize',fsize)
subplot(1,2,2)
imagesc(naive_recon)
colormap gray
axis off
axis square
title(['Naive reconstruction (no added noise in the data)'],'fontsize',fsize)

% Take a look at the naive reconstruction from noisy data
figure(5)
clf
subplot(1,2,1)
imagesc(target)
colormap gray
axis off
axis square
title([num2str(N),'x',num2str(N),' phantom'],'fontsize',fsize)
subplot(1,2,2)
imagesc(naive_recon2)
title(['Naive reconstruction (noisy data)'],'fontsize',fsize)
colormap gray
axis off
axis square

% Display relative errors
disp(['Relative error (ideal data): ',num2str(100*relerr),'%'])
disp(['Relative error (noisy data): ',num2str(round(100*relerr2)),'%'])

