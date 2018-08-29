pkg load image; 

image1 = imread('../data/img1.jpg');
image2 = imread('../data/img2.jpg');
image1patch = imread('../data/img1_patch.jpg');
image2patch = imread('../data/img2_patch.jpg');

% Canais RGB imgs1
imhist(image1(:,:,1));
figure, imhist(image1(:,:,2));
figure, imhist(image1(:,:,3));

red = image1patch(:,:,1); % Canal vermelho
green = image1patch(:,:,2); % Canal verde
blue = image1patch(:,:,3); % Canal azul

% Canais RGB imgs2
redIm2 = image2(:,:,1); % Canal vermelho
greenIm2 = image2(:,:,2); % Canal verde
blueIm2 = image2(:,:,3); % Canal azul

red2 = image2patch(:,:,1); % Canal vermelho
green2 = image2patch(:,:,2); % Canal verde
blue2 = image2patch(:,:,3); % Canal azul

% Simulated Annealing pra patchs
canalRed = SimulatedAnnealing(red, red2);
canalGreen = SimulatedAnnealing(green, green2);
canalBlue = SimulatedAnnealing(blue, blue2);

% Voltar para imagem original
%img_patch2 = cat(3, canalRed, canalGreen, canalBlue);

%Calcular par aimagem 2

%resolver o sistema 
%Mapear a intensidade
%novoRed1 = CalculaNovaIntensidade(redIm2, Coord);  
%novoGreen1 = CalculaNovaIntensidade(greenIm2, Coord);
%novoBlue1 = CalculaNovaIntensidade(blueIm2, Coord);
 
% Voltar para imagem original
i%mg_2 = cat(3, novoRed1, novoGreen1, novoBlue1);


%imwrite(img_2,'imagem_2_melhorada.jpg'); %salvar imagem
imwrite(img_patch2,'imagem_patch2_melhorada.jpg'); %salvar imagem
