function[porcentagemDif] = DifHist(hist1, hist2)
  sub = hist2 - hist1;
  quadrado = sub.^2;
  porcentagemDif = sum(quadrado);
 
endfunction