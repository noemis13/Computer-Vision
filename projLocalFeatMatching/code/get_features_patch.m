% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'descriptor_window_image_width', in pixels, is the local feature descriptor width. 
%   You can assume that descriptor_window_image_width will be a multiple of 4 
%   (i.e., every cell of your local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations, then you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features_patch(image, x, y, descriptor_window_image_width)

  % To start with, you might want to simply use normalized patches as your
  % local feature. This is very simple to code and works OK. However, to get
  % full credit you will need to implement the more effective SIFT descriptor
  % (See Szeliski 4.1.2 or the original publications at
  % http://www.cs.ubc.ca/~lowe/keypoints/)

  % Your implementmappingation does not need to exactly match the SIFT reference.
  % Here are the key properties your (baseline) descriptor should have:
  %  (1) a 4x4 grid of cells, each descriptor_window_image_width/4. 'cell' in this context
  %    nothing to do with the Matlab data structue of cell(). It is simply
  %    the terminology used in the feature literature to describe the spatial
  %    bins where gradient distributions will be described.
  %  (2) each cell should have a histogram of the local distribution of
  %    gradients in 8 orientations. Appending these histograms together will
  %    give you 4x4 x 8 = 128 dimensions.
  %  (3) Each feature should be normalized to unit length
  %
  % You do not need to perform the interpolation in which each gradient
  % measurement contributes to multiple orientation bins in multiple cells
  % As described in Szeliski, a single gradient measurement creates a
  % weighted contribution to the 4 nearest cells and the 2 nearest
  % orientation bins within each cell, for 8 total contributions. This type
  % of interpolation probably will help, though.

  % You do not have to explicitly compute the gradient orientation at each
  % pixel (although you are free to do so). You can instead filter with
  % oriented filters (e.g. a filter that responds to edges with a specific
  % orientation). All of your SIFT-like feature can be constructed entirely
  % from filtering fairly quickly in this way.

  % You do not need to do the normalize -> threshold -> normalize again
  % operation as detailed in Szeliski and the SIFT paper. It can help, though.

  % Another simple trick which can help is to raise each element of the final
  % feature vector to some power that is less than one.

  %Placeholder that you can delete. Empty features.
  features = zeros(size(x,1), 289, 'single');

  % Pego o tamanho da imagem que foi passado por parametro, isso porque
  %no for eu posso ter valores que ultrapassem o tamanho original da imagem
  [xOriginal yOriginal] = size(image);

  % O x e y vindo por parametro sao vetores, com as posicoes
  %que foram atribuidas no cheat_interest_points
  % O tamanho do vetor de x e y sao iguais
  for k = 1:size(x)
    % Dada uma imagem, pegar uma feature da imagem 16x16
    % Pega a posicao minima do eixo x
    x1 = x(k) - (descriptor_window_image_width / 2);
    x1 = uint32(x1);

    % Pega a posicao maxima do eixo x
    x2 = x(k) + (descriptor_window_image_width / 2);
    x2 = uint32(x2);

    % Pega a posicao minima do eixo y
    y1 = y(k) - (descriptor_window_image_width / 2);
    y1 = uint32(y1);

    % Pega a posicao maxima do eixo y
    y2 = y(k) + (descriptor_window_image_width / 2);
    y2 = uint32(y2);

    % Evita que valores negativos sejem acessados
    if(x1 > 0 && x2 > 0 && y1 > 0 && y2 > 0)
  
      % Depois verifico se nao tem algum valor que vai
      % acessar uma posicao que nao esteja dentro dos valores da foto
      if(x1 <= xOriginal && x2 <= xOriginal && y1 <= yOriginal && y2 <= yOriginal)
        pieceImage = image(x1 : x2, y1: y2);
  
        % Pega as dimensoes de X e Y
        [pieceX pieceY] = size(pieceImage);
        
        % Faco um array unidimensional
        z = 1;
      
        % Coloco os valores no array
        for i = 1:pieceX
          for j = 1:pieceY
            array(z) = pieceImage(i, j);
            z++;
          end
        end      
      
        % Normalizo esse array
        maxValue = max(array);
        minValue = min(array);

        % Percorro o vetor e vou normalizando o mesmo
        for i = 1:size(array)
          % Tinha caso que o minValue e maxValue era zero
          if(minValue == maxValue)
            array(i) = 1;
          else
            array(i) = (array(i) - minValue) / (maxValue - minValue);
          end
        end
      
        %Pode ser q array tem q transposto
        features(k, :) = array';
      end
    end
  end
end