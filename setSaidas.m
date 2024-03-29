function fis = setSaidas(fis,saidas,classes)
% Cria a inferencia para a saida do sistema de inferencia fuzzy
% fis: Sistema de Inferencia Fuzzy
% saidas: Matriz com as saidas [Dados x numSaidas]
% classes: Vetor com a indicação da classe de cada saida [Dadosx1]
%   obs: as classes são determinados como valores numericos que variam
%   entre 1 ate o numero maximo de classes


numClasses = max(classes); %verifica o numero de classes
numSaidas = size(saidas,2);

for i = 1:numSaidas %loop para cada saida
    range = [min(saidas(:,i)), max(saidas(:,i))]; %atribui o range para o universo de discurso de saida
    fis = addOutput(fis,range); %adiciona novo output
    for j = 1:numClasses %verifica entre as classes existentes
        classeDados = saidas(classes==j,i); %valores de saida que pertencem a classe j
        media = mean(classeDados);
        parametros = [abs(min(classeDados)-media), media, abs(max(classeDados)-media), media]; %determina os parametros da função de pertinencia em relação aos dados presentes na classe
        fis = addMF(fis,fis.Output(i).Name,"gauss2mf",parametros);

    end
end
end

