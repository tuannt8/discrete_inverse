% Here we simulate X-ray tomographic measurement avoiding inverse crime. 
%
% Note: it is sometimes necessary to run the command 'clear all' before
% running this file.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Choose relative noise level in simulated noisy data
noiselevel = 0.01;

% Construct target image at desired resolution
N      = 128;
target = phantom('Modified Shepp-Logan',N);

% Construct measurement. The vector s contains the linear coordinates
% of the Radon transform in pixel coordinates.
Nang    = N;
angle0  = -90;
measang = angle0 + [0:(Nang-1)]/Nang*180;
[m,s] = radon(target,measang);

% Construct phantom "target2" with higher resolution 
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

% Save the result to file
save XrayNoCrime N mnc mncn measang target

% Take a look at the measurement WITH inverse crime
figure(2)
clf
imagesc(m)
colormap gray
axis square
axis off
title('measurement WITH inverse crime')

% Take a look at the measurement WITHOUT inverse crime
figure(3)
clf
imagesc(mnc)
colormap gray
axis square
axis off
title('measurement WITHOUT inverse crime')

% Take a look at the difference between the two measurements
figure(4)
clf
imagesc(abs(m-mnc))
colormap gray
axis square
axis off
title(['Sup norm error ', num2str(round(err_sup*100)), '%; square norm error ', ...
    num2str(round(err_squ*100)), '%'])

% Take a look at the noisy measurement WITHOUT inverse crime
figure(5)
clf
imagesc(mncn)
colormap gray
axis square
axis off
title('noisy measurement WITHOUT inverse crime')

% Show actual phantom (target)
figure(6)
clf
imagesc(target)
colormap gray
axis square
axis off
title(['Shepp-Logan phantom at size ', num2str(N), 'x', num2str(N)])




