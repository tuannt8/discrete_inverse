% Compute convolution of target function and save to file 
% DC_cont_data.mat. 
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Parameter that specifies the width of the PSF, must satisfy 0<a<1/2. 
% The support of the building block of the PSF is [-a,a], and this 
% building block is replicated at each integer to produce a periodic
% function.
% 0.04 as default
a = 0.04;

% Choose the 'continuum' points at which to compute the convolved function.
% Here 'continuum' is in quotation marks because it is not really continuum
% but rather very finely sampling compared to the samplings used in
% computational inversion.
Nxx = 2000;
xx  = linspace(0,1,Nxx);

% Create numerical integration points. We take quite a fine sampling here
% to ensure accurate approximation of the comvolution integral.
Nxxp = 1000;
xxp  = linspace(-a,a,Nxxp);
Dxxp = xxp(2)-xxp(1);

% Evaluate normalized PSF at integration points
psf = zeros(size(xxp));
ind = abs(xxp)<a;
psf(ind) = DC_PSF(xxp(ind),a);
Ca  = 1/(Dxxp*trapz(psf)); % Normalization constant
psf = Ca*psf;

% Initialize result
Af = zeros(size(xx));

% Compute convolution by integration using trapezoidal rule
for iii = 1:Nxx
   targ = DC_target(xx(iii)-xxp);
   Af(iii) = Dxxp*trapz(psf.*targ);
end

% Save results to file
save DC_cont_data xx Af a Ca psf xxp

% Plot the results
DC1_cont_data_plot
