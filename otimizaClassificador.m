clear, clc;

fis = readfis("clss.fis");

%dados para otimização
dados = readtable("./Classificação dos dados nuno novos.xlsx - Dados - Completos.csv");
dados = dados(3:end,:); %retira cabeçario da tabela
entradas = [dados.Var3,dados.Var4,dados.Var5,dados.Var6,dados.Var7]; %seleciona o valor de entrada na tabela
saidas = [dados.Var8,dados.Var10,dados.Var11]; %seleciona as saidas na tabela
classes = [dados.Var12]; %seleciona os valores da classificacao na tabela
classes = cell2mat(classes); %transforma em matriz
classes  = str2num(classes(:,2)); %transforma em uma matriz de dados numericos


%parametros da otimização
parametros.itMax = 500;
parametros.tempoMax = Inf;
parametros.NP =  100;
parametros.info = 1;
parametros.cr = 0.3;
parametros.betta = 0.1;
parametros.fM = 0.7;
parametros.path = "custo.csv";


solucaoInicial = [];
limitesMax = [];
limitesMin = [];

numEntradas = size(fis.Inputs,2);
numMF = size(fis.Input(1).MembershipFunctions,2);
numSaidas = size(fis.Outputs,2);
numClasses = size(fis.Output(1).mf,2);
for i = 1:numEntradas
    sd = fis.Input(i).mf(1).params(1);
    range = fis.Input(i).Range;
    for j = 1:numMF
        solucaoInicial = [solucaoInicial,fis.Input(i).mf(j).params];
        limitesMax = [limitesMax, sd*1.5, range(2)];
        limitesMin = [limitesMin, sd*0.5, range(1)];
    end
end


limites = [limitesMax;limitesMin];

[fopt, xopt] = GA(@(x) otimizaClassificador(x,fis,entradas,classes), limites, solucaoInicial, parametros);


fis = attMF(fis,xopt);
fis.Name = fis.Name+" Otimizado";
writeFIS(fis,"clssOtm.fis");