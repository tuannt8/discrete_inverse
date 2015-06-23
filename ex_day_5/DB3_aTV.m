% Routine for deconvolution based on approximate total variation 
% regularization. We use the Barzilai and Borwein optimization method.
%
% Jennifer Mueller, Samuli Siltanen and Sanna Tyrvainen, October 2012
global regparam;
%regparam   = 10; % Regularization parameter
beta    = .001; % Smoothing parameter
MAXITER = 300; % Number of iterations
nPSF    = 3;

% Read raw data from disc
F          = imread('Edelweiss_noisy.png','png');
m          = double(F);
[row,col]  = size(m);
m          = m(:,1:row);
[row,col]  = size(m);
m          = m(:);

% Build point spread function (PSF)
t       = [-1:(2/(nPSF-1)):(1-1e-8),1];
[t1,t2] = meshgrid(t);
PSF     = exp(-3*(t1.^2+t2.^2));
PSF     = PSF/sum(sum(PSF));

% Optimization routine
obj  = zeros(MAXITER+1,1); % We will monitor the value of the objective function
xold = m(:);              % Initial guess
gold = db_aTV_fgrad(xold,m,row,col,PSF,regparam,beta);
obj(1) = db_aTV_feval(xold,m,row,col,PSF,regparam,beta);

% Make the first iteration step. Theoretically, this step should satisfy the Wolfe
% condition, see [J.Nocedal, Acta Numerica 1992]. We use line minimization along
% the negative gradient direction.
disp('Taking the first step')
[t,fx] = db_linmin(xold, m, row, col, PSF, regparam, beta, -gold, 1e-3);

% Compute new iterate point xnew and gradient gnew at xnew
xnew     = xold - t*gold;
gnew     = db_aTV_fgrad(xnew,m,row,col,PSF,regparam,beta);
its      = 1;              % Iteration counter
obj(its+1) = fx;

disp('Starting iteration')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start Barzilai and Borwein iteration
while (its  < MAXITER)
    its = its + 1;
    
    % Store previous value of objective function
    fmin = fx;
    
    % Compute steplength alpha
    xdiff = xnew - xold;
    gdiff = gnew - gold;
    alpha = (xdiff.' * gdiff)/(xdiff.' * xdiff);
    
    % Update points, gradients and objective function value
    xold = xnew;
    gold = gnew;
    xnew = xnew - 1/alpha * gnew;
    gnew = db_aTV_fgrad(xnew,m,row,col,PSF,regparam,beta);    
    fx   = db_aTV_feval(xnew,m,row,col,PSF,regparam,beta);
    obj(its+1) = fx;
    format short e
    disp([its,log(obj(its))])
end   % Iteration while-loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
orig      = imread('Edelweiss.png','png');
orig      = double(orig);
[row,col] = size(orig);
orig      = orig(:,1:row);
[row,col] = size(orig);
final     = reshape(xnew,row,col);
m         = reshape(m,row,col);

figure(1)
clf
hold on
plot(obj,'*-')


figure(2)
clf

imagesc([m,final,orig])
colormap gray
axis equal
axis off
title(['Deblurring with beta=', num2str(beta),' and regparam=',...
    num2str(regparam),' and PSF radius ',num2str(nPSF), ...
    '. Left:data. Middle: reconstruction. Right: original.'])


figure(3)
clf
imagesc(final);
colormap gray
axis equal
axis off

