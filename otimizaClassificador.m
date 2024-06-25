clear, clc;

fis = readfis("clss.fis");

%dados para otimização
[entradas,saidas,classes] = lerPlanilha("Classificação dos dados nuno novos.xlsx");
% [indices] = separaDadosTreino(entradas,saidas,classes);
% entradas = entradas(indices,:);
% saidas = saidas(indices,:);
% classes = classes(indices,:);

%parametros da otimização
itMax = 200;
tempoMax = Inf;
NP =  100;

solucaoInicial  = ones(1,numel(fis.rule));

limites = [
    ones(1,numel(fis.rule));
    zeros(1,numel(fis.rule))];

[fopt, xopt] = pso(@(x) otimizacao(x,fis,entradas,classes), ... %OTIMIZAÇÃO
                                    limites, solucaoInicial,[],NP,itMax,Inf,true);

fis.Name = fis.Name+" Otimizado";
writeFIS(fis,"clssOtm.fis");
