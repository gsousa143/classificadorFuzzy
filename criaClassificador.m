clc, clear, close all;

dados = readtable("./Classificação dos dados nuno novos.xlsx - Dados - Completos.csv");
dados = dados(3:end,:);
numMF = 6;


entradas = [dados.Var3,dados.Var4,dados.Var5,dados.Var6,dados.Var7]; %seleciona o valor de entrada na tabela

saidas = [dados.Var8,dados.Var10,dados.Var11]; %seleciona as saidas na tabela

classes = [dados.Var12]; %seleciona os valores da classificacao na tabela
classes = cell2mat(classes); %transforma em matriz
classes  = str2num(classes(:,2)); %transforma em uma matriz de dados numericos





fis = mamfis("Name","Classificador com "+string(numMF)+" mf na entrada");
fis = setEntradas(fis,entradas,numMF);
fis = setSaidas(fis,saidas,classes);
fis = setRegras(fis,entradas,saidas,classes);


[classificacao,pertinenciaClasse,saidasEstimadas] = evalClassificador(fis,entradas);
fCusto = calculaFuncional(classificacao,pertinenciaClasse,classes);


writeFIS(fis,"clss.fis");
% plotfis(fis);







            