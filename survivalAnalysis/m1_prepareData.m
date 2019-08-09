% Prepare the data for survival analysis in R
% Write data into .txt file

clear
strc = load('../imCli.mat');
imCli = strc.imCli;
% find indices of early and middle stage (stage 1, 2, and 3)
cliInfo = imCli.cliInfo;
ind123 = strcmp(cliInfo.stage, 'Stage I') |...
    strcmp(cliInfo.stage, 'Stage II') |...
    strcmp(cliInfo.stage, 'Stage III');
cliInfo123 = cliInfo(ind123, :);

%% boe
boe8 = imCli.boe8(ind123, :);
label = zeros(size(boe8));
for i = 1:size(boe8, 2)
    fea = boe8(:, i);
    cutoff = prctile(fea, 50);
    label(fea<cutoff, i) = 1;
    label(fea>=cutoff, i) = 2;
end
dlmwrite('rdata_boe8.txt', [cliInfo123.time/30, cliInfo123.death, label], '\t');

boe16 = imCli.boe16(ind123, :);
label = zeros(size(boe16));
for i = 1:size(boe16, 2)
    fea = boe16(:, i);
    cutoff = prctile(fea, 50);
    label(fea<cutoff, i) = 1;
    label(fea>=cutoff, i) = 2;
end
dlmwrite('rdata_boe16.txt', [cliInfo123.time/30, cliInfo123.death, label], '\t');

boe32 = imCli.boe32(ind123, :);
label = zeros(size(boe32));
for i = 1:size(boe32, 2)
    fea = boe32(:, i);
    cutoff = prctile(fea, 50);
    label(fea<cutoff, i) = 1;
    label(fea>=cutoff, i) = 2;
end
dlmwrite('rdata_boe32.txt', [cliInfo123.time/30, cliInfo123.death, label], '\t');

boe64 = imCli.boe64(ind123, :);
label = zeros(size(boe64));
for i = 1:size(boe64, 2)
    fea = boe64(:, i);
    cutoff = prctile(fea, 50);
    label(fea<cutoff, i) = 1;
    label(fea>=cutoff, i) = 2;
end
dlmwrite('rdata_boe64.txt', [cliInfo123.time/30, cliInfo123.death, label], '\t');

%% morphological features
morFeas = imCli.morFeas(ind123, :);
label = zeros(size(morFeas));
for i = 1:size(morFeas, 2)
    fea = morFeas(:, i);
    cutoff = prctile(fea, 50);
    label(fea<cutoff, i) = 1;
    label(fea>=cutoff, i) = 2;
end
dlmwrite('rdata_morFeas.txt', [cliInfo123.time/30, cliInfo123.death, label], '\t');

%% clinical variables: stage and tumor subtype
% stage 1 vs 23
label = zeros(size(cliInfo123, 1), 1);
ind1 = strcmp(cliInfo123.stage, 'Stage I');
label(ind1) = 1;
label(~ind1) = 2;
dlmwrite('rdata_stage.txt', [cliInfo123.time/30, cliInfo123.death, label], '\t');

% subtype: Type 1 vs Type 2
indType12 = strcmp(cliInfo.type, 'Type 1') | strcmp(cliInfo.type, 'Type 2');
cliInfoType12 = cliInfo(indType12, :);
label = zeros(size(cliInfoType12, 1), 1);
ind1 = strcmp(cliInfoType12.type, 'Type 1');
label(ind1) = 1;
label(~ind1) = 2;
dlmwrite('rdata_type.txt', [cliInfoType12.time/30, cliInfoType12.death, label], '\t');

