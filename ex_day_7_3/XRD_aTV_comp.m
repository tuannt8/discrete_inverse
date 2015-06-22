% Example computations related to X-ray tomography.
% Here we use the Barzilai and Borwain optimization method 
% to find the minimum of the penalty functional
%
%		1/2 (Af - m)^T (Af - m) + alpha*sum(sqrt((f_i-f_j)^2+beta))
%
% with the sum ranging over i and j indexing all horizontally 
% and vertically neighboring pixel pairs.
%
% The approximation results from the positive constant beta rounding the 
% non-differentiable corner of the absolute value function. This way the 
% penalty functional becomes differentiable and thus efficiently optimizable.
%
% The following routines must be precomputed: XRA_NoCrimeData_comp.m.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Regularization parameter
alpha = 10;

% Maximum number of iterations. You can change this number and observe the
% effects on the reconstruction
MAXITER = 40;               

% Smoothing parameter used in the approximate absolute value function
beta    = .0001; 

% Load noisy measurements from disc. The measurements have been simulated
% (avoiding inverse crime) in routine XRA_NoCrimeData_comp.m
load XrayNoCrime N mnc mncn measang target
[N,tmp] = size(target);

% Incomprehensible correction factor. It is related to the way Matlab
% normalizes the output of iradon.m. The value is empirically found and
% tested to work to reasonable accuracy. 
corxn = 40.7467*N/64; 

% Optimization routine
obj    = zeros(MAXITER+1,1);     % We will monitor the value of the objective function
fold   = zeros(size(target));    % Initial guess
gold   = XR_aTV_fgrad(fold,mncn,measang,corxn,alpha,beta);
obj(1) = XR_aTV_feval(fold,mncn,measang,alpha,beta); 

% Make the first iteration step. Theoretically, this step should satisfy 
% the Wolfe condition, see [J.Nocedal, Acta Numerica 1992]. 
% We use simply a constant choice since it usually works well.
% If there is a problem with convergence, try making t smaller. 
t = .0001;

% Compute new iterate point fnew and gradient gnew at fnew
fnew = max(fold - t*gold,0);
gnew = XR_aTV_fgrad(fnew,mncn,measang,corxn,alpha,beta);     

% Iteration counter
its = 1;    

% Record value of objective function at the new point
OFf        = XR_aTV_feval(fnew,mncn,measang,alpha,beta);
obj(its+1) = OFf;

% Barzilai and Borwein iterative minimization routine 
while (its  < MAXITER) 
    its = its + 1;   
    
    % Store previous value of objective function
    fmin = OFf;    
    
    % Compute steplength alpha
    fdiff   = fnew - fold;
    gdiff   = gnew - gold;
    steplen = (fdiff(:).'*fdiff(:))/(fdiff(:).'*gdiff(:));
    
    % Update points, gradients and objective function value
    fold = fnew;
    gold = gnew;
    fnew = max(fnew - steplen*gnew,0);
    gnew = XR_aTV_fgrad(fnew,mncn,measang,corxn,alpha,beta);
    OFf  = XR_aTV_feval(fnew,mncn,measang,alpha,beta); 
    obj(its+1) = OFf;
    format short e
    % Monitor the run
    disp(['Iteration ', num2str(its,'%4d'),...
        ', objective function value ',num2str(obj(its),'%.3e')])
end   % Iteration while-loop
recn = fnew;

% Save result to file
save XRaTV recn alpha target obj

% Show pictures of the results
XRD_aTV_plot