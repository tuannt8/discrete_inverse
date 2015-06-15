% Example computations related to X-ray tomography. For demonstration,
% we compute naive inversion of the Shepp-Logan phantom from non-noisy
% data *containing inverse crime*.
%
% Note: Routine XRMA_matrix_comp.m must be computed before this file using 
% the same value of N than is used here.
%
% Jennifer Mueller and Samuli Siltanen October 2012

% Choose resolution. The routine XRMA_matrix_comp.m must be computed before 
% this file using the same value of N than is used here.
global N;
% N = 16;

% Load precomputed results
eval(['load RadonMatrix', num2str(N), ' A measang target N P Nang']);

% Construct ideal (non-noisy) measurement m. This computation commits an
% inverse crime.
m  = A*target(:);
m  = reshape(m,P,length(measang));

% Naive reconstruction from ideal data. We use Matlab's backslash operator
% '\' that provides a least-squares solution of a matrix equation.
naive_recon = A\m(:);
naive_recon = reshape(naive_recon,N,N);
relerr      = norm(naive_recon(:)-target(:))/norm(target(:));
disp(['Relative error (ideal data): ',num2str(100*relerr),'%'])

% Reset the random number generator to ensure repeatable results
reset(RandStream.getGlobalStream);

% Naive reconstruction from noisy data. We use Matlab's backslash operator
% '\' that provides a least-squares solution of a matrix equation.
mn           = m + 0.001*max(max(m))*randn(size(m));
naive_recon2 = A\mn(:);
naive_recon2 = reshape(naive_recon2,N,N);
relerr2      = norm(naive_recon2(:)-target(:))/norm(target(:));
disp(['Relative error (noisy data): ',num2str(round(100*relerr2)),'%'])

% Save the result to file (with filename containing the resolution N)
eval(['save XRMB_', num2str(N), ' A measang target N naive_recon naive_recon2 relerr relerr2 m mn']);

% View the results. 
XRMB_naive_plot(N)
