DC1_cont_data_comp;
DC2_discretedata_comp;

close all;
clear;

load DC2_discretedata A x n m mn mIC sigma
targ = DC_target(x);

n_a_m = [20 25 30 40]; % Use n_a sigular vector
[U D V] = svd(A);
for it = 1:length(n_a_m)
    n_a = n_a_m(it);

    Di_t = zeros(size(D));
    for i = 1:n_a
        Di_t(i,i) = 1/D(i,i);
    end
    Ai_t = V*Di_t*U';
    f = Ai_t*mn';
    
    % error
    err = norm(f-targ', 2)/norm(targ,2) * 100;
    
    subplot (length(n_a_m),2,2*(it-1)+1); 
    plot(U(:,n_a));
    title(['singular vector ' num2str(n_a)]);
    
    subplot (length(n_a_m),2,2*(it-1)+2);
    plot(x,f);
    hold on
    plot(x,targ, 'r--');
    hold off
    title(['Reconstruct using ' num2str(n_a) ...
            ' singular vectors; error:  ' num2str(err)]);
end
