function [ A ] = build_A_walnut( m )
%BUILD_A_WALNUT Summary of this function goes here
%   Detailed explanation goes here
    
    nb_theta = 120;
    nb_beam = 164;
    
    % Hardware
    w = 114.8;
    FDD = 300;
    FOD = 110;
    
    pm = (0:(nb_beam-1))*(w/(nb_beam-1)) - w/2;
    
    A = zeros(nb_theta*nb_beam, m.NT);
    
    for i = 1:nb_theta
        
        theta_base = 3*(i-1)*pi/180 - pi/2;
        disp(['theta = ' num2str(theta_base*180/pi)]);
        
        tt = zeros(m.NT, 1);
        
        for j = 1:nb_beam
            p = pm(j);
            theta_local = asin(p/FDD);
            
            s = FOD*p/FDD;
            theta_norm = theta_base + theta_local + pi/2;
            
            direct = [cos(theta_norm); sin(theta_norm)];
            pt = m.center + direct*s;
            
            idx = (i-1)*nb_beam + j;
            
            for k = 1:length(m.tris)
                A(idx, k) = m.intersect(pt, direct, k);
            end
            
            tt = tt + A(idx, :)';
        end
        
        figure(1);
        clf;
        m.plot_with_intensity(tt);
        title(['\theta = ' num2str(theta_base*180/pi)]);colormap gray; axis image;
        pause(0.01);
%         line_direct = [direct(2); -direct(1)];
%         center = m.center;
%         plot_line(pt - line_direct*50,pt+ line_direct*50, 'ro-');
%         axis image;
%         pause(0.1);
    end
end

