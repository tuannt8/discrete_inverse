%% Simulated tomo data withour inverse crime

XRA_NoCrimeData_comp;

%% CLGS
close all;
theta = measang;
b = mncn;
figure;
imagesc(b);
colormap gray;
%%
k = 50;

X = cell(k);

% norm
eta = zeros(k,1); rho = eta;

% Prepare for CG iteration.
x = zeros(N,N);
d = iradon(b, theta, 'linear', 'none', 1, N); %A'*b;
r = b;
normr2 = norm(d,2)^2;


figure;
  imagesc(x);
  title('k = 0');
  pause(0.6);
  
  error_a = zeros(k,1);

% Iterate.
for j=1:k
  % Update x and r vectors.
  Ad = radon(d, theta); % A*d; 
  alpha = normr2/norm(Ad, 2)^2;
  x  = x + alpha*d;
  r  = r - alpha*Ad;
  s  = iradon(r, theta, 'linear', 'none', 1, N); %A'*r;
  
  % Update d vector.
  normr2_new = norm(s,2)^2;
  beta = normr2_new/normr2;
  normr2 = normr2_new;
  d = s + beta*d;
  
  
%   X{j} = x;
    % Compute norms, if required.
  rho(j) = norm(r);
  eta(j) = norm(x);
  error_a(j) = norm(x-target);
%   imagesc(x);
%   title(['k = ' num2str(j)]);
%   colormap gray;
%   pause(0.6);
end

  imagesc(x);
  title(['k = ' num2str(j)]);
  colormap gray;

  %%
  figure;
  plot(error_a);
  
  figure;
  loglog(rho, eta);
  title('L curve');
% %% Reconstruction using filtered back-projection
% XRB_FBP_comp;
% 
% %% Using matrix free Tikhonov
% XRC_Tikhonov_comp;
% 
%% Total variation
 XRD_aTV_comp;