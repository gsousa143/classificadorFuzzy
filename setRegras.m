function fis = setRegras(fis,entradas,saidas,classes)
% Cria a sistema de regras para saida do sistema de inferencia fuzzy
% fis: Sistema de Inferencia Fuzzy
% entradas: Matriz com as entradas [Dados x numEntradas]
% saidas: Matriz com as saidas [Dados x numSaidas]
% classes: Vetor com a indicação da classe de cada saida [Dadosx1]
%   obs: as classes são determinados como valores numericos que variam
%   entre 1 ate o numero maximo de classes


numClasses = max(classes);
numEntradas = size(entradas,2);
numSaidas = size(saidas,2);
numMF = size(fis.Input(1).mf,2);
numDados = size(classes,1);


uEntradas = zeros(numDados,numEntradas,numMF); %matriz com pertinencia das variaveis de entrada
for j = 1:numEntradas
    for k = 1:numMF
        x = entradas(:,j);
        mf = fis.Input(j).mf(k);
        uEntradas(:,j,k) = evalmf(mf,x);
    end
end
[uEntradasMax, iuEntradasMax] = max(uEntradas,[],3);
uEntradasMaxMax = sum(uEntradasMax,2);





uSaidas = zeros(numDados,numSaidas,numClasses);
for j = 1:numSaidas
    for k = 1:numClasses
        x = saidas(:,j);
        mf = fis.Output(j).mf(k);
        uSaidas(:,j,k) = evalmf(mf,x);
    end
end

[uSaidasMax, iuSaidasMax] = max(uSaidas,[],3);

antecedentes = unique(iuEntradasMax,"rows");
consequentes = [];


for i = 1:size(antecedentes,1)
    uMax = zeros(numDados,1);
    antecedentesIguais = ismember(iuEntradasMax,antecedentes(i,:),"rows");
    uMax(antecedentesIguais) = uEntradasMaxMax(antecedentesIguais);
    [~,indiceConsequente] = max(uMax); 
    consequentes = [consequentes; iuSaidasMax(indiceConsequente,:)];
end
regras = [antecedentes,consequentes, ones(i,2)];

fis = addRule(fis,regras);


end



