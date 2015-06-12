% Routine for deconvolution based on approximate total variation 
% regularization. We use the Barzilai and Borwein optimization method.
%
% Jennifer Mueller, Samuli Siltanen and Sanna Tyrvainen, October 2012

global regparam;
global plot_flag Npsf;
% regparam   = 10; % Regularization parameter
beta    = 0.001; % Smoothing parameter; default 0.001
MAXITER = 300; % Number of iterations
nPSF    = Npsf;

load img_data psf noiselevel X mn p0

% Read raw data from disc
F          = mn;
m          = double(F);
[row,col]  = size(m);
m          = m(:,1:row);
[row,col]  = size(m);
m          = m(:);

% Build point spread function (PSF)
PSF     = psf;

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
    orig      = X;
    orig      = double(orig);
    [row,col] = size(orig);
    orig      = orig(:,1:row);
    [row,col] = size(orig);
    final     = reshape(xnew,row,col);
    m         = reshape(m,row,col);

if plot_flag == 1
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
end