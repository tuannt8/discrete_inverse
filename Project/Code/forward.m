function [ F ] = forward( m,  theta, s_num)
%FORWARD Forward model of tomography
%   m = mesh: the mesh
%   theta = R1: angle
%   s_num: size of measurement
%   F = R2: The measurement

% Check input
    if(isa(m, 'mesh') == 0)
        disp('Wrong mesh input');
        F=[];
        return;
    end
    
    if(nargin == 2)
        s_num = 100;
    end
    
% Projection
    [ld, ru] = m.get_corner;
    diag = (ru - ld)/2;
    ds = diag*2/(s_num - 1);
    s = -diag:ds:diag;
    
    F = zeros(length(s), length(theta)); 
    for i = 1:length(theta)
        disp(['\theta =  ' num2str(theta(i))]);
        for j  = 1:length(s)
            F(j,i) = m.project(s(j), theta(i));
        end
    end
end

