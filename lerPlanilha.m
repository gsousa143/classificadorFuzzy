function [entradas,saidas,classes,nomesEntradas,nomesSaidas,dados] = lerPlanilha(name)
entradas = [];
saidas = [];
classes = [];

dados = readtable(name);
nomes = dados.Properties.VariableNames;
nomesEntradas = nomes(2:6);
nomesSaidas = nomes(7:10);

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

