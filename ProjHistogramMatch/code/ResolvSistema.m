function [I] = ResolvSistema(pontosX, pontosY)
  % ax³+bx²+cx+d=y

  x1 = pontosX(1);
  x2 = pontosX(2);
  x3 = pontosY(3);
  x4 = pontosY(4);

  y1 = pontosY(1);
  y2 = pontosY(2);
  y3 = pontosY(3);
  y4 = pontosY(4);
  
  A = [x1^3,x1^2,x1,1; x2^3,x2^2,x2,1; x3^3,x3^2,x3,1; x4^3,x4^2,x4,1];
  B = [y1; y2; y3; y4];
  [I] = A\B;

  
endfunction