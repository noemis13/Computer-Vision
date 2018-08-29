% Written by Henry Hu for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)

% Definir a quantidade de interações
pontPorInter = 8; %quantidade de pontos
distThresold = 0.05; %limite aceitável de erro 
p = 0.99; % taxa confiança
N = log(1-p)/log(1-(1-distThresold).^pontPorInter)

%N = 2;

% defirnir matriz auxiliar para utilizar na métrica de distância
tamMatches_a = size(matches_a, 1); %tamanho da matriz mataches_a
tamMatches_b = size(matches_b,1); % tamanho da matriz matches_b

%criar um vetor de 1 com tamanho dos matches_a e b
one_matches_a = ones(tamMatches_a,1);
one_matches_b = ones(tamMatches_b,1);
%criar matriz igual a matches_a e b com uma coluna a mais contendo valores 1
xa = [matches_a one_matches_a];
xb = [matches_b one_matches_b];

maxInliers = 0; % variável auxiliar para ajudar encontrar o maior número de inliers

%Obter a matriz fundamental e verificar seus inliers
for i=1: N
  % Escolher aleatoriamente 8 pontos de cada matches
  ponts = randi(size(matches_a,1), [pontPorInter,1]);
  ponts_match_a = matches_a(ponts,:);
  ponts_match_b = matches_b(ponts,:);
  
  %Obter a matriz fundamental
  Fmatrix = estimate_fundamental_matrix(ponts_match_a, ponts_match_b)
  
  %calcular métrica de distância baseada na matriz fundamental para contar o numero de inliers (xb * F * xa')
  metrica = sum((xb .* (Fmatrix * xa')'),2); % xb * F * xa'
  %vetor de inliers
  limEr = find(abs(metrica) <= distThresold); %metrica tem que ser menor que o limite de erro aceitável
  % encontra o número de inliers
  inliers = size( limEr , 1);  
  
  %Escolher o inlier que possui maior valor
  if (inliers > maxInliers)
     Best_Fmatrix = Fmatrix;
     maxInliers = inliers
     %armazenar o vetor de inliers correpondete ao maxInliers
     currentInliers  = limEr;   
  end 
endfor


%encontrar os inliers a e b de acordo com o máximo inliers encontrado

inliers_a = matches_a(currentInliers(1:maxInliers),:);
inliers_b = matches_b(currentInliers(1:maxInliers),:);
     
%inliers_a = matches_a(1:30,:);
%inliers_b = matches_b(1:30,:);


end

