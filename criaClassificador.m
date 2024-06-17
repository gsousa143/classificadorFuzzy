clc, clear, close all;





[entradas,saidas,classes,nomeEntradas,nomeSaidas] = lerPlanilha("Classificação dos dados nuno novos.xlsx");

% load fisheriris
% entradas = meas(:,1:2);
% saidas = meas(:,2:3);
% classes = zeros(size(species, 1),1);
% for i = 1:size(species, 1)
%     if strcmp(species{i}, 'setosa')
%         classes(i) = 1;
%     elseif strcmp(species{i}, 'versicolor')
%         classes(i) = 2;
%     else
%         classes(i) = 3;
%     end
% end



fis = mamfis("Name","Classificador Fuzzy");
fis = setEntradas(fis,entradas,classes,nomeEntradas);
fis = setSaidas(fis,saidas,classes,nomeSaidas);
fis = setRegras(fis,classes);


[classificacao,pertinenciaClasse,saidasEstimadas] = evalClassificador(fis,entradas);
fCusto = calculaFuncional(classificacao,pertinenciaClasse,classes);

writeFIS(fis,"clss.fis");
% plotfis(fis);


            