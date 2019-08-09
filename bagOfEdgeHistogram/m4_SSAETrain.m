% Train stacked sparse autoencoder 

clear
tic

%---parameters
% hidden layer 1
size1 = 400;
maxEpochs1 = 1500;
L2Reg1 = 0.004;
sparsityReg1 = 4;
sparsityProp1 = 0.15;
scaleData1 = false;

% hidden layer 2
size2 = 200;
maxEpochs2 = 1000;
L2Reg2 = 0.002;
sparsityReg2 = 4;
sparsityProp2 = 0.1;
scaleData2 = false;
%---

strc = load('trData.mat');
trData = strc.trData;

% show some patches
% clf
% ind = randperm(numel(trData), 32);
% for i = 1:32
%     subplot(4,8,i);
%     imshow(trData{ind(i)});
% end

rng('default')

autoenc1 = trainAutoencoder(trData, size1, ...
    'MaxEpochs', maxEpochs1, ...
    'L2WeightRegularization', L2Reg1, ...
    'SparsityRegularization', sparsityReg1, ...
    'SparsityProportion',sparsityProp1, ...
    'ScaleData', scaleData1);

view(autoenc1)
plotWeights(autoenc1);

feat1 = encode(autoenc1, trData);
autoenc2 = trainAutoencoder(feat1,size2, ...
    'MaxEpochs', maxEpochs2, ...
    'L2WeightRegularization', L2Reg2, ...
    'SparsityRegularization', sparsityReg2, ...
    'SparsityProportion', sparsityProp2, ...
    'ScaleData', scaleData2);

save('SSAETrain', 'autoenc1', 'autoenc2');
