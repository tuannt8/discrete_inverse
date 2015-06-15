% This procedure evaluates the gradient of the approximate total variation penalty
%
%	aTV(f) = sum{sqrt((f_i-f_j)^2+beta}
%
% with i and j indexing all horizontally and vertically neighboring pixel pairs.
%
% Arguments:
% f   	Evaluation point of size NxN
% beta 	Smoothing parameter for approximate total variation prior
%
% Returns:
% grad	Gradient of approximate TV penalty at f
%
% Samuli Siltanen March 2011

function grad = XRMH_aTV_grad(f,beta)

[N,M] = size(f);
grad  = zeros(N*M,1);

for n=1:N
   for m=1:M
      grad((m-1)*N+n) = 0;
      if n<N
         grad((m-1)*N+n) = grad((m-1)*N+n) + ...
            (f(n,m)-f(n+1,m))/sqrt((f(n,m)-f(n+1,m))^2 + beta);
      end
      if n>1
         grad((m-1)*N+n) = grad((m-1)*N+n) - ...
            (f(n-1,m)-f(n,m))/sqrt((f(n-1,m)-f(n,m))^2 + beta);
      end
      if m<M
         grad((m-1)*N+n) = grad((m-1)*N+n) + ...
            (f(n,m)-f(n,m+1))/sqrt((f(n,m)-f(n,m+1))^2 + beta);
      end
      if m>1
         grad((m-1)*N+n) = grad((m-1)*N+n) - ...
            (f(n,m-1)-f(n,m))/sqrt((f(n,m-1)-f(n,m))^2 + beta);
      end      
   end
end

grad = reshape(grad,N,M);