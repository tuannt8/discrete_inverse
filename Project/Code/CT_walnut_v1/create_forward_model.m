% Init mesh

m_mesh = mesh;
m_mesh.load('walnut_lower2.txt');

% Scale mesh to 42*42 mm
[ld, ru] = m_mesh.get_corner;
scale = 42/ru(1);
m_mesh.points = m_mesh.points*scale;
m_mesh.center = m_mesh.center*scale;

%% A
A = build_A_walnut(m_mesh);

%%
save 'A_164_120.mat' A;

%% 
m_mesh.plot_face;
axis image;
colormap gray;