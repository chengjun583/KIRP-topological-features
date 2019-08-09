% Generate nuclear masks
clear

addpath('../tools');

dirIm = '../KIRP_image/';

listFiles = dir([dirIm,'*.jpg']);

numfids = length(listFiles);
parfor loop = 1:numfids    
    t = tic;
    im = imread([dirIm, listFiles(loop).name]);
    bw = hmt(im);
    imwrite(bw, ['../KIRP_imageMask/', listFiles(loop).name(1:end-4), '_nuSeg.png']);    
    
    fprintf('%d/%d done, time %f\n', loop, numfids, toc(t));
end
