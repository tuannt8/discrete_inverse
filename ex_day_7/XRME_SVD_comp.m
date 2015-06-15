% Here we compute the SVD of the sparse tomographic measurement matrix A 
% using full matrix algorithms. This is not very efficient coding, and it 
% is done only for educational purposes.
%
% The following routine must be run before this file: XRMA_matrix_comp.m.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Choose resolution
% N = 16;
global N;

% Load precomputed results at resolution N
eval(['load RadonMatrix', num2str(N), ' A measang target N P Nang']);

% Compute SVD of A using full matrix algorithms
[U,D,V] = svd(full(A));
D       = sparse(D);

% Save the result to file (with filename containing the resolution N)
eval(['save XRME_SVD', num2str(N), ' U D V A measang target N P Nang']);

% View the results
XRME_SVD_plot(N)
