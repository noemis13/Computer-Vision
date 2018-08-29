function [features] = get_features_sift(image, x, y, descriptor_window_image_width)

  %Placeholder that you can delete. Empty features.
  features = zeros(size(x,1), 128, 'single');

  % https://octave.sourceforge.io/octave/function/norm.html
  % https://octave.sourceforge.io/signal/function/xcorr2.html

  % Pego o tamanho da imagem que foi passado por parametro, isso porque
  %no for eu posso ter valores que ultrapassem o tamanho original da imagem
  [xOriginal yOriginal] = size(image);

  % O x e y vindo por parametro sao vetores, com as posicoes que foram atribuidas
  %no cheat_interest_points
  % O tamanho do vetor de x e y sao iguais
  for k = 1:size(x)
    % Dada uma imagem, pegar uma feature da imagem 16x16
    % Pega a posicao minima do eixo x
    x1 = x(k) - (descriptor_window_image_width / 2);
    x1 = uint32(x1);

    % Pega a posicao maxima do eixo x
    x2 = x(k) + (descriptor_window_image_width / 2 - 1);
    x2 = uint32(x2);

    % Pega a posicao minima do eixo y
    y1 = y(k) - (descriptor_window_image_width / 2);
    y1 = uint32(y1);

    % Pega a posicao maxima do eixo y
    y2 = y(k) + (descriptor_window_image_width / 2 - 1);
    y2 = uint32(y2);

    % Evita que valores negativos sejem acessados
    if(x1 > 0 && x2 > 0 && y1 > 0 && y2 > 0)
  
      % Depois verifico se nao tem algum valor que vai acessar uma posicao que nao esteja
      %dentro dos valores da foto
      if(x1 <= xOriginal && x2 <= xOriginal && y1 <= yOriginal && y2 <= yOriginal)
        pieceImage = image(x1 : x2, y1: y2);
        
        % A partir do pedaço da imagem que retiramos quebramos ela em 8 pedaços
        pieceY1 = 1;
        pieceY2 = 4;
        for i = 1:4
          pieceX1 = 1;
          pieceX2 = 4;
          for j = 1:4
            % Para esse pedaço de imagem calculamos a magnitude desse pedaço
            result = calc_magnitude(pieceImage(pieceX1 : pieceX2, pieceY1 : pieceY2));

            % Coloco no vetor de features
            pos = (i - 1) * 4 + j;
            features(k, ((pos - 1) * 8) + 1 : ((pos - 1) * 8) + 8) = result;
            
            pieceX1 = pieceX2 + 1;
            pieceX2 = pieceX1 + 3;
          end
          pieceY1 = pieceY2 + 1;
          pieceY2 = pieceY1 + 3;
        end
      end
    end
    
    % Aplico o gaussiano
    %filtroGaussiano = fspecial('gaussian', [16 16], 10);
    %features(k, :) = conv2(features(k, :), filtroGaussiano, 'same');
    
    % Pego o maior e o menor
    maxValue = max(features(k, :));
    minValue = min(features(k, :));
    
    % Percorro o vetor e vou normalizando o mesmo
    if(minValue == maxValue)
      features(k, :) = 1;
    else
      for z = 1:size(features, 2)
        features(k, z) = (features(k, z) - minValue) / (maxValue - minValue);
      end
    end
  end
end
