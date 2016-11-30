function x = pm_haar_inv(X,s)
%
% MATLAB function for pm Haar 1-D IDWT algorithm. 
% This function receives N (a power of two) Haar DWT coefficients in X
% and the number of stages (scales) decomposed in s, 
% computes the Haar IDWT, and returns the N real values in x.
%
% For the theory behind this algorithm and example input/output,
% please refer the paper:
% Fundamentals of the discrete Haar wavelet transform
% Duraisamy Sundararajan
% dsprelated.com, 2011
% articles/paper section
%
N = length(X); % length of the input vector 
b = N/2^s;sq2 = sqrt(2);fac=1/(sq2^s);
X(1:b) = X(1:b) * fac;
  for ns =1:s  % outer loop stepping over stages
    p = 1;q = 1;
    xpr(1:b) = X(1:b);
    xmr(1:b) = X(b+1:2*b) * fac;
    while(p <= b)  % inner loop stepping over each butterfly in a stage
      X(q + 1) = xpr(p) - xmr(p); X(q) = xpr(p) + xmr(p);
      p = p + 1; q = q + 2;
    end
    fac = sq2 * fac;
    b = b * 2;
  end
  x = X;
  
