function [ is_intersect, P ] = line_seg_intersect( pt, p_norm, pt1, pt2 )
%LINE_SEG_INTERSECT Summary of this function goes here
%   Line: pt, pnorm
%   is_intersect = 0:   No intersection
%   is_intersect = 1:   intersection
%   is_intersect = -1:   line identical
P = [0;0];
if abs(dot( pt2-pt1, p_norm)) < 1e-12
    % Parallel line
    if length2(cross2(pt2-pt1, pt - pt1)) < 1e-12
        is_intersect = -1;
    else
        is_intersect = 0;
    end
else

    k = dot((pt-pt1), p_norm) / dot((pt2-pt1), p_norm);

    if k >= 0 && k <= 1
        is_intersect = 1;
        P = pt1 + (pt2-pt1)*k;
    else
        is_intersect = 0;
    end
end

end

