function fis = setEntradas(fis,entradas,classes,nomeEntradas)
% Cria a inferencia para a entrada do sistema de inferencia fuzzy
% fis: Sistema de Inferencia Fuzzy
% entradas: Matriz com as entradas [Dados x numEntradas]
% numMF: numero de funcões de pertinencia que estaram disponiveis para cada
%   entrada do fis


numEntradas = size(entradas,2);
numClasses = max(classes);
for i = 1:numEntradas % Loop que verifica dados de cada entradas para determinar o range do universo de discuro
    range = [min(entradas(:,i)), max(entradas(:,i))]; %determina o range
    fis = addInput(fis,range,"Name",nomeEntradas{i}); %cria o input
    for j = 1:numClasses %verifica entre as classes existentes
        classeDados = entradas(classes==j,i); %valores de saida que pertencem a classe j
        media = mean(classeDados);
        parametros = [abs(min(classeDados)-media)/4, media, abs(max(classeDados)-media)/4, media]; %determina os parametros da função de pertinencia em relação aos dados presentes na classe
        fis = addMF(fis,fis.Input(i).Name,"gauss2mf",parametros,"Name",string(j));
    end
end
end

