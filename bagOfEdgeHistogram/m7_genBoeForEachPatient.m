% Generate boe representation for each pid in RBG channels

clear
tic

dicSizes = [8, 16, 32, 64];
for ids = 1:numel(dicSizes)
    dSize = dicSizes(ids);
    t = tic;
    strc1 = load(['boeFiles', num2str(dSize), '.mat']);
    boeFiles = strc1.boeFiles;
    list = strc1.list;

    % get unique patient IDs
    nf = numel(list);
    pids = cell(nf, 1);
    for i = 1:nf
        pids{i} = list(i).name(9:12);
    end
    [upids, indp, indu] = unique(pids);

    % merge BoW features for each patient
    nuf = numel(upids);
    boeUpids = zeros(nuf, size(boeFiles, 2));
    for i = 1:nuf
        ind = indu==i;
        boeUpids(i, :) = sum(boeFiles(ind, :), 1);
        
    end

    save(['boeUpids', num2str(dSize), '.mat'], 'boeUpids', 'upids');
    fprintf('%d/%d done, time %f\n', ids, numel(dicSizes), toc(t));
end

toc