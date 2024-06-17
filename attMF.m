function fis = attMF(fis,x)

for i = 1:numel(fis.rule)
    fis.rule(i).weight = x(i);
end
