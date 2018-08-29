function img2 = CalculaNovaIntensidade(img2, Coord)
    
    %Calcular as novas intensidades
    for i=1: size(img2)
      for j=1: size(img2)
        novaIntensidade = ( Coord(1)*(img2(i,j)^3)) + (Coord(2)*(img2(i,j)^2)) + (Coord(3)* img2(i,j)) + (Coord(4) );
        img2(i, j) = novaIntensidade;
      end
    end
    
endfunction   