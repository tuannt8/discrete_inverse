m = mesh;
m.load('walnut.txt');

% Scale mesh to 42*42 mm
[ld, ru] = m.get_corner;
scale = 42/ru(1);
m.points = m.points*scale;
m.center = m.center*scale;

%%
    nb_theta = 120;
    nb_beam = 164;
    
    % Hardware
    w = 114.8;
    FDD = 300;
    FOD = 110;
    
%% Plot the hard ware
    [ld ru] = m.get_corner;
    off = (ru - ld)/2;
    Fpt = [-110; 0] + off;
    cp1 = [190; 57.4] + off;
    cp2 = [190; -57.4] + off;
    
    figure(1);
    m.plot_face;
    plot_line(Fpt, cp1, 'go-');
    plot_line(Fpt, cp2, 'go-');
    plot_line(cp2, cp1, 'go-');
    axis image;
%%
    
    pm = (0:(nb_beam-1))*(w/(nb_beam-1)) - w/2;
%%
% Theta
i = 1;


theta_base = 3*(i-1)*pi/180;
disp(['theta = ' num2str(theta_base*180/pi)]);

% s
j = 1;

p = pm(j);
theta_local = asin(p/FDD);

s = FOD*p/FDD;
theta_norm = theta_base + theta_local + pi/2;

direct = [cos(theta_norm); sin(theta_norm)];
pt = m.center + direct*s;

idx = (i-1)*nb_beam + j;

tt = 0;
iiTri = zeros(m.NT, 1);
for k = 1:length(m.tris)
    tt = m.intersect(pt, direct, k)*m.intensity(k);
    if tt > 0
        iiTri(k) = 1;
    end
end

close all;
figure(2);
m.plot_with_intensity(iiTri);
colormap gray; axis image;
hold;

line_direct = [direct(2); -direct(1)];
center = ru/2;
plot_line(center, center + direct*s, 'ro-');
plot_line(pt - line_direct*100,pt+ line_direct*100, 'ro-');

plot_line(Fpt, cp1, 'go-');
plot_line(Fpt, cp2, 'go-');
plot_line(cp2, cp1, 'go-');
axis image;