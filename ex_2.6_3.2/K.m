function [ kernel ] = K( s, t )
%K Summary of this function goes here
%   Detailed explanation goes here
temp = pi*(sin(s) + sin(t));
if temp == 0
    aa = 1;
else
    aa = sin(temp)/temp;
end

kernel = (cos(s) + cos(t))^2 ...
        * ...
         (aa)^2;
end

