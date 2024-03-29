function fis = attMF(fis,x)
numEntradas = size(fis.Inputs,2);
numMF = size(fis.Input(1).mf,2);

k=1;
for i = 1:numEntradas
    for j = 1:numMF
        fis.Input(i).mf(j).params = x(k:k+1);
        k = k+2;
    end
end



end

