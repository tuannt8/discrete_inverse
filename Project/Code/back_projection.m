%% Load data
load 'forward.mat' A F_crime F_n_crime num_pt theta m_mesh;


nb_el = num_pt * length(theta);
m = reshape(F_n_crime, nb_el, 1);

noise_lvl = 0.1;
mn = m + randn(size(m))*noise_lvl*max(abs(m));

%% 

Rf = reshape(mn, num_pt, length(theta));
I = iradon(Rf, theta);


%% High pass filter the measurement

Rf = reshape(mn, num_pt, length(theta));

% Take fourier transform
FRf = fft(Rf);

% High pass filter
filter = (0:num_pt-1)'*(1/(num_pt-1));
for i = 1:length(theta)
    FRf(:,i) = FRf(:,i).*filter;
end
% Inverse Fourier Transform
mi = real(ifft(FRf));

%% Back projection
inten = zeros(m_mesh.NT);
for i = 1:length(m_mesh.NT)
    % Find all ray go through
    % Just project on any point
    % Test with center point first
    
end