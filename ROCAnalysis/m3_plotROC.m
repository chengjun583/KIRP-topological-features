% Plot ROC 

clear
close all

fig = figure;

fig.Position = [230 250 300 255];

tab = readtable('FP_TP.csv');

plot(tab.V2, tab.V1, '-r', 'lineWidth', 1.5)
hold on

plot(tab.V4(1:4), tab.V3(1:4), '--g', 'lineWidth', 1.5)
plot(tab.V6(1:4), tab.V5(1:4), ':b', 'lineWidth', 1.5)
hLe = legend({'Risk index (AUC=0.78)', 'Stage (AUC=0.63)', 'Subtype (AUC=0.66)'},...
    'location', 'southeast');
hLe.FontSize = 6;

xlabel('1-Specificity');
ylabel('Sensitivity');
hAxis = gca;
hAxis.FontSize = 10;
hAxis.XColor = [0, 0, 0];
hAxis.FontSmoothing = 'off';


set(fig,'PaperPositionMode','auto')
print('roc2','-dpng','-r300')


