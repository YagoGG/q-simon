function simonPlot(type, sett, export = false)
  hf = figure();
  
  rev = strcat("rev 1.1", strftime(" %Y/%m/%d - %R", localtime(time())));

  switch(type)
    case 1  # Right & wrong results / n
      nmin = sett(1);
      nmax = sett(2);
      rep = sett(3);
      
      # Total right/wrong matrix
      # Rows: R W
      # Columns: different n values
      trw = [];
      for n = nmin:nmax
        fprintf("Running for n = %i\n", n);
        [rw, qsteps, time] = simon(n, rep);
        trw = [trw; rw.'];
      endfor
      
      bar(nmin:nmax, trw);
      title(strcat("Right/Wrong results per value for n (", num2str(rep), " reruns)"), "fontsize", 15, "fontweight", "bold");
      xlabel("n values");
      ylabel("Reruns");
      legend("Right", "Wrong");
      
    case 2  # Average execution time / n
      nmin = sett(1);
      nmax = sett(2);
      rep = sett(3);
      log = sett(4);
      
      # Total run times matrix
      # Rows: times for each repetition
      # Columns: different n values
      trt = [];
      for n = nmin:nmax
        fprintf("Running for n = %i\n", n);
        [rw, qsteps, times] = simon(n, rep);
        trt = [trt; times];
      endfor
      
      # Find the average times for each n
      avgts = mean(trt, 2);
      
      fprintf("Elapsed execution time: %is\n", sum(trt(:)));
      
      if(log)
        semilogy(nmin:nmax, avgts, "-o", "markerfacecolor", "blue");
      else
        plot(nmin:nmax, avgts, "-o", "markerfacecolor", "blue");
      endif
      title(strcat("Classical execution time per value for n (", num2str(rep), " reruns)"), "fontsize", 15, "fontweight", "bold");
      xlabel("n values");
      ylabel("Classical time (s)");
    case 3 # Not used anymore. Kept for other graphs' ID number consistency
    case 4  # Average quantum steps / n
      nmin = sett(1);
      nmax = sett(2);
      rep = sett(3);

      # Total quantum steps matrix
      # Rows: quantum steps for each repetition
      # Columns: different n values
      tqs = [];
      for n = nmin:nmax
        fprintf("Running for n = %i\n", n);
        [rw, qsteps, times] = simon(n, rep);
        tqs = [tqs; qsteps];
      endfor
      
      # Find the average quantum steps for each n
      avgqs = mean(tqs, 2);
      
      fprintf("Elapsed quantum steps: %i\n", sum(tqs(:)));
      
      plot(nmin:nmax, avgqs, "-o", "markerfacecolor", "blue");
      title(strcat("Average quantum steps per value for n (", num2str(rep), " reruns)"), "fontsize", 15, "fontweight", "bold");
      xlabel("n values");
      ylabel("Number of quantum steps");
    case 5  # Average quantums steps + classical big-O / n (logarithmic)
      nmin = sett(1);
      nmax = sett(2);
      rep = sett(3);

      # Total quantum steps matrix
      # Rows: quantum steps for each repetition
      # Columns: different n values
      tqs = [];
      for n = nmin:nmax
        fprintf("Running for n = %i\n", n);
        [rw, qsteps, times] = simon(n, rep);
        tqs = [tqs; qsteps];
      endfor
      
      # Find the average quantum steps for each n
      avgqs = mean(tqs, 2);
      
      fprintf("Elapsed quantum steps: %i\n", sum(tqs(:)));
      
      semilogy(nmin:nmax, avgqs, "-o", "markerfacecolor", "blue");
      title(strcat("Average quantum steps per value for n (", num2str(rep), " reruns)"), "fontsize", 15, "fontweight", "bold");
      xlabel("n values");
      ylabel("Number of quantum steps");

      os = [];
      for n = nmin:nmax
        os = [os; pow2(n - 1)];
      endfor
      
      hold on;
      semilogy(nmin:nmax, os, "r", "markerfacecolor", "red");
      xlabel("n values");
      legend("Number of quantum steps", "Classical big-O notation (O(2n-1))");
    case 6 # Average quantum steps + average execution time / n (logarithmic)
      nmin = sett(1);
      nmax = sett(2);
      rep = sett(3);
      
      # Total run times matrix
      # Rows: times for each repetition
      # Columns: different n values
      tqs = [];
      trt = [];
      for n = nmin:nmax
        fprintf("Running for n = %i\n", n);
        [rw, qsteps, times] = simon(n, rep);
        tqs = [tqs; qsteps];
        trt = [trt; times];
      endfor
      
      # Find the average quantum steps for each n
      avgqs = mean(tqs, 2);
      # Find the average times for each n
      avgts = mean(trt, 2);
      
      fprintf("Elapsed quantum steps: %i\n", sum(tqs(:)));
      fprintf("Elapsed execution time: %is\n", sum(trt(:)));
      
      semilogy(nmin:nmax, avgqs, "-ob", "markerfacecolor", "blue", nmin:nmax, avgts, "-or", "markerfacecolor", "red");
      title(strcat("Average quantum steps per valor for n y average execution time (", num2str(rep), " reruns)"), "fontsize", 15, "fontweight", "bold");
      xlabel("n values");
    otherwise
      error("simonPlot: unknown type of plot.");
  endswitch
  
  # Version stamp
  annotation ("textbox", [0.01, 0.01, 20, 7], "string", rev, "edgecolor", "white");
  
  # Save to file
  if(export)
    set(hf, "visible", "off");
    print(hf, strcat("../plots/plotT", num2str(type) ,".pdf"), "-dpdflatexstandalone");
    set(hf, "visible", "on");
  endif
endfunction
