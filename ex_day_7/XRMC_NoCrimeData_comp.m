% Here we simulate X-ray tomographic measurement avoiding inverse crime. 
% This is done by simulating data first at higher resolution using Matlab's
% Radon.m routine and then interpolating the data to the desired (lower)
% resolution. This must be done carefully as radon.m chooses the origin of
% coordinates in a specific way, and moving between different resolutions
% involves a coordinate change.
%
% ***Note: sometimes it is necessary to "clear all" in the command window
% ***before running this file. If you see the error announcement
% ***"??? Subscripted assignment dimension mismatch",
% ***please use "clear all" and rerun this file.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Construct target image at desired resolution
global N;
%N      = 16;
target = phantom('Modified Shepp-Logan',N);

% Choose relative noise level in simulated noisy data
noiselevel = 0.01;

% For comparison, construct inverse-crime measurement at the desired
% resolution. The vector s contains the linear coordinates
% of the Radon transform in pixel coordinates.
Nang    = N;
angle0  = -90;
measang = angle0 + [0:(Nang-1)]/Nang*180;
[m,s] = radon(target,measang);

% Construct phantom "target2" with higher resolution. 
N2      = 2*N;
target2 = phantom('Modified Shepp-Logan',N2);

% Construct tomographic data at higher resolution. Vector tmp contains 
% the linear coordinates of the Radon transform in pixel coordinates. 
% However, since the two phantoms have different numbers of pixels, 
% we correct for the pixel size using the ratio N/N2.
[m2,tmp]  = radon(target2,measang);
ratio     = N/N2;
s2        = tmp*ratio;

% Since Matlab's radon.m routine uses different locations of the origin at
% different resolutions (type in Matlab >> help radon), we need to correct 
% for the displacement. We calculate distance between the origins in "target" 
% and "target2" matrices by constructing matching-scale coordinates for
% both images.
orind   = floor((size(target)+1)/2); % Pixel containing the origin in target
orind2  = floor((size(target2)+1)/2); % Pixel containing the origin in target2
x       = .5 + [0:(N-1)];
[X,Y]   = meshgrid(x,x);
x2      = .5 + [0:(N2-1)];
x2      = x2*ratio;
[X2,Y2] = meshgrid(x2,x2);
orx     = X(orind(1),orind(2));
ory     = Y(orind(1),orind(2));
orx2    = X2(orind2(1),orind2(2));
ory2    = Y2(orind2(1),orind2(2));
odist   = sqrt((orx-orx2)^2+(ory-ory2)^2);

% Construct measurement "mnc" from higher resolution data by interpolation. 
% Then "mnc" contains no inverse crime. Note the correction for
% displacement of the origin due to the two resolutions used.
for iii = 1:Nang
    mnc(:,iii) = interp1(s2(:)+odist*cos(2*pi*(measang(iii)+45)/360),m2(:,iii),s(:),'cubic');
end

% Correct for magnitude
mnc = mnc*ratio;

% Remove possible NaN (not-a-number) elements resulting from possible 
% interpolation outside the domain of definition
mnc(isnan(mnc)) = 0;

% Monitor the accuracy of the interpolated data. When N grows, the errors
% become smaller. However, the error should not be zero as a small positive
% error simulates the inevitable modeling errors of practical situations.
err_sup = max(max(abs(m-mnc)))/max(max(abs(m)));
err_squ = norm(m(:)-mnc(:))/norm(m(:));
disp(['Sup norm relative error: ', num2str(err_sup)]);
disp(['Square norm relative error: ', num2str(err_squ)]);

% Reset the random number generator to ensure repeatable results
reset(RandStream.getGlobalStream);

% Construct noisy data
mncn = mnc + noiselevel*max(abs(mnc(:)))*randn(size(mnc));

% Save the result to file (with filename containing the resolution N)
eval(['save XRMC_NoCrime', num2str(N), ' N m mnc mncn measang target err_sup err_squ']);

% View the results. 
XRMC_NoCrimeData_plot(N)





