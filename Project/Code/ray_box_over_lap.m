function [ is_intersect ] = ray_box_over_lap( ld_b, ru_b, pt, p_norm )
%RAY_BOX_OVER_LAP Summary of this function goes here
%   Detailed explanation goes here
    
    b1 = [ld_b(1); ru_b(2)];
    b2 = [ru_b(1); ld_b(2)];

    a = zeros(4,1);
    a(1) = dot(ld_b - pt, p_norm);
    a(2) = dot(ru_b - pt, p_norm);
    a(3) = dot(b1 - pt, p_norm);
    a(4) = dot(b2 - pt, p_norm);
    
    is_intersect = min(a)*max(a) < 0;
end

