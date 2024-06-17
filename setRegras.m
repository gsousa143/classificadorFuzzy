function fis = setRegras(fis,classes)
numEntradas = size(fis.In,2);
numSaidas = size(fis.Out,2);
numClasses = size(fis.In(1).mf,2);
regras = [];
for i = 1:numEntradas
    for j = 1:numSaidas
        
        for k = 1:numClasses
            antecedentes = zeros(1,numEntradas);
            antecedentes(i) = k;
            consequentes = zeros(1,numSaidas);
            consequentes(j) = k;
            regra = [antecedentes,consequentes,1,1];
            regras = [regras;regra];
        end
    end
end
regras
fis = addRule(fis,regras);
end




