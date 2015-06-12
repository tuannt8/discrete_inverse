% Example computations related to one-dimensional deconvolution.
% Demonstration of inversion by total variation regularization 
% using half-quadratic optimization.
%
% This routine needs Matlab's optimization toolbox.
%
% The following routines must be computed before this one:
% DC3_nocrimedata_comp.m
%
% Jennifer Mueller and Samuli Siltanen, October 2012

    
% Plot parameters
lwidth = .5;
thickline = 2;
fsize = 20;
msize = 4;

DC2_discretedata_comp;
close all;

% Load data computed using a very fine grid, avoiding inverse crime
load DC2_discretedata A x xx n m mn mIC sigma
recx = x;
% Choose data
data = mn(:);
n = length(data);

% Regularization parameter
alpha_a = logspace(1, -5, 10);
alpha_a = 0.01;
error = zeros(size(alpha_a));
record = zeros(n, length(alpha_a));

for i = 1:length(alpha_a)

alpha = alpha_a(i);


% Construct prior matrix of size (n)x(n). This implements difference
% between consecutive values assuming periodic boundary conditions.
L = eye(n);
L = L-[L(:,end),L(:,1:end-1)];

% Construct original signal for comparison
signal = DC_target(xx);

% Set maximum numbers of iterations
MAXITER = 800; % Matlab's default value is 200
QPopt   = optimset('quadprog');
QPopt   = optimset(QPopt,'MaxIter', MAXITER);


% Construct input arguments for quadprog.m
H           = zeros(3*n);
H(1:n,1:n)  = 2*A.'*A;
Aeq         = [L,-eye(n),eye(n)];
beq         = zeros(n,1);
lb          = [repmat(-Inf,n,1);zeros(2*n,1)];
ub          = repmat(Inf,3*n,1);
AA          = -eye(3*n);
AA(1:n,1:n) = zeros(n,n);
b           = [repmat(10,n,1);zeros(2*n,1)];
iniguess    = zeros(3*n,1);
f           = [-2*A.'*data; repmat(alpha,2*n,1)];


% Compute MAP estimate by constrained quadratic programming
% using alpha as regularization parameter
[uvv,val,ef,output] = quadprog(H,f,AA,b,Aeq,beq,lb,ub,iniguess,QPopt);
rec = uvv(1:n);

% Calculate relative error
truth  = DC_target(recx);
relerr = round(norm(rec(:)-truth(:))/norm(truth(:))*100);
disp(['Number of iterations: ', num2str(output.iterations)])


record(:,i) = rec;
error(i) = relerr;
end

% Take a look at the reconstruction
figure(6)
clf
plot(xx,signal,'k','linewidth',lwidth)
hold on
plot(x,rec,'k','linewidth',thickline)
text(0.9,1.5,[num2str(relerr),'%'],'fontsize',fsize)

% Axis settings
axis([0 1 -.5 2])
set(gca,'xtick',[0 1/2 1],'fontsize',fsize)
set(gca,'ytick',[0  1 2],'fontsize',fsize)
set(gca,'PlotBoxAspectRatio' , [2 1 1])
box off


figure;
semilogx(alpha_a, error);
xlabel('alpha');
ylabel('error (%)');
title(' Relative error (%) to noise');


