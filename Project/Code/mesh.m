classdef mesh < handle
    %MESH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % vertices and triangle
        NP;         % Number of points
        points;     % [2, Nb]
        NT;         % Number of triangle
        tris;       % [3, NT]
        intensity;  % [1, NT]
        NE;         % number of edge
        edge;       % [2, NE]
        tri_e_adjacent; % [2, NE]
        e_on_tri;
        
        % Temp for computation
        center;
    end
    
    methods
        %% Plot
        function plot_edge(s)
            trimesh(s.tris', s.points(1,:), s.points(2,:));
            view(0, 90);
        end
        
        function plot_face(s)
            trisurf(s.tris', s.points(1,:), s.points(2,:),...
                    zeros(s.NP,1), s.intensity);
            view(0, 90);
        end
        
        function plot_with_intensity(s, inten)
            trisurf(s.tris', s.points(1,:), s.points(2,:),...
                    zeros(s.NP,1), inten);
            view(0, 90);
        end
        
        function plot_face_idx(s)
            hold on;
            for i = 1:length(s.tris)
                pts = s.points(:, s.tris(:,i));
                c = (pts(:,1) + pts(:,2) + pts(:,3))/3;
                text(c(1), c(2), num2str(i));
            end
            hold off;
        end
        %% Gradient
        % x is the current intensity
        function gdx = gradient_length(s, x, beta)
            gdx = zeros(s.NT, 1);
            for i = 1:s.NT
                edges = s.e_on_tri(:,i);
                xi = x(i);
                for j = 1:3
                    eIdx = edges(j);
                    
                    triIdx = s.tri_e_adjacent(:, eIdx);
                    otherIdx = triIdx(1);
                    if otherIdx == i
                        otherIdx = triIdx(2);
                    end
                    x_other = 0;
                    if otherIdx > 0
                        x_other = x(otherIdx);
                    end
                    pts = s.points(:,s.edge(:,eIdx));
                    l = length2(pts(:,1)-pts(:,2));
                    gdx(i) = gdx(i) + ...
                        l*(xi - x_other)/sqrt((xi - x_other)^2 + beta);
                end
            end
            
        end
        
        %% Load data
        function load(s, filename)
            fID = fopen(filename, 'r');
            size = fscanf(fID, '%d %d', [1 2]);
            s.NP = size(1);
            s.NT = size(2);
            s.points = fscanf(fID, '%f %f', [2 s.NP]);
            s.tris = fscanf(fID, '%d %d %d', [3 s.NT]);
            s.intensity = (fscanf(fID, '%f', [1 s.NT]));
            
            [ld, ru] = s.get_corner;
            s.center = (ld + ru)/2;
            
            % edge
            s.NE = fscanf(fID, '%d', 1);
            ee = fscanf(fID, '%d %d %d %d', [4 s.NE]);
            ee = ee+1;
            s.edge = ee([1 2], :);
            s.tri_e_adjacent = ee([3 4], :);
            
            % edge on tri
            s.e_on_tri = zeros(3,s.NT);
            idx = ones(s.NT,1);
            for i = 1:s.NE
                tri_a = s.tri_e_adjacent(:,i);
                t1 = tri_a(1);
                t2 = tri_a(2);
                if t1 > 0
                    s.e_on_tri(idx(t1), t1) = i;
                    idx(t1) = idx(t1) + 1;
                end
                if t2 > 0
                    s.e_on_tri(idx(t2), t2) = i;
                    idx(t2) = idx(t2) + 1;
                end
            end
            
            fclose(fID);
        end
        
        
        %% Intersection
        function overlap = intersect(s, pt, p_norm, tIdx)
            
            % Test intersection first
            
            
            inter_P = zeros(2,3);
            idx = 1;
            
            verts = s.tris(:, tIdx);
            pts = s.points(:, verts);
            for i = 1:3
                [is_intersect, P] = line_seg_intersect(pt, p_norm,...
                                       pts(:,i), pts(:,mod(i+1, 3)+1));
                if is_intersect == -1 % Line identical
                    disp('Line - ray identical. Vertex is displaced');
                    pts(1,i) = pts(1,i) + 0.01; % Displace to avoid singular
                    [is_intersect, P] = line_seg_intersect(pt, p_norm,...
                                       pts(:,i), pts(:,mod(i+1, 3)+1));
                end
                
                if is_intersect == 1 
                    inter_P(:,idx) = P;
                    idx = idx + 1;
                end
            end
            
            if(idx == 3);
                overlap = length2(inter_P(:,1)-inter_P(:,2));
            elseif(idx==4)
                overlap = max([length2(inter_P(:,1)-inter_P(:,2)),...
                                length2(inter_P(:,2)-inter_P(:,3)), ...
                                length2(inter_P(:,3)-inter_P(:,1))]);
            else
                overlap = 0;
            end
            
        end
        
        %% Projection
        % Integration over an line
        function f = project(s, dis, theta)
            % Optimization later; Using search tree
            % For a single distance and single theta
        
            % rotation matrix
            R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
            s_direct = R*[1;0];
            pt = s.center + s_direct*dis;
            
            f = 0;
            for i = 1:length(s.tris)
                overLap = s.intersect(pt, s_direct, i);
                f = f + overLap*s.intensity(i);
            end
        end
        
        %% Get corner points
        function [ld, ru] = get_corner(s)
            ld = [Inf;Inf];
            ru = [-Inf;-Inf];
            for i = 1:length(s.points)
                p = s.points(:,i);
                
                ld(ld>p) = p(ld>p);
                ru(ru<p) = p(ru<p);
            end
        end
    end
    
end

