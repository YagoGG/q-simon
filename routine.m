function y = routine(f, n)
  # Create and collapse state vector containing f(x)
  phi = zeros(2 ^ n, 1);
  for i = 1: 2 ^ n
    phi(f(i, 2) + 1) = 1 / sqrt(2 ^ (n - 1));
  endfor
  
  [phi, value] = collapse(phi);
  disp("Collapsed image:"), disp(value);
  
  # Make equal superposition of x and x (BITWISE XOR) s
  psi = zeros(2 ^ n, 1);
  
  i = 0;  # Iterator
  for a = 1:2 # Find f(x) and f(x (BITWISE XOR) s)
    do
      v = f(++i, 2);
    until(v == value)
    
    psi(i) = 1 / sqrt(2);
  endfor
  disp("PSI:"), disp(psi);
  
  # Apply QFT to psi to get y
  psi = 1 / sqrt(2 ^ n) * hadamard(2 ^ n) * psi;
  disp("PSI (after H ^ n):"), disp(psi);
  
  [psi, y] = collapse(psi);
endfunction
