# ##############################################################################
#
#                   BINARY MATRIX KERNEL CALCULATION FUNCTION
#
# ##############################################################################
#
# kernel.m
#
# Author: Yago Gonzalez
# Year: 2017
# License: MIT
#
# Generate the kernel (AKA null space) of a matrix in the Galois field of two
# elements (GF(2), or Z2).
# See https://en.wikipedia.org/wiki/Kernel_(linear_algebra) for details.
#
# This is the procedure followed in order to achieve it:
#
# 1. The identity matrix, I, is placed under the target matrix A.
# 2. A is turned into its column reduced echelon form, I', with operations that
#    change the original I, turning it into C.
#
#          ┌   ┐             ┌   ┐
#          │ A │   CREF(A)   │ I'│
#      B = │---│ ----------> │---│
#          │ I │             │ C │
#          └   ┘             └   ┘
#
# 3. The positions of the columns in I' that are full of zeroes are the
#    positions of the columns in C that make the basis of the kernel of A.
#
# Simulate the behavior of Simon's algorithm with random black box functions.
#
# PARAMETERS
#   A (matrix) - Matrix which null space has to be produced
#   verbose (boolean) - Whether to show or not debug information along the
#       process, mainly the steps followed while operating matrices.
#       Defaults to false
#
# RETURNS
#   N (matrix) - A matrix whose columns are the basis of A's null space
#   rank (integer) - The rank of A (considering it's binary matrix)
#

function [N, rank] = kernel(A, verbose = false)
  B = [A; eye(columns(A))];

  i = 1;
  while(i <= rows(A))
    j = i;  # Pivots must be included in/under A's main diagonal

    while(j < columns(A) && B(i, j) != 1)
      j++;
    endwhile # Found the pivot

    # Fill the row with zeroes, except for the pivot
    for(jp = 1:columns(B))
      if(jp != j && B(i, jp) == 1)  # Not the pivot column, and not a zero
        # Add the pivot's column to this one, to add a 0 to the working row
        B(:, jp) = xor(B(:, jp), B(:, j));
      endif

      if(verbose)
        printf("Pivot set to (%i, %i)\n", i, j);
        printf("Latest analysis position: (%i, %i)\n", i, j);
        disp(B), disp("");
      endif
    endfor

    # Swap the pivot's row with the one corresponding to this turn (so we can
    # assure that all pivots are in the main diagonal)
    B(:, [i j]) = B(:, [j i]);
    i++;
  endwhile

  Ip = B([1:rows(A)], :);
  C = B([(rows(A) + 1):end], :);
  results = !any(Ip);
  # The rank is the amount of columns that aren't full of zeroes
  rank = sum(!results);

  # In 1x2 matrices the any() function returns a scalar.
  if(rows(Ip) == 1)
    results = !Ip;
  endif

  if(verbose)
    disp("B:"), disp(B);
    disp("I':"), disp(Ip);
    disp("C:"), disp(C);
    disp("results:"), disp(results);
  endif

  N = [];

  for(j = 1:columns(A))
    if(results(j))  # Take each column in C iff it only has zeroes above
      N = [N, C(:, j)];
    endif
  endfor

 endfunction
