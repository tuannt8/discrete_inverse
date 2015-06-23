function [ A ] = build_A( m, theta, s_num )
%BUILD_A Summary of this function goes here
%   Detailed explanation goes here

% Check input
if(isa(m, 'mesh') == 0)
    disp('Wrong mesh input');
    A=[];
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
    
    nb_measure = length(theta)*s_num;
    A = zeros(nb_measure , length(m.tris));
    
    for i = 1:length(theta)
        disp(['theta = ' num2str(i)]);
        for j  = 1:length(s)
            % Measure on s(j), theta(i)
            idx = (i-1)*s_num + j;
            
            the = theta(i);
            R = [cosd(the) -sind(the); sind(the) cosd(the)];
            s_direct = R*[1;0];
            pt = m.center + s_direct*s(j);
            
            for k = 1:length(m.tris)
                A(idx, k) = m.intersect(pt, s_direct, k);
            end
        end
    end

end

