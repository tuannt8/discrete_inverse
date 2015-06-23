%% Init data
clear;
clc;
close all;

m = mesh;
m.load('Data/mesh.txt');

figure(1);
m.plot_edge;
hold;
m.plot_face_idx;


figure(2);
m.plot_face;
title('Triangle mesh');xlabel('x');ylabel('y');view(0, 90);
colormap(flipud(gray));

%% Test intersection
direct = [1;1];
direct = direct/length2(direct);
theta = acos(dot(direct, [1; 0]))*180/pi;
dis = -30;

pt = m.center + direct*dis;
norm = [direct(2); -direct(1)];

figure(2);
hold on;
plot_line(pt, pt + norm*400, 'ro-');
plot_line(pt, pt - norm*400, 'ro-');
xlim([0 700]);ylim([0 500]);

%%
ov = m.project(dis,theta)