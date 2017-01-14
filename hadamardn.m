# ##############################################################################
#
#                       QUANTUM FOURIER TRANSFORM FUNCTION
#
# ##############################################################################
#
# hadamardn.m
#
# Author: Yago Gonzalez
# Year: 2016
# License: MIT
#
# Apply the Hadamard Transform (H) unitary transformation to the vector from the
# input
#
# PARAMETERS
#   vector (column matrix) - State vector to transform
#
function out = hadamardn(vector)
  if(isvector(vector))
    n = length(vector);
    nbits = log2(n);
    magnitude = 1 / sqrt(n);
 
    matrix = ones(n, n);
    for y = 1:n
      for x = 1:n
        matrix(y,x) = (-1) ^ dot((dec2bin(x - 1, nbits) - "0"), (dec2bin(y - 1, nbits) - "0"));
      endfor
    endfor
    
    ### disp("H^n (1/, matrix):") , disp(n), disp(matrix);
    out = magnitude * matrix * vector;
  else
    error("hadamardn: vector argument was expected.");
  endif
endfunction