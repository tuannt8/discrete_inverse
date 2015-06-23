% Init mesh

m_mesh = mesh;
m_mesh.load('Data/alien_2_low.txt');

m_mesh_higher = mesh;
m_mesh_higher.load('Data/alien_2_higher.txt');

%% Test intersection
num_pt = 30;
theta = 0:10:179;

%% Forward map
F_crime = forward(m_mesh, theta, num_pt);
F_n_crime = forward(m_mesh_higher, theta, num_pt);

%% A matrix
A = build_A(m_mesh, theta, num_pt);

%% Save
save 'forward.mat' A F_crime F_n_crime num_pt theta m_mesh;

%%
figure(1);
subplot(1,3,1);
imagesc(F_crime);
title('Measure with inverse crime');colormap(gray);axis image;

subplot(1,3,2);
imagesc(F_n_crime);
title('Measure with NO inverse crime');colormap(gray);axis image;

subplot(1,3,3);
imagesc(F_n_crime - F_crime);
title('Difference');colormap(gray);axis image;

