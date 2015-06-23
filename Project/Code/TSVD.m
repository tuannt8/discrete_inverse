%% Load data
load 'forward.mat' A F num_pt theta m_mesh;

nb_el = num_pt * length(theta);
m = reshape(F, nb_el, 1);

noise_lvl = 0.05;
mn = m + randn(size(m))*noise_lvl*max(abs(m));

%% Solving
[U, s, V] = csvd(A);
k = 1:length(s);
[x_k,rho,eta] = tsvd(U,s,V,mn,k);

%% Plot picard
picard(U,s,mn);

%% L curve
loglog(eta, rho);
title('L curve'); xlabel('eta'); ylabel('rho');

%% 
for i = 1:size(x_k, 2)
    inten = x_k(:,i);

    m_mesh.plot_with_intensity(inten);
    title(['TSVH noise = ' num2str(noise_lvl) '; ']);colormap(flipud(gray));axis image;
    
    pause(0.3);
end
%% 
