function fCusto = otimizacao(x,fis,entradas,classes)
warning("")
fis = attMF(fis,x);
try
    [classificacao,pertinenciaClasse] = evalClassificador(fis,entradas);
    fCusto = calculaFuncional(classificacao,pertinenciaClasse,classes);
    if lastwarn ~= ""
        fCusto = 10^6;
    end
catch
    fCusto = Inf;

end
fprintf("\n funcional custo = %1.4f",fCusto);
end
