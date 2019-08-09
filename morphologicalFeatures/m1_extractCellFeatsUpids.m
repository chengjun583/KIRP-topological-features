% Extract cell features for each unique patient

% 10 features are extracted including: 
% -nucleus size (1)
% -length of major and minor axes of cell nucleus and their ratio (3)
% -mean value of pixel intensities of nucleus in R, G, and B channels (3)
% -mean, maximum and minimum neighbor distances of cells in the 
%  Delaunay triangulation graph (3)
% The order of features in 'cellFeatsUpids' is the same as the above order


% Then, 5 features, including mean value, standard deviation, skewness, 
% kurtosis, and entropy, are employed to evaluate the distribution of each
% feature. So we finally get 50 features for each patient.

clear
tic
% ---paremeteres-----
areaMin = 82;
areaMax = 1033;
distMaxT = 158; % mamximum neighbor cell distance threshold
% -------------------

dirMask = '../KIRP_imageMask/';
dirIm = '../KIRP_image/';

list = dir([dirMask, '*.png']);
nList = numel(list);

% generate upids
pids = cell(nList, 1);
for i = 1:nList
    pids{i} = list(i).name(9:12);
end
[upids, indp, indu] = unique(pids);

cellFeatsUpids = zeros(numel(upids), 50, 'single');
% extract features for each patient
parfor i = 1:numel(upids)
    t = tic;
    indFiles = find(indu == i);
    featsPid = [];
    for j = 1:numel(indFiles)
        % fist 6 features
        indFile = indFiles(j);
        mask = imread([dirMask, list(indFile).name]);
        label = bwlabel(mask);
        im = imread([dirIm, list(indFile).name(1:end-10), '.jpg']);
        
        statsR = regionprops(mask, im(:, :, 1), 'area', 'MeanIntensity',...
            'MajorAxisLength', 'MinorAxisLength', 'centroid');
        statsG = regionprops(mask, im(:, :, 2), 'MeanIntensity');
        statsB = regionprops(mask, im(:, :, 3), 'MeanIntensity');
        
        statsR = struct2cell(statsR);
        statsR = cell2mat(statsR');
        ind = statsR(:, 1)>=areaMin & statsR(:, 1)<=areaMax;
        statsG = struct2cell(statsG);
        statsG = cell2mat(statsG');
        statsB = struct2cell(statsB);
        statsB = cell2mat(statsB');
        
        centroids = statsR(ind, [2, 3]);
        feats1_7 = [statsR(ind, [1, 4, 5]), statsR(ind, 4)./statsR(ind, 5)...
            statsR(ind, 6), statsG(ind), statsB(ind)];
        
        % last 3 features derived from Delaunay graph
        feats8_10 = zeros(size(feats1_7, 1), 3);
        DT = delaunayTriangulation(double(centroids));
        E = edges(DT);
        for k = 1:size(centroids, 1)
            edgesCell = E(find(sum(E==k, 2)), :);
            dist = zeros(size(edgesCell, 1), 1);
            for m = 1:numel(dist)
                p1 = centroids(edgesCell(m, 1), :);
                p2 = centroids(edgesCell(m, 2), :);
                dist(m) = norm(p1-p2);
            end
            feats8_10(k, :) = [mean(dist), max(dist), min(dist)];
        end
        
        featsPid = [featsPid; [feats1_7, feats8_10]];
    end
    
    ind2 = featsPid(:, 9)<=distMaxT;
    % entropy
    ent = zeros(1, 10);
    for j = 1:10
        if j<=7
            h = histogram(featsPid(:, j), 'Normalization', 'probability');
        else
            h = histogram(featsPid(ind2, j), 'Normalization', 'probability');
        end
        a = h.Values.*log2(h.Values);
        a(isnan(a)) = 0;
        ent(j) = -sum(a);
    end
    
    cellFeatsUpids(i, :) = [mean(featsPid(:, 1:7)), mean(featsPid(ind2, 8:10)),...
        std(featsPid(:, 1:7)), std(featsPid(ind2, 8:10)),...
        skewness(featsPid(:, 1:7)), skewness(featsPid(ind2, 8:10)),...
        kurtosis(featsPid(:, 1:7)), kurtosis(featsPid(ind2, 8:10)),...
        ent];
    
    fprintf('%d/%d finished, time %f\n', i, numel(upids), toc(t));
end

save('cellFeatsUpids.mat', 'cellFeatsUpids', 'upids');  

toc