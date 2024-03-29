function [Fbest, gbest, it,x] = GA(costf, limites, solucaoInicial, parametros)
%EVOLUÇÃO DIFERENCIAL
%
%[fopt, xopt] = DE(costf, limitesMax, parametros.parametros.NP)
%costf: funcao custo y = costf(x) a ser otimizada, onde x um vetor 1xD é a posicao de
%uma unica particula.
%limites: matrix 4xD que gere os limites do parametros do PSO, de modo que
%cada linha representaa posicao maxima e minima e velocidades maxima e
%minima respectimante.
%parametros.parametros.NP: numero maximo de particulas.
%parametros.info: permite mostrar informacoes no console e salvar o gbest e fbest da
%ultima iteracao em um arquivo saveed.csv.
%D: dimensao, ou quantidade de variaveis de desição.

it = 1;

tempoInicial = tic;

D = size(limites,2);

xMax = limites(1,:);
xMin = limites(2,:);



% calcula posicao iniciais e inicializa vetor candidato

    for d = 1:D
        x(1:parametros.NP,d) = xMin(d) + rand(parametros.NP,1)*( xMax(d) - xMin(d) );
    end
    if ~isempty(solucaoInicial)
        x(1:size(solucaoInicial,1),:) = max(min(solucaoInicial,xMax),xMin);
    end
    
% calcula o funcional custo
for n = 1:parametros.NP
    F(n) = costf(x(n, :));
end
tempoIt = toc(tempoInicial);


while(1)
    % determina Fbest e gbest
    [C, I] = min(F);
    Fbest = C;
    gbest = x(I, :);
    Fworst = max(F);

    %verifica criteiro de parada
    if ( it >= parametros.itMax )||( toc(tempoInicial)+tempoIt > parametros.tempoMax ) ||  max(abs(mean(x)./gbest-1)) < 1e-6
        infoOtm(it,Fbest,gbest,parametros.path);
        fprintf('\t Tempo %9.4g',(toc(tempoInicial)));
        break;
    end
    
    if parametros.info>0
    infoOtm(it,Fbest,gbest,parametros.path);
    end
    
    
    Fap = 0.01 + (0.99)*(Fworst-F)/(Fworst-Fbest);
    roleta = cumsum(Fap');
    %indica o indice de cada particula pai
    
    for n = 1:parametros.NP+1
        r = roleta(end)*rand();
        p(n) = find(roleta>=r,1);
    end

    for n = 1:2:parametros.NP
        P = (1+2*parametros.betta)*rand() - parametros.betta;
        f(n,:) = (1-P)*x(p(n), :) + P*x(p(n+1), :);
        f(n+1,:) = (1-P)*x(p(n+1), :) + P*x(p(n), :);
    end
    for n = 1:parametros.NP
        for d = 1:D
            if rand() <= parametros.cr 
                f(n,d) = f(n,d) + (2*rand()-1)*parametros.fM*f(n,d);
            end
        end
    end
    f = min(f,xMax);
    f = max(f,xMin);
    
    for n = 1:parametros.NP
        Ff(n) = costf(f(n,:));
    end
%     parfor n = 1:parametros.NP
%         Ff(n) = costf(f(n,:));
%     end
        
    
    i = Ff<F;
    x(i,:) = f(i,:);
    F(i) = Ff(i);
    

    
    it = it+1;
end

end

