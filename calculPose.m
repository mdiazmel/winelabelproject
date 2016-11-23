function x = calculPose(a, b, c, d, R)

ap = R' * a;
bp = R' * b;
cp = R' * c;
dp = R' * d;

matAux = [ -1  0  0  0  0;
           0  -1  0 -1  0;
           0   0 -1  0  1];

ap_m = [ 0      -ap(3)  ap(2);
        ap(3)   0       -ap(1);
       -ap(2)   ap(1)   0];
   
bp_m = [ 0      -bp(3)  bp(2);
        bp(3)   0       -bp(1);
       -bp(2)   bp(1)   0];
   
cp_m = [ 0      -cp(3)  cp(2);
        cp(3)   0       -cp(1);
       -cp(2)   cp(1)   0];

dp_m = [ 0      -dp(3)  dp(2);
        dp(3)   0       -dp(1);
       -dp(2)   dp(1)   0];

A = [ ap_m * matAux;
      bp_m * matAux;
      cp_m * matAux;
      dp_m * matAux];

% Pour resoudre Ax=0 on utilise svd

[U, S, V] = svd(A);

x = V(:,5);
x = x/x(5,1);
  
  
  