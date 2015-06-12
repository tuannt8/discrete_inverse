function new = sumimage(image,n)

% Procedure that takes as argument a pixel image and sums the pixels
% contained in nxn submatrices. This way the size of the new image
% is approximately size(image)/n and the resolution of the new image 
% is n times the resolution of the argument image. If the number of
% rows or columns in the argument image is not divisible by n, the 
% argument image is truncated before summing.
%
% Samuli Siltanen Jan 2001

if n == 1
    new = image;
    return
end

[row,col] = size(image);
row       = row - mod(row,n);
col       = col - mod(col,n);
image     = image(1:row,1:col);

new = sum(reshape(image, n, row * col / n));
new = reshape(new.',row/n, col);
new = new.';
new = sum(reshape(new, n, row / n * col / n));
new = reshape(new.', col / n, row / n);
new = new.';



