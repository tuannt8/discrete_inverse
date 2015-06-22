classdef mesh < handle
    %MESH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % vertices and triangle
        NP;         % Number of points
        points;     % [Nb, 2]
        NT;         % Number of triangle
        tris;       % [NT, 3]
        intensity;  % [NT, 1]
    end
    
    methods
        % Plot
        function plot(s)
            trimesh(s.tris, s.points(:,1), s.points(:,2), ones(s.NP,1));
            title('Triangle mesh');xlabel('x');ylabel('y');view(0, 90);
            
        end
        
        % Load data
        function load(s, filename)
            fID = fopen(filename, 'r');
            size = fscanf(fID, '%d %d', [1 2]);
            s.NP = size(1);
            s.NT = size(2);
            s.points = fscanf(fID, '%f %f', [2 s.NP])';
            s.tris = fscanf(fID, '%d %d %d', [3 s.NT])';
            fclose(fID);
            
            s.intensity = zeros(s.NT, 1);
        end
    end
    
end
