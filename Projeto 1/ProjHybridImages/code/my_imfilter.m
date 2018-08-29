function output = my_imfilter(image, filter)
  %conv = a filtragem eh realizada usando convolucao
  %replicate = a imagem eh preenchida usando a borda
  output = imfilter(image, filter, 'conv', 'replicate');
