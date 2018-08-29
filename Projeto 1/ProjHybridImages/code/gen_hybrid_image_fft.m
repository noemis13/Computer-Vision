function [hybrid_image, low_frequencies, high_frequencies] = gen_hybrid_image_fft( image1, image2, cutoff_frequency )
% Inputs:
% - image1 -> The image from which to take the low frequencies.
% - image2 -> The image from which to take the high frequencies.
% - cutoff_frequency -> The standard deviation, in pixels, of the Gaussian 
%                       blur that will remove high frequencies.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the high frequencies from image1 by blurring it. The amount of
% blur that works best will vary with different image pairs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cria um padding
b = padarray(image1, size(image1), "zeros", "post");

% Converte para double
c = im2double(b(:,:,1:3));

%Faz o padding da imagem
d = fft2(c);

%Centraliza a transformada de fourier
d = fftshift(d);

% Pega as dimensoes da vaariavel c
[n m o] = size(c);

% Faz uma matriz de zeros com as dimensoes de n e m
h = zeros([n, m]);

%Construindo o filtro passa-baixa
for i = 1:n
  for j = 1:m
    h(i, j) = H(i, j, size(c), cutoff_frequency);
  end
end

% Multiplicando a matriz de transformada de Fourier pelo filtro
g = d.*h;

% Descentralizando a matriz
g = ifftshift(g);

% Aplicando a transformada inversa rapida
at = ifft2(g);

% Tira os valores negativos de at
at = abs(at);

% Pega as dimensoes da imagem 1
[x y o] = size(image1);

% Extrai da regiao X e Y
atc = at(1:x, 1:y, :);

% Atribuindo a imagem final
low_frequencies = atc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ALTA FREQUENCIA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cria um padding
b = padarray(image2, size(image2), "zeros", "post");

% Converte para double
c = im2double(b(:,:,1:3));

%Faz o padding da imagem
d = fft2(c);

%Centraliza a transformada de fourier
d = fftshift(d);

% Pega as dimensoes da vaariavel c
[n m o] = size(c);

% Faz uma matriz de zeros com as dimensoes de n e m
h = zeros([n, m]);

for i = 1:n
  for j = 1:m
    h(i, j) = H(i, j, size(c), cutoff_frequency);
  end
end

% Inverter a transformada
invert = ones(size(im2uint8(h)));
h = invert .- h;

% Multiplicando a matriz de transformada de Fourier pelo filtro
g = d.*h;

% Descentralizando a matriz
g = ifftshift(g);

% Aplicando a transformada inversa rapida
at = ifft2(g);

% Pega as dimensoes da imagem 2
[x y o] = size(image2);

% Extrai da regiao X e Y
atc = at(1:x,1:y, :);

% Atribuindo a imagem final
high_frequencies = atc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine the high frequencies and low frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hybrid_image = abs(low_frequencies + high_frequencies);
