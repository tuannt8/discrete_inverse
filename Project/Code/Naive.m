%% Load data
load 'forward.mat' A F num_pt theta m_mesh;

nb_el = num_pt * length(theta);
m = reshape(F, nb_el, 1);

noise_lvl = 0.05;
mn = m + randn(size(m))*noise_lvl*max(abs(m));

%% No noise
inten = A\m;
norm2 = norm(inten' - m_mesh.intensity, 2);

%% Noise
inten_n = A\mn;

%% No noise
figure(1);

subplot(1,2,1);
m_mesh.plot_face;
title('Original object'); colormap(flipud(gray));;axis image;

subplot(1,2,2);
m_mesh.plot_with_intensity(inten);
title('Naive no noise, with inverse crime');colormap(flipud(gray));axis image;

%% Noise
figure(1);

subplot(1,2,1);
m_mesh.plot_face;
title('Original object'); colormap(flipud(gray));;axis image;

subplot(1,2,2);
m_mesh.plot_with_intensity(inten_n);
title(['Naive with '  num2str(noise_lvl) ' noise, with inverse crime']);colormap(flipud(gray));;axis image;