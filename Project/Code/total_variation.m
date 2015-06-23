%% Load data
addpath('regu_tool/');

load 'forward.mat' A F_crime F_n_crime num_pt theta m_mesh;

nb_el = num_pt * length(theta);
m = reshape(F_n_crime, nb_el, 1);

noise_lvl = 0.05;
mn = m + randn(size(m))*noise_lvl*max(abs(m));

%% Solving total variation
alpha = 10;
beta = 0.001;
dt = 0.000001;
max_iter = 300;

%Init
nb_tri = length(m_mesh.tris);
x = zeros(nb_tri, 1);

for i = 1:max_iter
    
    % Compute gradient
    G1 = A'*A*x*2 - A'*mn*2;
    G2 = m_mesh.gradient_length(x, beta);
    
    G = G1+G2*alpha;
    x = x - G*dt;
    
    m_mesh.plot_with_intensity(x);
    title(['Iter = ' num2str(i)]); colormap gray; axis image;
    pause(0.01);
end