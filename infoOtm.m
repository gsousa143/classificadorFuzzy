function infoOtm(it,Fbest,gbest, nome)
        fprintf("\n\n==============================================================================================================")
        fprintf('\niter %3.0f; \t fbest  %9.5g; \t gbest ',it,Fbest);
        fprintf('%9.5g,   ', gbest);

        if nome ~= ""
            writematrix([it, Fbest, gbest],nome,'WriteMode','append');
        end
end