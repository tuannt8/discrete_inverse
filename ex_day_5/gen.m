%% Generate image
global im_name noiselevel Npsf;
X = imread(im_name);
X = double(X);



[row,col]  = size(X);
X          = X(:,1:row);

% Construction of the point spread function
% Npsf    = 11;

tt      = linspace(-1,1,2*Npsf+1);
[t1,t2] = meshgrid(tt);
psf     = exp(-2*(t1.^2+t2.^2));
psf     = psf/sum(sum(psf));
p0      = psf(Npsf+1,Npsf+1);


% Construct ideal and noisy measurements m and mn
m          = conv2(X,psf,'same');
mn         = m + noiselevel*randn(size(m));

% Shrink data and psf to fourth to minimize the inverse crime
X   = sumimage(X,2);
mn  = sumimage(mn, 2);
psf = sumimage(psf,2);
psf = 1/sum(sum(psf))*psf;
p0  = psf(round(Npsf/2)+1,round(Npsf/2)+1);

figure;
subplot(1,2,1);
imagesc(X);
title('origin');
colormap gray;
axis square;
axis off;
subplot(1,2,2);
imagesc(mn);
title('with noise');
colormap gray;
axis square;
axis off;

save img_data psf noiselevel X mn p0