% Prepare data for calculating AUC in R

clear
close all

score = dlmread('../lassoCoxRegression/score.txt');
strc = load('../imCli.mat');

% Find indices of early and middle stage (stage 1, 2, and 3)
cliInfo = strc.imCli.cliInfo;
ind123 = strcmp(cliInfo.stage, 'Stage I') |...
    strcmp(cliInfo.stage, 'Stage II') |...
    strcmp(cliInfo.stage, 'Stage III');
cliInfo123 = cliInfo(ind123, :);

data.time = cliInfo123.time;
data.death = cliInfo123.death;
data.stage = cliInfo123.stage;
data.type = cliInfo123.type;
data.score = score;

for i = 1:numel(data.type)
    if ~(strcmp(data.type{i}, 'Type 1') || strcmp(data.type{i}, 'Type 2'))
        data.type{i} = ' ';
    end
end

data = struct2table(data);
writetable(data, 'data.txt');