% Generate bag of edges from Delaunay triangulation for each image

clear
tic

% You can change the dictionary size if you'd like. Valid values: 8, 16, 
% 32, 64, 128, 256.
dSize = 128;

cind = log2(dSize)-2;

strc = load('centersCell.mat');
centersCell = strc.centersCell;

strc = load('SSAETrain.mat');
autoenc1 = strc.autoenc1;
autoenc2 = strc.autoenc2;

% -define edge patterns
[rs, cs] = find(triu(ones(dSize))); 
patterns = [rs, cs];
patterns = unique(patterns, 'rows');
nPatt = size(patterns, 1);

dirCell = 'cellPatchesAndCentroids/';
list = dir([dirCell, '*.mat']);
nList = numel(list);
boeFiles = zeros(nList, nPatt);
parfor i = 1:nList
    t = tic;
    % find edges of delaunay triangulation
    strc = load([dirCell, list(i).name]);
    centroids = double(strc.centroids);
    patches = strc.patches;
    DT = delaunayTriangulation(centroids);
    E = edges(DT);
    
    % quantize vertices based on the cell pattern
    feat1 = encode(autoenc1, patches);
    feat2 = encode(autoenc2, feat1);
    ind = knnsearch(centersCell{cind}', feat2');
    
    % generate bag of edges
    E1 = ind(E);
    E1 = sort(E1, 2);
    [patts, ie, ip] = unique([E1; patterns], 'rows');
    boeFiles(i, :) = hist(ip, 1:nPatt) - 1;
    fprintf('%d/%d finished, time %f\n', i, nList, toc(t));
end

save(['boeFiles', num2str(dSize), '.mat'], 'boeFiles', 'patterns', 'list');
toc
