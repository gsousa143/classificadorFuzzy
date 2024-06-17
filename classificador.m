clc, clear, close all;


[entradas,saidas,classes] = lerPlanilha("Classificação dos dados nuno novos.xlsx");

fis = readfis("clssOtm.fis");  %Lê o arquivo clssOtm é o atritui a variavel fis.
%fis: Sistema de Inferencia Fuzzy que irá realizar a classificação

[classificacao,pertinenciaClasse,saidasEstimadas] = evalClassificador(fis,entradas);
% classificacao: vetor com a classe retornada pelo classificador
% pertinenciaClasse: matriz com a pertinencia de cada classe (pode ser
% utilizado para verificar dados que o classificador retorna uma classe
% incerta)


% fCusto = calculaFuncional(classificacao,pertinenciaClasse,classes)

% if ~isempty(classes)
%     matrizConfusao = confusionmat(classes,classificacao)
% 
%     confusionchart(matrizConfusao);
%     set(gca(), "fontsize", 16, 'FontName', 'Times New Roman');
%     xlabel("Classe Estimada");
%     ylabel("Classe Real");
%     drawnow;
% end

filtraDados(pertinenciaClasse,classes,0.1)
tabela = table(entradas,saidasEstimadas,pertinenciaClasse,classificacao);
writetable(tabela,"dados.xlsx")


function [classificacao,pertinenciaClasse,saidasEstimadas] = evalClassificador(fis,entradas)
% evalClassificador: Avalia o desempenho do classificador
%
% **Entradas**
%
% fis: variavel do tipo mamfis, o sistema de inferencia fuzzy que realiza a
%   classificação
% entradas: matriz como as entradas que serão utilizadas para a
%   classificação
%
%**Saidas**
%
%classificao: matriz com a classe de cada dado de saida
%pertinenciaClasse: matriz com a pertinencia que cada saida tem a
%   a cada uma das classes
% saidasEstimadas: Estimação das saidas realizada pelo Sistema de Inferencia Fuzzy
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

function fCusto = calculaFuncional(classificacao,pertinenciaClasse,classes)
% Retorna o Funcional Custo utilizado para o treinamento do classificador
% Como tambem plota a matriz de confusão
numDados = size(classes,1);

pertinenciaClasseReal = zeros(size(classes));
for i =  1:numDados
    pertinenciaClasseReal(i) = pertinenciaClasse(i,classes(i));
end
taxaDeAcerto = sum(classificacao==classes)/numDados;
fCusto = 0.1*( mean( (1-pertinenciaClasseReal).^2 )) + taxaDeAcerto


matrizConfusao = confusionmat(classes,classificacao);
confusionchart(matrizConfusao);
title("Taxa de Acertos: "+string(sum(classificacao==classes))+"/"+string(numDados)+", "+string(taxaDeAcerto*100)+"%");
drawnow;
disp("Taxa de Acertos: "+string(sum(classificacao==classes))+"/"+string(numDados)+", "+string(taxaDeAcerto*100)+"%"+", "+string(mean(pertinenciaClasseReal)))
end

function [entradas,saidas,classes] = lerPlanilha(name)
entradas = [];
saidas = [];
classes = [];

dados = readtable(name);

try
    entradas = table2array(dados(:,2:6));

catch
end

try
    saidas =  table2array(dados(:,7:10));
catch
end

try
    classes =  table2array(dados(:,11));
    classes = cell2mat(classes);
    classes = str2num(classes(:,2));
catch
end

end

function filtraDados(pertinenciaClasse,classes,limite)
[pertinenciaClasseEstimada,classificacao] = max(pertinenciaClasse,[],2);
residuo = pertinenciaClasseEstimada-pertinenciaClasse;
residuo(residuo == 0) = inf;
indice = min(residuo,[],2)>limite;
classes = classes(indice);
classificacao = classificacao(indice);
matrizConfusaoFiltrada = confusionmat(classes,classificacao)
confusionchart(matrizConfusaoFiltrada)
set(gca(), "fontsize", 16, 'FontName', 'Times New Roman');
    xlabel("Classe Estimada");
    ylabel("Classe Real");
    drawnow;
end



