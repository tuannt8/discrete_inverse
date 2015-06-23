function  plot_line( A, B , arg)
%PLOT_LINE Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2
   arg = [];
end

plot([A(1) B(1)], [A(2) B(2)], arg);
end

