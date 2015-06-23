function [ is_overlap ] = box_box_test( ld1, ru1, ld2, ru2 )
%BOX_BOX_TEST Summary of this function goes here
%   Detailed explanation goes here
    w1 = ru1-ld1;
    w2 = ru2 - ld2;
    is_overlap = (abs(ld2(1)-ld1(1))*2 < w1(1) + w2(1))...
                 && ( abs(ld2(2) - ld1(2))*2 < w1(2) + w2(2) );
end

