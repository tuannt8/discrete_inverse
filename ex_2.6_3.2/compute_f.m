function [ out ] = compute_f( t )
%F Summary of this function goes here
%   Detailed explanation goes here

out = 2 * exp(-6*(t-0.8)^2) ...
        + exp(-2*(t+0.5)^2);

end

