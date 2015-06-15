%% Simulated tomo data withour inverse crime

XRA_NoCrimeData_comp;

%% CLGS
theta = measang;
b = radon(target, theta); % measurement R
k = 10;

X = cell(k);

% norm
eta = zeros(k,1); rho = eta;

% Prepare for CG iteration.
x = zeros(N,N);
d = iradon(b, theta, 'linear', 'none', 1, N); %A'*b;
r = b;
normr2 = norm(d'*d,2)^2;

  imagesc(x);
  title(['k = 0']);
  pause(0.6);
  
close all;
figure;
% Iterate.
for j=1:k
  % Update x and r vectors.
  Ad = radon(target, theta); % A*d; 
  alpha = normr2/norm(Ad'*Ad, 2)^2;
  x  = x + alpha*d;
  r  = r - alpha*Ad;
  s  = iradon(r, theta, 'linear', 'none', 1, N); %A'*r;
  
  % Update d vector.
  normr2_new = norm(s'*s,2)^2;
  beta = normr2_new/normr2;
  normr2 = normr2_new;
  d = s + beta*d;
  X{j} = x;
  
    % Compute norms, if required.
  if (nargout>1), rho(j) = norm(r); end
  if (nargout>2), eta(j) = norm(x); end
  
  imagesc(x);
  title(['k = ' num2str(j)]);
  pause(0.6);
end

%% Reconstruction using filtered back-projection
XRB_FBP_comp;

%% Using matrix free Tikhonov
XRC_Tikhonov_comp;

%% Total variation
XRD_aTV_comp;