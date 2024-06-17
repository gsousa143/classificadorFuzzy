clear
clc

fis = readfis("clss.fis");
nC = size(fis.Input(1).mf,2);
nE = size(fis.Inputs,2);
nS = size(fis.Output,2);


for i = 1:nS
    figure
    range = fis.output(i).range;
    nome = fis.output(i).name;
    x = linspace(range(1),range(2),100);
    for j = 1:nC
        mf = fis.output(i).mf(j);
        y = evalmf(mf,x);
        hold on;
        plot(x,y,LineWidth=2,DisplayName=mf.Name);
        hold off;
    end
    legend
    axis padded;
    set(gca(), "fontsize", 16, 'FontName', 'Times New Roman');
    ylabel("Graus de Pertinência");
    xlabel(nome);
    % print("saidas/i",'-depsc');
end