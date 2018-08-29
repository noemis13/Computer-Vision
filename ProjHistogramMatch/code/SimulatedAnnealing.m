function canalRGB = SimulatedAnnealing(img1, img2)

  % Diferença dos histogramas
  hist1 = imhist(img1);
  hist2 = imhist(img2);

  D = DifHist(hist1, hist2)
  
  %encontra 4 ponstos em x e 4 em y
  intervaloX = 84;
  intervaloY = 85;
  pontos = pontos2 = 1;
  
  for i = 1: 4
    pontosX(i) = pontos;
    pontosY(i) = pontos2;
    pontos += intervaloX;
    pontos2 += intervaloY;
  end
  
 
  temperatura = 100;
  i = 0;
  K = 5;
  contIndiceVizinho = 1;
  
  while(temperatura > 0.00001 )
    
    % Verificar se decrementa temperatura
    if i == K % Se a mesma temperatura rodou K vezes, decrementar ela
       temperatura = temperatura - 4;
       i = 0;
    endif
        
    % Pegar os pontos atuais para encontrar quatro novos vizinhos 
    novoX1 = pontosX(contIndiceVizinho);
    novoX2 = pontosX(contIndiceVizinho);
    novoY1 = pontosY(contIndiceVizinho);
    novoY2 = pontosY(contIndiceVizinho);
    
    % verificar se os polinomios sao crescentes
    % verificar se os vizinhos sao validos
    if (pontosX(contIndiceVizinho)+1 >= 1 && pontosX(contIndiceVizinho)+1 <= 256) && (pontosX(contIndiceVizinho)+1 > pontosX(contIndiceVizinho)) 
      novoX1 = pontosX(contIndiceVizinho)+1;
    endif
    if (pontosX(contIndiceVizinho)-1 >= 1 && pontosX(contIndiceVizinho)-1 <= 256)
      novoX2 = pontosX(contIndiceVizinho)-1;
    endif
    if (pontosY(contIndiceVizinho)+1 >= 1 && pontosY(contIndiceVizinho)+1 <= 256) && (pontosY(contIndiceVizinho)+1 > pontosY(contIndiceVizinho))
      novoY1 = pontosY(contIndiceVizinho)+1;
    endif
    if (pontosY(contIndiceVizinho)-1 >= 1 && pontosY(contIndiceVizinho)-1 <= 256) 
      novoY2 = pontosY(contIndiceVizinho)-1;
    endif
    
    %Escolher aleatoriamente um dos vizinhos para trabalhar
    r = randi([1, 4]);
    
    %calcular a diferenca dos histogramas para o vizinho escolhido
    testeVizinhoX = pontosX; 
    testeVizinhoY = pontosY;
    
    % Substituir o ponto atual pelo ponto do vizinho escolhido  
    if r == 1
      testeVizinhoX(contIndiceVizinho) = novoX1; %(x+1, y)
    elseif r == 2
      testeVizinhoX(contIndiceVizinho) = novoX2; %(x-1, y)
    elseif r == 3
      testeVizinhoY(contIndiceVizinho) = novoY1; %(x, y+1)
    elseif r == 4
      testeVizinhoY(contIndiceVizinho) = novoY2; %(x, y-1)
    endif
    
    
    % calcular diferença hist para os pontos atuais
    [Coord] = ResolvSistema(pontosX, pontosY);
    %Mapear a intensidade
    novaImagem = CalculaNovaIntensidade(img2, Coord);  
    % Calcular a nova diferença
    D = DifHist(hist1, imhist(novaImagem));
  
    %Calcular a diferenca hist para o vizinho escolhido
    %resolver o sistema 
    [CoordVizinho] = ResolvSistema(testeVizinhoX, testeVizinhoY);
    %Mapear a intensidade
    novaImagemVizinho = CalculaNovaIntensidade(img2, CoordVizinho);  
    % Calcular a nova diferença
    DVizinho = DifHist(hist1, imhist(novaImagemVizinho));
        
  
    % Calcular a diferenca das duas diferencas dos histogramas (atual e vizinho)
    deltaD = DVizinho - D;
   
    % Verificar o valor das diferencas para decidir se aceita ou nao a nova diferenca
    if deltaD <= 0 % novoD menor que a diferenca vizinho, entao aceita
      porcentagem = 1;
    else % calcula a porcentagem de aceitacao
      % expoencinal no octave e = 2.7183
      resolv = -deltaD/temperatura;
      porcentagem =  2.7183^(resolv);  
    endif

    %Verificar se a porcentagem sera aceita ou nao
    p = rand(1); %Sorteia qualquer numero entre 0 e 1 
  
    if (porcentagem == 1) || (porcentagem > p) %aceita pontos do vizinho
      pontosX = testeVizinhoX;
      pontosY = testeVizinhoY; 
    endif
      
    % calcular indice para ao proximo ponto que ira verificar seu vizinho
    contIndiceVizinho++;
    if(contIndiceVizinho == 5)
      contIndiceVizinho = 1; % se eu ja passei pelos quatro pontos para pegar seus vizinhos, volto para o primeiro pronto.
    end
    
    % incrementar indice 
    i = i+1;
    
  endwhile
  pontosX, pontosY  
  % Calcular a img2 final por meio da ultima curva obtida 
  %resolver o sistema 
  [Coord] = ResolvSistema(pontosX, pontosY);
  %Mapear a intensidade
  img2 = CalculaNovaIntensidade(img2, Coord);  
  
  canalRGB = img2;

endfunction