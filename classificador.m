clc, clear, close all;


%Verifrica o nome do arquivo caso seja necessario utilizar uma nova tabela
%de dados
dados = readtable("./Classificação dos dados nuno novos.xlsx - Dados - Completos.csv");
dados = dados(3:end,:);%retira os valores que correspondem ao cadeçario

entradas = [dados.Var3,dados.Var4,dados.Var5,dados.Var6,dados.Var7]; %seleciona o valor de entrada na tabela
% dados.Var3 corresponde ao LOCAL DE COLETA (km)
% dados.Var4 corresponde ao NIVEL DA MARÉ (m)
% dados.Var5 corresponde a UMIDADE DO AR (%)
% dados.Var6 corresponde ao INDICE PLUVIOMÉTRICO (mm)
% dados.Var7 corresponde a TEMPERATURA (°C)

saidas = [dados.Var8,dados.Var10,dados.Var11]; %seleciona as saidas na tabela
% dados.Var8 corresponde ao pH
% dados.Var10 corresponde ao OXIGÊNIO DISSOLVIDO (mg.Lˉ¹)
% dados.Var11 corresponde aos SÓLIDOS TOTAIS DISSOLVIDOS (ppm)


classes = [dados.Var12]; %seleciona os valores da classificacao na tabela
% dados.Var12 corresponde a classificação

classes = cell2mat(classes); %transforma em matriz
classes  = str2num(classes(:,2)); %transforma em uma matriz de dados numericos

fis = readfis("clssOtm.fis");  %Lê o arquivo clssOtm é o atritui a variavel fis.
%fis: Sistema de Inferencia Fuzzy que irá realizar a classificação

[classificacao,pertinenciaClasse,saidasEstimadas] = evalClassificador(fis,entradas);
% classificacao: vetor com a classe retornada pelo classificador
% pertinenciaClasse: matriz com a pertinencia de cada classe (pode ser
% utilizado para verificar dados que o classificador retorna uma classe
% incerta)
%  

fCusto = calculaFuncional(classificacao,pertinenciaClasse,classes);
% calcula o funcional custo utilizado para o otimização e plota a matriz de
% confusão (lembrar de descomentar linha 6)

% a matriz de confusão tambem pode ser obtida pela seguinte linha de codigo
matrizConfusao = confusionmat(classes,classificacao);





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
fCusto = 0.1*sqrt( mean( (1-pertinenciaClasseReal).^2 )) + 1-taxaDeAcerto;


matrizConfusao = confusionmat(classes,classificacao);
confusionchart(matrizConfusao);
title("Taxa de Acertos: "+string(sum(classificacao==classes))+"/"+string(numDados)+", "+string(taxaDeAcerto*100)+"%");
drawnow;
end





