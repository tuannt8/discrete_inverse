% Two-dimensional deconvolution based on Tikhonov regularization.
% The routine DB1_data_comp.m should be computed before this file.
%
% Jennifer Mueller, Samuli Siltanen and Sanna Tyrvainen, October 2012

% Load precomputed results
load img_data psf noiselevel X mn p0

% Regularization parameter for Tikhonov regularization
global delta;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstration of reconstruction using Tikhonov regularization and
% conjugate gradient method for the solution of the normal equations
%
%         (A^T A + delta*I)x = A^T mn. 
%
% The positive constant delta is the regularization parameter.
% We use Jacobi preconditioning, or replace matrix (A^T A + delta*I) by 
%
% H := inv(P)*(A^T A + delta*I)
%
% and vector (A^T mn) by b = inv(P)*(A^T mn). Here P is a diagonal matrix
% of the simple form const*I, where const is the diagonal value of the matrix 
% (A^T A + delta*I), which is p0^2+delta by construction.
const = p0^2+delta;
b     = (1/const)*conv2(mn,psf,'same');

% Solve the minimization problem using conjugate gradient method.
% See Kelley: "Iterative Methods for Optimization", SIAM 1999, page 7.
K    = 40;         % maximum number of iterations
recn = zeros(size(X));          % initial iterate is the backprojected data
rho  = zeros(K,1); % initialize parameters
% Compute residual
Arecn   = conv2(recn,psf,'same');
ATArecn = conv2(Arecn,psf,'same');
Hrecn   = (1/const)*(ATArecn + delta*recn); 
r       = b-Hrecn;
rho(1)  = r(:).'*r(:);
% Start iteration
for kkk = 1:(K-1)
    if kkk==1
        p = r;
    else
        beta = rho(kkk)/rho(kkk-1);
        p    = r + beta*p;
    end
    Ap   = conv2(p,psf,'same');
    ATAp = conv2(Ap,psf,'same');
    Hp   = (1/const)*(ATAp + delta*p);
    w    = Hp;
    a    = rho(kkk)/(p(:).'*w(:));
    recn = recn + a*p;
    r    = r - a*w;
    rho(kkk+1) = r(:).'*r(:);
    if mod(kkk,20)==0
        disp([kkk K])
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Take a look at the reconstruction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



