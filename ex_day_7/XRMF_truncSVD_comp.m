% Here we compute the SVD of the sparse tomographic measurement matrix A
% using full matrix algorithms. This is not very efficient coding, and it
% is done only for educational purposes.
%
% The following routines must be run before this file:
% XRME_SVD_comp.m and XRMC_NoCrimeData_comp.m.
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Choose resolution
% N = 16;
global N;

% Plot parameters
fsize  = 10;
msize  = 15;

% Load noisy measurements from disc.
eval(['load XRMC_NoCrime', num2str(N), ' N mnc mncn']);
mn = mncn;

% Load singular value decomposition of the measurement matrix
eval(['load XRME_SVD', num2str(N), ' U D V A measang target N P Nang']);

% Demonstration of inversion by truncated SVD with several singular vectors
STEP  = floor((N^2-1)/40);
Nsvec = [1:STEP:N^2];
error_a = zeros(size(Nsvec));
for iii = 1:length(Nsvec)
    
    % Reconstruct from noisy data using only large singular values.
    Ns               = Nsvec(iii);
    [row,col]        = size(D.');
    Dplus            = sparse(row,col);
    svals            = diag(D);
    Dplus(1:Ns,1:Ns) = diag(1./svals(1:Ns));
    recn             = V*Dplus*U.'*mn(:);
    recn             = reshape(recn,N,N);
    
    % Calculate relative error of reconstruction
    relerr = round(norm(recn(:)-target(:))/norm(target(:))*100);
    error_a(iii) = relerr;
    
    % Take a look at the reconstruction
    figure(1)
    clf
    subplot(1,3,1)
    imagesc(reshape(V(:,Ns),N,N))
    colormap gray
    axis square
    axis off
    title('Singular vector')
    
    subplot(1,3,2)
    semilogy([1:length(svals)],svals,'b')
    hold on 
    semilogy([Ns Ns],[svals(end) svals(Ns)],'k--')
    semilogy([Ns],[svals(Ns)],'r.','markersize',msize)
%    axis([1 length(svals) svals(end) svals(1)])
    set(gca,'xtick',[Ns],'fontsize',fsize)
    axis square
    title('Singular value');
    box off
    
    subplot(1,3,3)
    imagesc(recn,[0,1])
    colormap gray
    axis square
    axis off
    title(['Error ', num2str(relerr),'%'],'fontsize',fsize)
   % pause(0.4);
end

figure;
plot(Nsvec, error_a);

%% My plot
Nsvec = [1 10 30 50 70 90 110 115 120 130 150 190];
for i = 1:12
    Ns = Nsvec(i);
    [row,col]        = size(D.');
    Dplus            = sparse(row,col);
    svals            = diag(D);
    Dplus(1:Ns,1:Ns) = diag(1./svals(1:Ns));
    recn             = V*Dplus*U.'*mn(:);
    recn             = reshape(recn,N,N);
    
    subplot(3,4,i);
        imagesc(recn);
    colormap gray
    axis square
    axis off
    title(['k = ' num2str(Nsvec(i))]);
end
