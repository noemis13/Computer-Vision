function [result] = calc_magnitude(image)
  % Cria os filtros
  filtroSobelH = zeros(3, 3, "int8");
  filtroSobelV = zeros(3, 3, "int8");
  
  % Monta o filtro na horizontal
  filtroSobelH(1, 1) = -1;
  filtroSobelH(1, 2) = -2;
  filtroSobelH(1, 3) = -1;
  
  filtroSobelH(3, 1) = 1;
  filtroSobelH(3, 2) = 2;
  filtroSobelH(3, 3) = 1;
  
  % Monta o filtro na vertical
  filtroSobelV(1, 1) = -1;
  filtroSobelV(2, 1) = -2;
  filtroSobelV(3, 1) = -1;
  
  filtroSobelV(1, 3) = 1;
  filtroSobelV(2, 3) = 2;
  filtroSobelV(3, 3) = 1;
  
  % Replicando a magnitude
  imagemSobel = padarray(image, [1 1], "replicate");
  
  imagemSobelX = filter2(filtroSobelH, imagemSobel, 'valid');
  imagemSobelY = filter2(filtroSobelV, imagemSobel, 'valid');
  
  % Calculando a magnitude
  magnitude = abs(imagemSobelX) + abs(imagemSobelY);
  
  % Calcula o arctangente (Valores iguais a zero e negativos?)
  direcoes = atan2(imagemSobelY, imagemSobelX);
  
  % Converte radiano para graus (Essa conta ta certa?)
  direcoes = (direcoes * (180 / pi)) + 180;

  % Crio um vetor de 8 linhas, porque podemos ter oito ângulos 
  result = zeros(1, 8, "double");
  
  % Percorro vetor de direcoes 
  for x = 1 : size(direcoes(:), 1)
   if(floor(direcoes(:)(x) / 45) >= 8)
    result(1, 8) += magnitude(:)(x);
   else 
    result(1, floor(direcoes(:)(x) / 45) + 1) += magnitude(:)(x);
   end
  end
end