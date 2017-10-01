# ##############################################################################
#
#                      QUANTUM VECTOR MEASUREMENT FUNCTION
#
# ##############################################################################
#
# collapse.m
#
# Author: Yago Gonzalez
# Year: 2016
# License: MIT
#
# Collapse a vector that represents a quantum state, as if it was measured.
# The outcome of each configuration will depend on its probabilistic amplitude
#   (P(x) = (alpha_x) ^ 2)
#
# PARAMETERS
#   vector (column matrix) - Vector representing the state to collapse
#
# RETURNS
#   out (column matrix) - New state vector, with the collapsed
#       configuration's probabilistic amplitude set to 1
#   value (integer) - Value of the collapsed configuration, assuming the state
#       goes from 0 to n, and all configurations are natural numbers
#

function [out, value] = collapse(vector)
  r = rand(1);

  # Check that the vector is normalized
  t = 0;
  for i = 1:length(vector)
    t += abs(vector(i)) ^ 2;
  endfor

  if(t == 0)
      error("collapse: found no probabilistic amplitudes.\n input vector must be normalized (sum (a_i ^ 2) ~= 1).")
  endif

  k = 1 / t;  # Constant that assures the system is normalized

  # Collapse the state
  t = 0;
  i = 0;  # Iterator
  do
    t += (abs(vector(++i)) ^ 2) * k;
  until(t >= r)

  # Modify the vector to have a 1 in the collapsed state
  vector = zeros(length(vector), 1);
  vector(i) = 1;

  out = vector;
  value = i - 1;
endfunction