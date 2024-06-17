function [indices] = separaDadosTreino(entradas,saidas,classes)
    indices = [];
    contagens = histcounts(classes);
    contagensPercento = round(contagens*0.7);
    for i =1:max(classes)
        I = find(classes==i);
        I = randperm(contagens(i));
        indices = [indices,I(1:contagensPercento(i))];
    end 
end

