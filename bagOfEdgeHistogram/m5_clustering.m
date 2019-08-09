% Clustering cell patches using the feature learned by stacked sparse 
% autoencoder.

clear
tic

dicSize = [8, 16, 32, 64, 128, 256];

strc  = load('trData.mat');
trData = strc.trData;

strc2 = load('SSAETrain.mat');
autoenc1 = strc2.autoenc1;
autoenc2 = strc2.autoenc2;

feat1 = encode(autoenc1, trData);
feat2 = encode(autoenc2, feat1);

centersCell = cell(numel(dicSize), 1);
for i = 1:numel(dicSize)
    t = tic;
    [assignments, centersCell{i}] = kmeans(feat2', dicSize(i),...
        'Replicates', 10);
    centersCell{i} = centersCell{i}';
    fprintf('%d/%d finished, time %f\n', i, numel(dicSize), toc(t));
end

save('centersCell', 'centersCell');

toc
