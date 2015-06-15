% Example computations related to X-ray tomography.
% Here we use the Barzilai and Borwain optimization method 
% to find the minimum of the penalty functional
%
%		1/2 (Af - m)^T (Af - m) + delta*sum(sqrt((f_i-f_j)^2+beta))
%
% with the sum ranging over i and j indexing all horizontally 
% and vertically neighboring pixel pairs.
%
% The approximation results from the positive constant beta rounding the 
% non-differentiable corner of the absolute value function. This way the 
% penalty functional becomes differentiable and thus efficiently
% optimizable.
%
% We also use a non-negativity constraint implemented by projecting
% negative pixel values to zero at each iteration.
%
% The following routines must be precomputed: 
% XRMA_matrix_comp.m and XRMC_NoCrimeData_comp.m.
%
% The following routines are called by this file: XRMH_aTV_feval.m,
% XRMH_aTV_fgrad.m, XRMH_aTV_grad.m, XRMH_aTV_plot.m, XRMH_aTV.m,
% XRMH_misfit_grad.m, XRMH_misfit.m. These routines must be available in
% the working directory or in Matlab path.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Choose resolution parameter. The chosen N must match a choice of N done
% previously when computing XRMA_matrix_comp.m and XRMC_NoCrimeData_comp.m.
% N = 16;
global N;

% Choose regularization parameter
alpha = .6;

% Maximum number of iterations (you can experiment with this number)
MAXITER = 100;               

% Smoothing parameter used in the approximate absolute value function
beta    = .0001; 

% Measure computation time later; start clocking here
tic

% Load measurement matrix
eval(['load RadonMatrix', num2str(N), ' A measang target N P Nang']);

% Load noisy measurements from disc.
eval(['load XRMC_NoCrime', num2str(N), ' N mnc mncn ']);

% Optimization routine
obj    = zeros(MAXITER+1,1);     % We will monitor the value of the objective function
fold   = zeros(size(target));    % Initial guess
gold   = XRMH_aTV_fgrad(fold,mncn,A,alpha,beta);
obj(1) = XRMH_aTV_feval(fold,mncn,A,alpha,beta); 

% Make the first iteration step. Theoretically, this step should satisfy 
% the Wolfe condition, see [J.Nocedal, Acta Numerica 1992]. 
% We use simply a constant choice.
t = .0001;

% Compute new iterate point fnew and gradient gnew at fnew
fnew = max(fold - t*gold,0); % Non-negativity constraint here
gnew = XRMH_aTV_fgrad(fnew,mncn,A,alpha,beta);     

% Iteration counter
its = 1;    

% Record value of objective function at the new point
ff         = XRMH_aTV_feval(fnew,mncn,A,alpha,beta);
obj(its+1) = ff;

% Barzilai and Borwein iterative minimization routine 
while (its  < MAXITER) 
    its = its + 1;   
    
    % Store previous value of objective function
    fmin = ff;    
    
    % Compute steplength alpha
    fdiff   = fnew - fold;
    gdiff   = gnew - gold;
    steplen = (fdiff(:).'*fdiff(:))/(fdiff(:).'*gdiff(:));
    
    % Update points, gradients and objective function value
    fold = fnew;
    gold = gnew;
    fnew = max(fnew - steplen*gnew,0); % Non-negativity constraint here
    gnew = XRMH_aTV_fgrad(fnew,mncn,A,alpha,beta);
    ff   = XRMH_aTV_feval(fnew,mncn,A,alpha,beta); 
    obj(its+1) = ff;
    format short e
    % Monitor the run
    disp(['Iteration ', num2str(its,'%4d'),', objective function value ',num2str(obj(its),'%.3e')])
end   % Iteration while-loop
recn = fnew;

% Determine computation time
comptime = toc;

% Compute relative errors
err_sup = max(max(abs(target-recn)))/max(max(abs(target)));
err_squ = norm(target(:)-recn(:))/norm(target(:));

% Save result to file
eval(['save XRMH_aTV', num2str(N), ' recn alpha beta target obj comptime err_sup err_squ']); 

% View the results
XRMH_aTV_plot(N)
