function fCusto = calculaFuncional(classificacao,pertinenciaClasse,classes)
numDados = size(classes,1);

pertinenciaClasseReal = zeros(size(classes));
for i =  1:numDados
    pertinenciaClasseReal(i) = pertinenciaClasse(i,classes(i));
end
taxaDeAcerto = sum(classificacao==classes)/numDados;
fCusto = -0.1*mean(pertinenciaClasseReal)-taxaDeAcerto;


matrizConfusao = confusionmat(classes,classificacao);
confusionchart(matrizConfusao);
title("Taxa de Acertos: "+string(sum(classificacao==classes))+"/"+string(numDados)+", "+string(taxaDeAcerto*100)+"%"+", "+string(mean(pertinenciaClasseReal)));
drawnow;
end

