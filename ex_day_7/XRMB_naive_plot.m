% Plot the results of routine XRMB_naive_comp.m. 
%
% Arguments:
% N    resolution of the image is N x N. The routines XRMA_matrix_comp.m
%      and XRMB_naive_comp.m must be computed with the number N before
%      calling this function.
%
% Jennifer Mueller and Samuli Siltanen October 2012

function XRMB_naive_plot(N)

% Plot parameters
fsize = 10;

% Load precomputed results at resolution N
eval(['load XRMB_', num2str(N), ' A measang target N naive_recon naive_recon2 relerr relerr2 m mn']);

% Take a look at the measurement matrix A
figure(2)
clf
spy(A)
axis square
set(gca,'xtick',[1,size(A,2)],'fontsize',fsize)
set(gca,'ytick',[1,size(A,1)],'fontsize',fsize)
title(['Nonzero elements of the matrix A'],'fontsize',fsize)


% Take a look at the ideal measurement
figure(3)
clf
% Remove purely zero rows from the sinogram
sinogram = [];
for iii = 1:size(m,1)
    if sum(abs(m(iii,:)))>1e-8
        sinogram = [sinogram;m(iii,:)];
    end
end
imagesc(sinogram)
colormap gray
axis square
axis off
%set(gca,'xtick',[1,size(sinogram,2)],'fontsize',fsize)
%set(gca,'ytick',[1,size(sinogram,1)],'fontsize',fsize)
title(['Measurement in sinogram form'],'fontsize',fsize)


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
title(['Reconstruction with inverse crime (no added noise in data)'],'fontsize',fsize)

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
title(['Reconstruction with inverse crime (noisy data)'],'fontsize',fsize)
colormap gray
axis off
axis square

% Display relative errors
disp(['Relative error (ideal data): ',num2str(100*relerr),'%'])
disp(['Relative error (noisy data): ',num2str(round(100*relerr2)),'%'])
