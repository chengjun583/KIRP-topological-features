% Generate cell patches and coordiantes of segmented cells for each image
% and save them into .mat file

clear

%---parameter
pSize = 41; % patch size to frame cell
areaMin = 82;
areaMax = 1033;
%---

dirMask = '../KIRP_imageMask/';
dirIm = '../KIRP_image/';

list = dir([dirMask, '*.png']);

for i = 1:numel(list)
    t = tic;
    mask = imread([dirMask, list(i).name]);
    im = imread([dirIm, list(i).name(1:end-10), '.jpg']);
    
    stats = regionprops(mask, 'centroid', 'area');
    patches = cell(numel(stats), 1);
    centroids = zeros(numel(stats), 2, 'single');
    n = 0;
    for j = 1:numel(stats)
        % cell area must satisfy criteria
        area = stats(j).Area;
        areaOK = area>=areaMin && area<=areaMax;
        if ~areaOK
            continue;
        end
        
        r = round(stats(j).Centroid(2));
        c = round(stats(j).Centroid(1));
        rmin = r-(pSize-1)/2;
        rmax = r+(pSize-1)/2;
        cmin = c-(pSize-1)/2;
        cmax = c+(pSize-1)/2;
        
        if rmin>=1 && rmax<=3e3 && cmin>=1 && cmax<=3e3
            n = n+1;
            patches{n} = im(rmin:rmax, cmin:cmax, :);
            centroids(n, :) = stats(j).Centroid;
        end
    end
    patches(n+1:end) = [];
    centroids(n+1:end, :) = [];
    
    save(['cellPatchesAndCentroids/', list(i).name(1:end-10), '.mat'], 'patches', 'centroids');  
    
    fprintf('%d/%d finished, time %f\n', i, numel(list), toc(t));
end