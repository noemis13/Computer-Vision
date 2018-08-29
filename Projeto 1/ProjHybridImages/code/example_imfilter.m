pkg load image;

entrada = [0 0 0 0 0; 0 0 0 0 0; 0 0 1 0 0; 0 0 0 0 0; 0 0 0 0 0];
filtro  = [1 2 3; 4 5 6; 7 8 9];

% Usa correlacao
imfilter(entrada, filtro)

% Usa convolucao
% imfilter(entrada, filtro, 'conv')