function [ X,rho,eta ] = cgls( target, b, theta, k )
%CGLS Summary of this function goes here
%   Detailed explanation goes here

% init

R = radon(target, 0);
m = length(R)*length(theta);
n = size(target,1)*size(target,2);
X = zeros(n,k);

% norm
eta = zeros(k,1); rho = eta;

% Prepare for CG iteration.
x = zeros(n,1);
d = iradon(target, b); %A'*b;
r = b;
normr2 = d'*d;

% Iterate.
for j=1:k
  % Update x and r vectors.
  Ad = radon(target, theta); % A*d; 
  alpha = normr2/(Ad'*Ad);
  x  = x + alpha*d;
  r  = r - alpha*Ad;
  s  = iradon(r, theta); %A'*r;
  
  % Update d vector.
  normr2_new = s'*s;
  beta = normr2_new/normr2;
  normr2 = normr2_new;
  d = s + beta*d;
  X(:,j) = x;
  
    % Compute norms, if required.
  if (nargout>1), rho(j) = norm(r); end
  if (nargout>2), eta(j) = norm(x); end
  
  
end

end

