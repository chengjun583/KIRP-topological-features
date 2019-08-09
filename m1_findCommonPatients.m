% find common patients with both image features and survival infomation

clear

% load data
strc = load('bagOfEdgeHistogram/boeUpids8.mat');
boe8 = strc.boeUpids;
boe8 = bsxfun(@rdivide, boe8, sum(boe8, 2));
pidIm = strc.upids;

strc = load('bagOfEdgeHistogram/boeUpids16.mat');
boe16 = strc.boeUpids;
boe16 = bsxfun(@rdivide, boe16, sum(boe16, 2));

strc = load('bagOfEdgeHistogram/boeUpids32.mat');
boe32 = strc.boeUpids;
boe32 = bsxfun(@rdivide, boe32, sum(boe32, 2));

strc = load('bagOfEdgeHistogram/boeUpids64.mat');
boe64 = strc.boeUpids;
boe64 = bsxfun(@rdivide, boe64, sum(boe64, 2));

strc = load('morphologicalFeatures/cellFeatsUpids.mat');
morFeas = strc.cellFeatsUpids;

strc = load('clinicalData/cliInfo.mat');
cliInfo = strc.cliInfo;
pidCli = cellfun(@(x) x(9:12), cliInfo.pid, 'UniformOutput', false);

% intersect
[pid, ia, ib] = intersect(pidIm, pidCli);
imCli.boe8 = boe8(ia, :);
imCli.boe16 = boe16(ia, :);
imCli.boe32 = boe32(ia, :);
imCli.boe64 = boe64(ia, :);
imCli.morFeas = morFeas(ia, :);
imCli.cliInfo = cliInfo(ib, :);
imCli.pid = pid;
save imCli imCli
