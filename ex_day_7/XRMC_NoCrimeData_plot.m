% Plot the results of XRMC_NoCrimeData_comp.m. 
%
% Arguments:
% N    resolution of the previous computation is N x N
%
% Jennifer Mueller and Samuli Siltanen, October 2012

function XRMC_NoCrimeData_plot(N)

% Load precomputed results at resolution N from file
eval(['load XRMC_NoCrime', num2str(N), ' N m mnc mncn measang target err_sup err_squ']);

% Difference between the two measurements
difference = abs(m-mnc);

% Maximum value needed for creating same colorscale to all three subimages
MAX = max([m(:);mnc(:);difference(:)]);

% Plot parameters
fsize = 10;

% Show actual phantom (target)
figure(6)
clf
imagesc(target)
colormap gray
axis square
axis off
title(['Shepp-Logan phantom at size ', num2str(N), 'x', num2str(N)],'fontsize',fsize)

% Take a look at the measurement WITH inverse crime
figure(1)
clf
subplot(1,3,1)
imagesc(m,[0,MAX])
colormap gray
axis square
axis off
title('With crime','fontsize',fsize)
% Take a look at the measurement WITHOUT inverse crime
subplot(1,3,2)
imagesc(mnc,[0,MAX])
colormap gray
axis square
axis off
title('Without crime','fontsize',fsize)
% Take a look at the difference between the two measurements
subplot(1,3,3)
imagesc(difference,[0,MAX])
colormap gray
axis square
axis off
title('Difference','fontsize',fsize)


