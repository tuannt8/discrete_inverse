%% Load data
load 'forward.mat' A F_crime F_n_crime num_pt theta m_mesh;

nb_el = num_pt * length(theta);
m = reshape(F_n_crime, nb_el, 1);

noise_lvl = 0.1;
mn = m + randn(size(m))*noise_lvl*max(abs(m));

nb_tri = length(m_mesh.tris);

%% Solving total variation
alpha_a = [1 10 50 100 150 200 250 300 350];
x_b = zeros(nb_tri, length(alpha_a));
err_b = zeros(length(alpha_a), 1);

for ia = 1:length(alpha_a)

    alpha = alpha_a(ia);
    
    beta = 0.001;
    dt = 0.000001;
    max_iter = 100;

    %Init
    x = zeros(nb_tri, 1);

    x_k = zeros(nb_tri, max_iter);
    error = zeros(max_iter, 1);
    residual = zeros(max_iter, 1);

    for i = 1:max_iter

        % Compute gradient
        G1 = A'*A*x*2 - A'*mn*2;
        G2 = m_mesh.gradient_length(x, beta);

        G = G1+G2*alpha;
        x = x - G*dt;

        x_k(:,i) = x;
        error(i) = norm(x' - m_mesh.intensity , 2)^2;
        residual(i) = norm(A*x - mn, 2)^2;
    end

    % Best solution
    [ee, ii] = min(error);
    err_b(ia) = ee;
    x_b(:,ia) = x_k(:,ii);
end

%%
close all;

figure;
plot(alpha_a, err_b);
title('Error in relation to \alpha');

figure;
[em, idxm] = min(err_b);
m_mesh.plot_with_intensity(x_b(:,idxm));
colormap gray; axis image;

%%
close all;

figure;
plot(error)

figure;
m_mesh.plot_with_intensity(x_k(:,100));
colormap gray; axis image;