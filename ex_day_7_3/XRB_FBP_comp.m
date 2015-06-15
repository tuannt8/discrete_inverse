% Example computations related to X-ray tomography.
% Here we apply the classical filtered back-projection method to the
% tomographic data created in routine XRA_NoCrimeData_comp.m
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Load noisy measurements from disc. The measurements have been simulated
% (avoiding inverse crime) in routine XRA_NoCrimeData_comp.m
load XrayNoCrime N mnc mncn measang

% Reconstruct using Matlab's inverse Radon transform routine
tic
recn = iradon(mncn,measang);
recn = recn(2:end-1,2:end-1);
comptime = toc;

% Compute relative error
err_squ = norm(target(:)-recn(:))/norm(target(:));

% Take a look at the reconstruction
figure(1)
clf
imagesc([target,recn],[0,1])
colormap gray
axis equal
axis off
title(['Filtered back-projection reconstruction: error ',  num2str(round(err_squ*100)), '%'])

