% Evaluates total variation penalty
%
%	pr(x) = sum{sqrt((x_i-x_j)^2+beta}
%
% with i and j indexing all horizontally and vertically neighboring pixel 
% pairs.
%
% Arguments:
% x			evaluation point of size NxN
% beta 		smoothing parameter (positive)
%
% Samuli Siltanen February 2011

function pr = XR_aTV(x,beta)

[row,col] = size(x);

% Regularization part 1: vertical differences
Vx = sqrt((x(1:(row-1),:)-x(2:row,:)).^2 + beta);

% Regularization part 2: horizontal differences
Hx = sqrt((x(:,1:(col-1))-x(:,2:col)).^2 + beta);

% Horizontal & vertical contribution
pr = sum(sum(Vx))+sum(sum(Hx));
