classdef spatial_hash < handle
    %SPATIAL_HASH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ld, ru; % corner
        dim; % dimension; number of spatial in each dimension
        dxy; % 
        contain; % [][]cell include triangle
    end
    
    methods
        function init(s, m)
            if(isa(m, 'mesh') == 0)
                disp('Wrong mesh input');
                return;
            end
            
            nb_face = length(m.tris);
            % Each space have 10 tri
            
            s.dim = ceil(sqrt(nb_face / 10));
            [s.ld, s.ru] = m.get_corner;
            diag = s.ru - s.ld;
            
            s.dxy = [diag(1)/s.dim; diag(2)/s.dim];
            
            s.contain = cell(s.dim, s.dim);
            for ix = 1:s.dim
                for jy = 1:s.dim
                    [ld_b, ru_b] = s.get_spartial_box(ix, jy);
                    
                    tri_list = [];
                    for t = 1:length(m.tris)
                        verts = m.points(:, m.tris(:,t));
                        ld_t = min(verts, [], 2);
                        ru_t = max(verts, [], 2);
                        if(box_box_test(ld_b, ru_b, ld_t, ru_t))
                            tri_list = [tri_list t];
                        end
                    end
                    
                    s.contain{ix, jy} = tri_list;
                    
                end
            end
        end
        
        
        function [ld_b, ru_b] = get_spartial_box(s, ix, iy)
            ld_b = s.ld + [(ix-1)*s.dxy(1); (iy-1)*s.dxy(2)];
            ru_b = ld_b + s.dxy;
        end
    end
    
end

