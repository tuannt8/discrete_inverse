close all;

P = [0 0];
n = [1 -1];

A = [-10 -10];
B = [10 10];

[ is_intersect, P_i ] = line_seg_intersect( P, n, A, B );

figure;
plot_line(A,B);
hold;
plot_line(P, P + n);
plot(P_i(1), P_i(2), 'o');