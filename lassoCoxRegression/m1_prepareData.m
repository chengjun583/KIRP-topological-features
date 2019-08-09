clear
strc = load('../imCli.mat');
imCli = strc.imCli;

% find indices of early and middle stage (stage 1, 2, and 3)
cliInfo = imCli.cliInfo;
ind123 = strcmp(cliInfo.stage, 'Stage I') |...
    strcmp(cliInfo.stage, 'Stage II') |...
    strcmp(cliInfo.stage, 'Stage III');
cliInfo123 = cliInfo(ind123, :);

boe64 = imCli.boe64(ind123, :);
dlmwrite('rdata_boe.txt', [cliInfo123.time/30, cliInfo123.death, boe64], '\t');