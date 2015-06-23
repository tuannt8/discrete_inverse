%% Init data
clear;
clc;
close all;

m_mesh = mesh;
m_mesh.load('Data/mesh.txt');

%% 
% figure(1);
% m.plot_edge;
% hold;
% m.plot_face_idx;


figure(2);
m_mesh.plot_face;
title('Triangle mesh');xlabel('x');ylabel('y');view(0, 90);
colormap(flipud(gray));

%% Test intersection
num_pt = 30;
theta = 0:5:180;

%% Forward map
F = forward(m_mesh, theta, num_pt);

%% A matrix
A = build_A(m_mesh, theta, num_pt);

%% Test
nb_measure = num_pt * length(theta);
m = reshape(F, nb_measure, 1);

inten = A\m;

%%
figure(3);
m_mesh.plot_with_intensity(inten);
title('Naive without noise');xlabel('x');ylabel('y');view(0, 90);
colormap(flipud(gray));

%%
figure(4);
imagesc(F);
colormap gray;