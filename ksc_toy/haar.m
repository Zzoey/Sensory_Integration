x = [0 1 2 3 4 5 6 7];
s = 3; % number of stages of computation required, s = 1,2,...,log2(N),
% where N is the number of elements in the input vector x. N is an
% integral power of two
X = pm_haar(x,s); % Invoke pm_haar.m for
% computing the forward DWT
X % the Haar DWT of input vector x after s stages of computation
x = pm_haar_inv(X,s);  % Invoke pm_haar_inv.m 
% for computing the IDWT
x % the given input after s stages of inverse computation

% Main program for calling functions to compute forward and inverse
% 2-D Haar DWT
% functions pm_haar.m and pm_haar_inv.m are required in the same directory
clear;
% Example input x2 = [
% 1 2 -1 3
% 2 1 4 3
% 1 1 2 2
% 4 2 1 3
% ]
% scale = 2
% Example output X = [
% 7.7500   -0.7500         0   -1.5000
%-0.2500   -0.7500    1.0000   -1.0000
%      0   -2.5000   -1.0000   -2.5000
%-2.0000         0   -1.0000    1.0000
% ]
x2 = [1 2 -1 3;2 1 4 3;1 1 2 2;4 2 1 3];
N = size(x2,1); % size of each row, N must be an integral power of two 
scale = 2; % number of stages (scales) of computation required,
% s = 1,2,...,log2(N)
lim = N; % size of the row or column of the subimage in different stages 
% computation of the forward 2-D Haar DWT of x2 by row-column method
for k=1:scale % compute the 2-D DWT scale by scale
%    
for j=1:lim
    x = x2(j,1:lim); % copy each row of input
    X = pm_haar(x,1); % Invoke pm_haar.m to compute each row DWT
    x2(j,1:lim) = X;
end
%
for j = 1:lim
    x = x2(1:lim,j); % copy each column of the result of row DFTs
    X = pm_haar(x',1);  % Invoke pm_haar.m to compute each column DWT
    x2(1:lim,j) = X';
end
lim = lim / 2; % transform size reduced for each scale
end
x2 % 2-D DWT of x2 

% computation of the 2-D Haar IDWT of x2 by row-column method
lim = N/(2^(scale-1)); % size of the row or column of the subimage in
% different stages computation of the 2-D Haar IDWT of x2 by
% row-column method
for k = 1:scale % compute the 2-D IDWT scale by scale

for j = 1:lim
    X = x2(j,1:lim);  % copy each row of the coefficients
    x = pm_haar_inv(X,1); % Invoke pm_haar_inv.m to compute each row IDWTs
    x2(j,1:lim) = x;
end
%
for j = 1:lim
    X = x2(1:lim,j);  % copy each column of the results of row IDWTs
    x = pm_haar_inv(X',1); % Invoke pm_haar_inv.m to compute column IDWTs
    x2(1:lim,j) = x';
end
lim = lim * 2; % transform size increased for each scale
end
%
x2