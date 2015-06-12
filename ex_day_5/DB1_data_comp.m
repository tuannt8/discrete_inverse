% Construct blurred and noisy image.
%
% Inverse crime is minimized by using function sumimage.m after adding
% noise and blur to image.
%
% Jennifer Mueller, Samuli Siltanen and Sanna Tyrvainen, October 2012

% Choose noise amplitude
global noiselevel;
% noiselevel = 0.04;

% Construct example signal (two-dimensional)
N = 1024;
r1 = 160^2;
r2 = 20^2;
X = zeros(N,N);
[x y] = meshgrid(1:N); 

X(round(N/4):round(N/2),round(N/4):round(N/2)) = 1;
X((x-3*N/4).^2+(y-3*N/4).^2 < r1)= .5;

X((x-3*N/4).^2+(y-N/3).^2 < r2)= .5;
X((x-9*N/10).^2+(y-N/6).^2 < r2/4)= .5;
X((x-8*N/9).^2+(y-2*N/5).^2 < r2/6)= .5;
X((x-3*N/5).^2+(y-N/6).^2 < r2/8)= .5;
X(:,round(N/6):(round(N/6)+1)) = 1;

X(y - x > N/2) = .4;

y = round(N/6);
X(:,y:y+1) = 1;
X(:,y-50:y-49) = 1;

[row,col]  = size(X);
X          = X(:,1:row);


% Construction of the point spread function
Npsf    = 26;
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

% Save results to file
save img_data psf noiselevel X mn p0
 
% Plot the data
% figure(1)
% clf
% imagesc(mn)
% colormap gray
% title('Measurement: blurred and noisy image')
% axis square
% axis off