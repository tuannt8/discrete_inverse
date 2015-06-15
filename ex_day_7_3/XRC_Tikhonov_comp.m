% Example computations related to X-ray tomography.
% Here we apply generalized Tikhonov regularization and solve
% the normal equations using the conjugate gradient method.
%
% We solve the minimization problem
%         min (f^T H f - 2 b^T f),
% where
%         H = A^T A + alpha*I
% and
%         b = A^T m,
% with m the measurement and alpha>0 the regularization parameter.
%
% The following routines must be precomputed: XRA_NoCrimeData_comp.m.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Maximum number of iterations. You can experiment with this number.
K = 80;         

% Regularization parameter
alpha = 10;

% Load noisy measurements from disc. The measurements have been simulated
% (avoiding inverse crime) in routine XR03_NoCrimeData_comp.m
load XrayNoCrime N mnc mncn measang target

% Construct right hand side
b     = iradon(mncn,measang,'none');
b     = b(2:end-1,2:end-1);
corxn = 40.7467*N/64; % Incomprehensible correction factor
b     = corxn*b;

% Solve the minimization problem using conjugate gradient method.
% See Kelley: "Iterative Methods for Optimization", SIAM 1999, page 7.
recn    = b;          % initial iterate is the backprojected data
rho     = zeros(K,1); % initialize parameters

% Compute residual using matrix-free implementation.
Hf     = radon(recn,measang);
Hf     = iradon(Hf,measang,'none');
Hf     = Hf(2:end-1,2:end-1);
Hf     = corxn*Hf;
Hf     = Hf + alpha*recn;
r      = b-Hf;
rho(1) = r(:).'*r(:);

% Start iteration
for kkk = 1:(K-1)
    if kkk==1
        p = r;
    else
        beta = rho(kkk)/rho(kkk-1);
        p    = r + beta*p;
    end
    w          = radon(p,measang);
    w          = iradon(w,measang,'none');
    w          = w(2:end-1,2:end-1);
    w          = corxn*w;
    w          = w + alpha*p;
    a          = rho(kkk)/(p(:).'*w(:));
    recn       = recn + a*p;
    r          = r - a*w;
    rho(kkk+1) = r(:).'*r(:);
    if mod(kkk,10)==0
        disp([kkk K])
    end
end

% Save result to file
save XRTikhonov recn alpha target

% Show images of the results
XRC_Tikhonov_plot