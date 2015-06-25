%% Init
m_mesh = mesh;
m_mesh.load('walnut_lower2.txt');

% Scale mesh to 42*42 mm
[ld, ru] = m_mesh.get_corner;
scale = 42/ru(1);
m_mesh.points = m_mesh.points*scale;
m_mesh.center = m_mesh.center*scale;

load Data164 m
load 'A_164_120.mat' A;

nb_theta = 120;
nb_beam = 164;

m = reshape(m, nb_theta*nb_beam, 1);

nb_tri = length(m_mesh.tris);

AtA2 = A'*A*2;
Atm2 = A'*m*2;
%%

alpha =20;
beta = 0.01;
dt = 0.00001;
max_iter = 300;

x = zeros(nb_tri, 1);

x_k = zeros(nb_tri, max_iter);
residual = zeros(max_iter, 1);

for i = 1:max_iter
    disp(['iter ' num2str(i)]);
    
    G1 = AtA2*x - Atm2;
    G2 = m_mesh.gradient_length(x, beta);
    
    G = G1+G2*alpha;
    x = x - G*dt;
     
    x_k(:,i) = x;
    
%     m_mesh.plot_with_intensity(x);
%     colormap gray; axis image;
%     
%     pause(0.1);
    
    residual(i) = norm(A*x - m, 2)^2;
end


    m_mesh.plot_with_intensity(x_k(:,300));
    colormap gray; axis image;