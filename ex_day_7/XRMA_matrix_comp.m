% Here we construct a tomographic X-ray measurement model using a sparse 
% matrix A. (This is not very effective numerically, but it is used only 
% for demonstration purposes.) 
%
% Remark: this routine is computationally demanding with N greater than 64. 
%
% Jennifer Mueller and Samuli Siltanen, October 2011

% Construct phantom. You can modify the resolution parameter N.
% N      = 16;
global N;
target = phantom('Modified Shepp-Logan',N);

% Choose measurement angles (given in degrees, not radians). 
Nang    = N; 
angle0  = -90;
measang = angle0 + [0:(Nang-1)]/Nang*180;

% Initialize measurement matrix of size (M*P) x N^2, where M is the number of
% X-ray directions and P is the number of pixels that Matlab's Radon
% function gives.
P  = length(radon(target,0));
M  = length(measang);
A = sparse(M*P,N^2);

% Construct measurement matrix column by column. The trick is to construct
% targets with elements all 0 except for one element that equals 1.
for mmm = 1:M
    for iii = 1:N^2
        tmpvec                  = zeros(N^2,1);
        tmpvec(iii)             = 1;
        A((mmm-1)*P+(1:P),iii) = radon(reshape(tmpvec,N,N),measang(mmm));
        if mod(iii,100)==0
            disp([mmm, M, iii, N^2])
        end
    end
end

% Test the result
Rtemp = radon(target,measang);
Rtemp = Rtemp(:);
Mtemp = A*target(:);
disp(['If this number is small, then the matrix A is OK: ', num2str(max(max(abs(Mtemp-Rtemp))))]);

% Save the result to file (with filename containing the resolution N)
eval(['save RadonMatrix', num2str(N), ' A measang target N P Nang']);


