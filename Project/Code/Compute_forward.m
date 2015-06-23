% Init mesh

m_mesh = mesh;
m_mesh.load('Data/mesh_small.txt');

%% Test intersection
num_pt = 30;
theta = 0:10:179;

%% Forward map
F = forward(m_mesh, theta, num_pt);

%% A matrix
A = build_A(m_mesh, theta, num_pt);

%% Save
save 'forward.mat' A F num_pt theta m_mesh;