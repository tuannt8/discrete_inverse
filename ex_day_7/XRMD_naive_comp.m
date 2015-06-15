% Example computations related to X-ray tomography. For demonstration,
% we compute naive inversion of the Shepp-Logan phantom from non-noisy
% data with no inverse crime.
%
% Routines XRMA_matrix_comp.m and XRMC_NoCrimeData_comp.m must be computed 
% before this one. Make sure to set the resolution parameter N correctly so
% that it matches the choice made previously in XRMA_matrix_comp.m and
% XRMC_NoCrimeData_comp.m.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Choose resolution
% N = 16;
global N;

% Load precomputed results
eval(['load RadonMatrix', num2str(N), ' A measang target N P Nang']);
eval(['load XRMC_NoCrime', num2str(N), ' mnc mncn']);
m  = mnc;
mn = mncn;

% Naive reconstruction from ideal data. We use Matlab's backslash operator
% '\' that provides a least-squares solution of a matrix equation.
naive_recon = A\m(:);
naive_recon = reshape(naive_recon,N,N);
relerr      = norm(naive_recon(:)-target(:))/norm(target(:));
disp(['Relative error (ideal data): ',num2str(100*relerr),'%'])

% Naive reconstruction from noisy data. We use Matlab's backslash operator
% '\' that provides a least-squares solution of a matrix equation. 
naive_recon2 = A\mn(:);
naive_recon2 = reshape(naive_recon2,N,N);
relerr2      = norm(naive_recon2(:)-target(:))/norm(target(:));
disp(['Relative error (noisy data): ',num2str(round(100*relerr2)),'%'])

% Save the result to file (with filename containing the resolution N)
eval(['save XRMD_', num2str(N), ' A measang target N naive_recon naive_recon2 relerr relerr2 m mn']);

% View the results. 
XRMD_naive_plot(N)
