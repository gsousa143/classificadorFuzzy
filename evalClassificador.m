function [classificacao,pertinenciaClasse,saidasEstimadas] = evalClassificador(fis,entradas)
% evalClassificador: Avalia o desempenho do classificador
% 
% **Entradas**
% 
% fis: variavel do tipo mamfis, o sistema de inferencia fuzzy que realiza a
%   classificação
% entradas: matriz como as entradas que serão utilizadas para a
%   classificação


numDados = size(entradas,1);

numSaidas = size(fis.Outputs,2);
numClasses = size(fis.Output(1).MembershipFunctions,2);

saidasEstimadas = evalfis(fis,entradas);

pertinenciaClasse = zeros(numDados,numClasses); %inicializa matriz para melhorar performance

for j=1:numSaidas
    for k=1:numClasses
        x = saidasEstimadas(:,j);
        mf = fis.Output(j).MembershipFunctions(k);
        pertinenciaClasse(:,k) = pertinenciaClasse(:,k) + evalmf(mf,x);
    end
end
pertinenciaClasse = pertinenciaClasse./sum(pertinenciaClasse,2); %normaliza as pertinencias para a soma resultar em 1.
[~,classificacao] = max(pertinenciaClasse,[],2); %Classe com maior pertinencia
end

