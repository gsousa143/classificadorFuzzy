function fCusto = otimizaClassificador(x,fis,entradas,classes)

fis = attMF(fis,x);



[classificacao,pertinenciaClasse,~] = evalClassificador(fis,entradas);

fCusto = calculaFuncional(classificacao,pertinenciaClasse,classes);
end