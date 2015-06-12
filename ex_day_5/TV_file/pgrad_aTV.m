function grad = pgrad_aTV(x,N,M,beta)

% A function for statistical deconvolution. This procedure evaluates the  
% gradient of the approximate total variation prior
%
%	pr(x) = sum{sqrt((x_i-x_j)^2+beta}
%
% with i and j indexing all horizontally and vertically neighboring pixel pairs.
%
% Arguments:
% x   	Evaluation point of size [row*col,1], where [row,col] is size of the pixel image 
% N 		Number of rows in original image
% M	 	Number of columns in original image
% beta 	Smoothing parameter for approximate total variation prior
%
% Returns:
% grad	Gradient of pr(x) at x. Vector of size (row*col) x 1.
%
% Samuli Siltanen Sept 2001


x    = reshape(x,N,M);
grad = zeros(N*M,1);

for n=1:N
   for m=1:M
      grad((m-1)*N+n) = 0;
      if n<N
         grad((m-1)*N+n) = grad((m-1)*N+n) + ...
            (x(n,m)-x(n+1,m))/sqrt((x(n,m)-x(n+1,m))^2 + beta);
      end
      if n>1
         grad((m-1)*N+n) = grad((m-1)*N+n) - ...
            (x(n-1,m)-x(n,m))/sqrt((x(n-1,m)-x(n,m))^2 + beta);
      end
      if m<M
         grad((m-1)*N+n) = grad((m-1)*N+n) + ...
            (x(n,m)-x(n,m+1))/sqrt((x(n,m)-x(n,m+1))^2 + beta);
      end
      if m>1
         grad((m-1)*N+n) = grad((m-1)*N+n) - ...
            (x(n,m-1)-x(n,m))/sqrt((x(n,m-1)-x(n,m))^2 + beta);
      end      
   end
end

