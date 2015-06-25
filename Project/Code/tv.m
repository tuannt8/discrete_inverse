%%

alpha = 0.1;
beta = 0.001;
dt = 0.0001;
max_iter = 100;

x = zeros(nb_tri, 1);

x_k = zeros(nb_tri, max_iter);
AtA2 = A'*A*2;
Atm2 = A'*m*2;
residual = zeros(max_iter, 1);

for i = 1:max_iter
    disp(['iter ' num2str(i)]);
    
    G1 = AtA2*x - Atm2;
    G2 = m_mesh.gradient_length(x, beta);
    
    G = G1+G2*alpha;
    x = x - G*dt;
     
    x_k(:,i) = x;
    
    m_mesh.plot_with_intensity(x);
    colormap gray; axis image;
    
    pause(0.1);
    
    residual(i) = norm(A*x - m, 2)^2;
end

%%

[U s V] = csvd(A);
%%
[x_k,rho,eta] = tsvd(U,s,V,m,[400]);