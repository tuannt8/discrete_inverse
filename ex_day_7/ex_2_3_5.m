%% Tomography model

s2 = sqrt(2);
A = [0 s2 0 0 0 s2 0 0 0
    s2 0  0 0 s2 0 0 0 s2
    0  0  0 s2 0 0 0 s2 0
    1  0  0 1  0 0 1 0  0
    0  1  0 0  1 0 0 1  0
    0  0  1 0  0 1 0  0 1];

% f1 - f3: colume
f1 = [4 4 5
      1 3 4
      1 0 2];
f2 = [5 6 2
      1 5 2
      4 0 -1];
f1c = reshape(f1, 9, 1);
f2c = reshape(f2, 9, 1);

% measurement
m1c = A*f1c;
m2c = A*f2c;

%% a
% f2 have -1: material only absort photon. -1 means it is a photon source.

%% b
% Have same result, but only nonnegative entries
% yes
f3 = [0 7 6
      0 7 1
      0 1 2];
f3c = reshape(f3, 9,1);
m3 = A*f3c;
m3 - m1c
%%
aa = A(1:6,4:9);
ff = aa^-1*m1c