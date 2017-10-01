# ##############################################################################
#
#                    SIMON'S ALGORITHM SIMULATION FUNCTION
#
# ##############################################################################
#
# simon.m
#
# Author: Yago Gonzalez
# Year: 2016
# License: MIT
#
# Simulate the behavior of Simon's algorithm with random black box functions.
#
# PARAMETERS
#   n (integer) - Length of the binary strings to be used
#   rep (integer) - Amount of times the process should be repeated (with a new
#       random function each time)
#       Defaults to 1
#   verbose (boolean) - Whether to show or not debug information along the
#       process, like the amplitudes of the state vectors involved, or the
#       steps followed in operations with matrices. "RESULT OK"/"WRONG RESULT"
#       messages will be displayed, regardless of this setting
#       Defaults to false
#
# RETURNS
#   rw (column matrix) - A vector with two components: the amount of right and
#       wrong results of the simulation, in that order
#   qsteps (row matrix) - Amount of quantum steps taken to solve the problem
#       in each repetition
#   times (row matrix) - Time taken to execute the simulation for each
#     repetition
#

function [rw, qsteps, times] = simon(n, rep = 1, verbose = false)
  debug_on_error(true, "local");

  outcomes = zeros(2, 1); # 1: Good result 2: Wrong result

  qsteps = [];
  times = [];
  i = 1;
  
  while(i <= rep)
    t0 = time();

    [f, s] = simFuncGen(n, verbose);

    system = [];
    yarr = [];

    do
      if(size(qsteps) < i)
        qsteps(i) = 5;
      else
        qsteps(i) += 5;
      endif
      
      y10 = routine(f, n, verbose);
      
      # Add new linear equation if y isn't 0 nor repeated
      if(y10 != 0)
        y = dec2bin(y10, n);
        
        eq = y - "0"; # Split binary string and turn it numeric
        
        if(verbose)
          disp("eq:"), disp(eq);
        endif
        
        # Check that the equation doesn't already exist, and is linearly indep
        if(modrank([system; eq], 2) == size(system)(1) + 1)
          system = [system; eq];
          yarr = [yarr; y10];
        else
        endif
      endif
    until(size(system)(1) == n - 1)    
    
    r (abs (r) < 1e-10) = 0; # Close-to-zero comps of s must be 0
    
    m = min(abs(r(r != 0)));
    r = r / m;
    r = round(r);
    r = mod(r, 2);
    if(verbose)
      disp("system:"), disp(system);
    endif

    r = num2str(r).';
    
    if(r == dec2bin(s, n))
      t = time() - t0;
      times = [times t];
      printf("#%i: RESULT OK!\n", i);
      outcomes(1)++;
    else
      disp("Expected:"), disp(dec2bin(s, n));
      outcomes(2)++;
      printf("#%i: WRONG RESULT!\n", i);
      error(cstrcat("simon: got a wrong result, " , r , " (actual) != ",
        dec2bin(s, n), " (expected)"));
    endif
    i++;
  endwhile
  
  rw = outcomes;
endfunction
