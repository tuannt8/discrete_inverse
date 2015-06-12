%Solve diffusion equation Ut - Uxx = 0 in (0,Pi) with Dirichlet boundary
%condition and time  0< t < T by the Finite Difference Method
%Result will be a matrix where nth column contains the values of solution u along x-axis to time ht*n 
%Kim Knudsen 2012

%Initialization
% Num points
% 128 255 515
M = 32;

% Delta x
hx = pi/(M+1);
%Vector of interior points on x-axis
xvec  = (hx:hx:(pi-hx/2))';

%time step
d= 5/11;
ht = d*hx^2;

%dt = dx;
%s = dt/dx^2;

%End time T and number of steps
T = 1
N = ceil(T/ht)-1;


%Set up matrix A
A = diag((1-2*d)*ones(M,1))  + diag(d* ones(M-1,1),-1) + diag(d*ones(M-1,1),1);

%initialize result
u = zeros(M,N+2);

%Initial condition 
u(:,1) = phi2(xvec);


%Compute the solution and plot

% figure;
% plot([0;xvec;pi],[0;u(:,1);0]);

for n = 1:N+1
    u(:,n+1) = A*u(:,n);
%     plot([0;xvec;pi],[0;u(:,n+1);0]);
%     title(['Solution to heat eq at time t =',num2str(n*ht)])
%     pause(0.1);
end



% Condition number
K = cond(A);

close all
figure(1)

plot([0;xvec;pi],[0;u(:,N+2);0]);
hold on;
plot([0;xvec;pi],[0;exp(-4*T)*sin(2*xvec)*10;0],'r--');
legend('computed', 'exact');

%% Compute error
normu = norm(u(:,N+2), 'inf')

ur = exp(-T*4)*sin(xvec*2)*10;
relativeNorm = norm(u(:,N+2)-ur, 'inf')




