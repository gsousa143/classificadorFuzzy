function fis = setEntradas(fis,entradas,numMF)
% Cria a inferencia para a entrada do sistema de inferencia fuzzy
% fis: Sistema de Inferencia Fuzzy
% entradas: Matriz com as entradas [Dados x numEntradas]
% numMF: numero de funcões de pertinencia que estaram disponiveis para cada
%   entrada do fis


numEntradas = size(entradas,2);
for i = 1:numEntradas % Loop que verifica dados de cada entradas para determinar o range do universo de discuro
    range = [min(entradas(:,i)), max(entradas(:,i))]; %determina o range
    fis = addInput(fis,range,'NumMFs',numMF,'MFType',"gaussmf"); %cria o input
end
end

