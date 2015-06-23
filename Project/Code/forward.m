function [ F ] = forward( m,  theta, s_num)
%FORWARD Forward model of tomography
%   m = mesh: the mesh
%   theta = R1: angle
%   s_num: size of measurement
%   F = R2: The measurement

% Check input
    if(isa(m, mesh))
        disp('Wrong mesh input');
        return;
    end
    
    if(nargin == 2)
        s_num = 100;
    end

% Get the center point
    [ld, ru] = m.get_corner;
    center = (ld + ru)/2;
    
% Projection
    diag = (ru - ld)/2;
    ds = diag*2/(s_num - 1);
    s = -diag:ds:diag;
    F = zeros(length(s), length(theta));
    for i = 1:length(theta)
        F(:,i) = m.project(s, theta(i));
    end
end

