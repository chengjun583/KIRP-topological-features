% Prepare training data for stacked sparse autoencoder

clear
tic
rng('default');

%---parameter
% There are 3118370 cell patches in total from 856 images. We use about 
% 6e4 cell patches to train SSAE
ratio = 0.0192; % only extract 'ratio' of all cell patches in an image
%---

dirCells = 'cellPatchesAndCentroids/';
list = dir([dirCells, '*.mat']);

trData = cell(6e4, 1);
pos = 1;
for i = 1:numel(list)
    t = tic;
    strc = load([dirCells, list(i).name]);
    patches = strc.patches;
    nCells = numel(patches);    
    ind = randperm(nCells, round(nCells*ratio));
    trData(pos:pos+numel(ind)-1) = patches(ind);
    pos = pos + numel(ind);    
    fprintf('%d/%d finished, time %f\n', i, numel(list), toc(t));
end
trData(pos:end) = [];

save trData trData
toc