# ##############################################################################
#
#                 SIMON'S PROBLEM 'BLACK BOX' FUNCTION GENERATOR
#
# ##############################################################################
#
# simFuncGen.m
#
# Author: Yago Gonzalez
# Year: 2016
# License: MIT
#
# Program that generates truth tables for black box functions that are suitable
# for Simon's problem simulations
#
# PARAMETERS
#   n (integer) - Length of the binary strings operated by the function
#   prnt (boolean) - Whether to print or not the resulting table
#
# RETURNS
#   table (two-dimensinal matrix) - Matrix that has on the first column x, and
#       in the second one the corresponding images of the black box function
#       Keep in mind all values are IN BASE 10
#   secret (integer) - Secret that verifies that f(x) = f(x (BITWISE XOR) s)
#       Keep in mind its vale is IN BASE 10
#


function [table, secret] = simFuncGen(n, prnt = false)
  # Generate an array with non-repeated random values to return
  randOut = randperm(2 ^ n) - 1;
  randOut = randOut(1:((2 ^ n) / 2));
  
  # Generate random secret
  s = randi((2 ^ n) - 1);
  if(prnt)
    fprintf("Secret: %i (%s)\n", s, dec2bin(s, n));
  endif

  # Assign the values to a hashtable
  # (not a hashtable itself, but the indexes are used as keys)
  # TODO: Replace this with a table
  ht = nan(2 ^ n, 1);

  lastOutUsed = 0;

  for i = 1:(2 ^ n)
    if(isnan(ht(i)))
      ht(i) = randOut(++lastOutUsed);
      ht(bitxor(i - 1, s) + 1) = randOut(lastOutUsed);
     endif
  endfor

  # Print the table (if required)
  if(prnt)
    fprintf("    x   |  f(x)\n");
    fprintf(" ---------------\n");
    for i = 1:(2 ^ n)
      fprintf("  %s | %s\n", dec2bin(i - 1, n), dec2bin(ht(i), n));
    endfor
  endif
  
  # Produce the output
  secret = s;
  table = [0:2^n - 1;zeros(1,2^n)].';
  
  for i = 1:(2 ^ n)
    table(i, 2) = ht(i);
  endfor
endfunction