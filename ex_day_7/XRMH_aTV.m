% Evaluates total variation penalty
%
%	aTV(f) = sum{sqrt((f_i-f_j)^2+beta}
%
% with i and j indexing all horizontally and vertically neighboring pixel 
% pairs.
%
% Arguments:
% f			evaluation point of size NxN
% beta 		smoothing parameter (positive)
%
% Samuli Siltanen March 2011

function aTV = XRMH_aTV(f,beta)

[row,col] = size(f);

% Regularization part 1: vertical differences
Vf = sqrt((f(1:(row-1),:)-f(2:row,:)).^2 + beta);

% Regularization part 2: horizontal differences
Hf = sqrt((f(:,1:(col-1))-f(:,2:col)).^2 + beta);

% Horizontal & vertical contribution
aTV = sum(sum(Vf))+sum(sum(Hf));
