function [rw, qsteps, times] = simon(n, rep = 1)
  debug_on_error (true, "local");

  outcomes = zeros(2, 1); # 1: Good result 2: Wrong result

  qsteps = [];
  times = [];
  i = 1;
  
  while(i <= rep)
    t0 = time();
    
    [f, s] = simFuncGen(n, true);

    system = [];
    yarr = [];

    do
      if(size(qsteps) < i)
        qsteps(i) = 0;
      else
        qsteps(i) += 5;
      endif
      
      y10 = routine(f, n);
      
      # Add new linear equation if y isn't 0 nor repeated
      if(y10 != 0)
        y = dec2bin(y10, n);
        
        eq = y - "0"; # Split binary string and turn it numeric
        
        disp("eq:"), disp(eq);
        
        # Check that the equation doesn't already exist, and is linearly indep
        if(modrank([system; eq], 2) == size(system)(1) + 1)
          system = [system; eq];
          yarr = [yarr; y10];
        else
        endif
      endif
    until(size(system)(1) == n - 1)    
    
    disp("System:"), disp(system);
    
    disp("Result (nullspace, before cleaning):"), disp(r);
    
    r (abs (r) < 1e-10) = 0; # Close-to-zero comps of s must be 0
    
    m = min(abs(r(r != 0)));
    r = r / m;
    r = round(r);
    r = mod(r, 2);

    r = num2str(r).';
    
    if(r == dec2bin(s, n))
      t = time() - t0;
      times = [times t];
      disp("RESULT OK!");
      outcomes(1)++;
    else
      disp("Expected:"), disp(dec2bin(s, n));
      outcomes(2)++;
      disp("WRONG RESULT!");
      error(strcat("simon: got a wrong result, " , r , " != ", dec2bin(s, n)));
    endif
    i++;
  endwhile
  
  fprintf("RESULTS:\n");
  fprintf(" %i passed\n %i failed\n", outcomes(1), outcomes(2));
  
  rw = outcomes;
endfunction
