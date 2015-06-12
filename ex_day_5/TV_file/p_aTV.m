function pr = p_aTV(x,row,col,beta)

% Routine for statistical deconvolution using approximate total variation (aTV) prior. 
% Evaluates the prior part of the log a posteriori function:
%
%	pr(x) = sum{sqrt((x_i-x_j)^2+beta}
%
% with i and j indexing all horizontally and vertically neighboring pixel pairs.
%
% Arguments:
% x			evaluation point of size [row*col,1], where [row,col] is size of the pixel image 
% row			number of rows in original image
% col			number of columns in original image
% beta 		smoothing parameter (positive)
%
% Samuli Siltanen Sept 2001

image = reshape(x,[row,col]);

% Regularization part 1: vertical differences
Vimage = sqrt((image(1:(row-1),:)-image(2:row,:)).^2 + beta);

% Regularization part 2: horizontal differences
Himage = sqrt((image(:,1:(col-1))-image(:,2:col)).^2 + beta);

% Horizontal & vertical contribution
pr = sum(sum(Vimage))+sum(sum(Himage));
