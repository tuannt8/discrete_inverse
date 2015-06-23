%% Load data
load 'forward.mat' A F_crime F_n_crime num_pt theta m_mesh;

nb_el = num_pt * length(theta);
m_c = reshape(F_crime, nb_el, 1);

m_nc = reshape(F_n_crime, nb_el, 1);

noise_lvl = 0.05;
m_cn = m_c + randn(size(m_c))*noise_lvl*max(abs(m_c));


%% Noise, crime


%% No noise, no crime
inten_nc = A\m_nc;

figure(1);

subplot(1,2,1);
m_mesh.plot_face;
title('Original object'); colormap(gray);axis image;

subplot(1,2,2);
m_mesh.plot_with_intensity(inten_nc);
title('Naive no noise, WITHOUT inverse crime');colormap(gray);axis image;

%% No noise, crime
inten = A\m_c;

figure(1);

subplot(1,2,1);
m_mesh.plot_face;
title('Original object'); colormap(gray);axis image;

subplot(1,2,2);
m_mesh.plot_with_intensity(inten);
title('Naive no noise, with inverse crime');colormap(gray);axis image;

%% Noise, crime

inten_n = A\m_cn;

figure(1);

subplot(1,2,1);
m_mesh.plot_face;
title('Original object'); colormap(gray);axis image;

subplot(1,2,2);
m_mesh.plot_with_intensity(inten_n);
title(['Naive with '  num2str(noise_lvl) ' noise, with inverse crime']);colormap(gray);axis image;