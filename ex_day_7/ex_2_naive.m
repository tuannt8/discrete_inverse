%% For all
global N; 
N = 16;
global m_crime m_no_crime;
global naive_crime naive_crime_noise naive_no_crime naive_no_crime_noise;

%% 1. Data with inverse crime
XRMA_matrix_comp;

% Naive solve from computed data
XRMB_naive_comp;

m_crime = m;
naive_crime = naive_recon;
naive_crime_noise = naive_recon2;

%% 2. Data without inverse crime
close all;
XRMC_NoCrimeData_comp;

% Solve this data
XRMD_naive_comp;

m_no_crime = m;
naive_no_crime = naive_recon;
naive_no_crime_noise = naive_recon2;

%% Reuire 1
close all;
figure;
spy(A);

figure;
subplot(1,3,1);
imagesc(m_crime); colormap gray; axis image;
title('Measure with crime');

subplot(1,3,2);
imagesc(m_no_crime); colormap gray; axis image;
title('Measure without crime');

subplot(1,3,3);
imagesc(abs(m_crime - m_no_crime)); colormap gray; axis image;
title('Absolute differences');

figure;
subplot(2,2,1);
imagesc(naive_crime); colormap gray; axis image;
title('reconstruct with crime, no noise');

subplot(2,2,2);
imagesc(naive_no_crime); colormap gray; axis image;
title('reconstruct without crime, no noise');

subplot(2,2,3);
imagesc(naive_crime_noise); colormap gray; axis image;
title('reconstruct with crime, noise');

subplot(2,2,4);
imagesc(naive_no_crime_noise); colormap gray; axis image;
title('reconstruct without crime, noise');
% %% 3. Regularization using TSVD
% close all;
% XRME_SVD_comp;
% XRMF_truncSVD_comp;
% 
% %% 4. Tikhonov 
% close all;
% XRMG_Tikhonov_comp;
% 
% %% 5. Total variation
% close all;
% XRMH_aTV_comp;