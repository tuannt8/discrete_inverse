% Example computations related to X-ray tomography. Here we apply Tikhonov 
% regularization and solve the normal equations using the conjugate 
% gradient method. The approach uses sparse matrix A and is much more
% efficient computationally than the singular value decomposition approach.
%
% The following routines must be precomputed:
% XRMA_matrix_comp.m and XRMC_NoCrimeData_comp.m.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Choose resolution
% N = 16;
global N;

% Regularization parameter
alpha = 10;

% Maximum number of iterations
MAXITER = 100;               

% Measure computation time later; start clocking here
tic

% Load measurement matrix
eval(['load RadonMatrix', num2str(N), ' A measang target N P Nang']);

% Load noisy measurements 
eval(['load XRMC_NoCrime', num2str(N), ' N mnc mncn']);
mn = mncn;

% Construct system matrix and first-order term for the minimization problem
%         min (x^T H x - 2 b^T x), 
% where 
%         H = A^T A + alpha*I
% and 
%         b = A^T mn.
% The positive constant alpha is the regularization parameter.o
b     = A.'*mn(:);

% Solve the minimization problem using conjugate gradient method.
% See Kelley: "Iterative Methods for Optimization", SIAM 1999, page 7.
K   = 80;         % maximum number of iterations
x   = b;          % initial iterate is the backprojected data
rho = zeros(K,1); % initialize parameters
% Compute residual using sparse matrices. NOTE CAREFULLY: it is important
% to write (A.')*(A*x) on the next line instead of ((A.')*A)*x, 
% because (A.')*A may be a full matrix and in that case we lose 
% the advantage of the iterative solution method!
Hx     = (A.')*(A*x) + alpha*x; 
r      = b-Hx;
rho(1) = r.'*r;
% Start iteration
for kkk = 1:K
    if kkk==1
        p = r;
    else
        beta = rho(kkk)/rho(kkk-1);
        p    = r + beta*p;
    end
    w          = (A.')*(A*p) + alpha*p;
    a          = rho(kkk)/(p.'*w);
    x          = x + a*p;
    r          = r - a*w;
    rho(kkk+1) = r.'*r;
    disp([kkk K])
end
recn = reshape(x,N,N);

% Determine computation time
comptime = toc;

% Compute relative errors
err_sup = max(max(abs(target-recn)))/max(max(abs(target)));
err_squ = norm(target(:)-recn(:))/norm(target(:));

% Save result to file
eval(['save XRMG_Tikhonov', num2str(N), ' recn alpha target comptime err_sup err_squ']);

% View the results
XRMG_Tikhonov_plot(N)