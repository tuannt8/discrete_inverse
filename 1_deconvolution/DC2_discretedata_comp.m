% We simulate 1-dimensional deconvolution data that does not involve 
% inverse crime. This is done by computing data using a very fine
% discretization and a perturbed point spread function. That data is then
% sampled at the desired computational grid, and random noise is added.
%
% The routine DC1_cont_data_comp.m must be executed before running 
% this code.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Construct discretization points
n  = 64;
x  = [0:(n-1)]/n;
Dx = x(2)-x(1);

% Choose two noise levels. We compute three kinds of data: no added noise,
% and noisy data with noise amplitude given by sigma
sigma = 0.3;

% Load precomputed results
load DC_cont_data xx Af a Ca psf xxp


% COMPUTE HIGH-RESOLUTION DATA WITH NO INVERSE CRIME

% Interpolate values of the convolution at points x using the precomputed
% values on the fine grid called xx
m = interp1(xx,Af,x,'spline');

% Reset random number generator to make it possible to repeat experiments
% with exactly same noise. If you want to experiment with different noise
% components, comment this line.
reset(RandStream.getGlobalStream);

% Create data with random measurement noise and no inverse crime
noise = sigma*max(abs(m))*randn(size(m));
mn    = m + noise;

% Compute the amount of simulated measurement noise in mn
relerr = max(abs(m-mn))/max(abs(m));
relerr2 = norm(m-mn)/norm(m);
disp(['Relative sup norm error in mn is ', num2str(relerr)])
disp(['Relative square norm error in mn is ', num2str(relerr2)])



% CONSTRUCT MATRIX MODEL AND COMPUTE DATA _WITH_ INVERSE CRIME

% Construct normalized discrete point spread function
nPSF = ceil(a/Dx); 
xPSF = [-nPSF:nPSF]*Dx;
PSF  = zeros(size(xPSF));
ind   = abs(xPSF)<a;
PSF(ind) = DC_PSF(xPSF(ind),a);
Ca   = 1/(Dx*trapz(PSF));
PSF  = Ca*PSF;

% Construct convolution matrix
A = Dx*DC_convmtx(PSF,n);

% Compute ideal data WITH INVERSE CRIME
f   = DC_target(x);
mIC = A*f(:);



% Save results to file
save DC2_discretedata A x xx n m mn mIC sigma

% Plot results
DC2_discretedata_plot



