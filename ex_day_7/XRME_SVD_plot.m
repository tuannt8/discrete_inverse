% Plot the results of XRM05_SVD_comp.m.
%
% Arguments:
% N    resolution of the image is N x N
%
% Jennifer Mueller and Samuli Siltanen, October 2012

function XRME_SVD_plot(N)

% Plot parameters
msize  = 8;
lwidth = 2;
smallfsize  = 14;
largefsize  = 22;

% Load precomputed results. 
eval(['load XRME_SVD', num2str(N), ' U D V A measang target N P Nang']);
svals1 = full(diag(D));

% Show nonzero elements of the measurement matrix
figure(1)
clf
spy(A)
title('Nonzero elements of the measurement matrix A')

% Plot singular values of A on a logarithmic scale
figure(3)
clf
semilogy(svals1,'k','linewidth',lwidth)
xlim([1 length(svals1)])
title('Singular values of A')

