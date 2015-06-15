%% For all
global N; 
N = 16;

%% 3. Regularization using TSVD
XRME_SVD_comp;

%%
XRMF_truncSVD_comp;

%% 
close all;

%% Picard plot
pc = (ones(size(svals)) )./ svals;
uig = zeros(size(D,2),2);
mn_col = reshape(mn, size(U,1),1);
nn = sqrt(length(uig));
for i = 1:length(uig)
    uig(i) = abs(U(:,i)'*mn_col) / D(i,i);
end

figure;
xxx = 1:length(pc);

semilogy(xxx, svals);
hold;
% plot(xxx, pc);
semilogy(xxx, uig);
legend('\sigma_i', '<u(i), mn>');
% legend('1/\sigma_i', '\sigma_i', '<u(i), mn>');
% ylim([0 15]);
title('Picard plot, log scale');

%% 4. Tikhonov 
close all;
XRMG_Tikhonov_comp;

%% 5. Total variation
close all;
XRMH_aTV_comp;