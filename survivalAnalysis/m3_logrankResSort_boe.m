% Sort the log rank results, and convert linear index to edge type.
% The variable logrankRes has four columns. The first column represents 
% linear index. Second and third columns represent the edge type 
% corresponding to the linear index. Fourth column is log-rank test p value

clear

ds = [8, 16, 32, 64];
for i = 1:numel(ds)
    res = dlmread(['logrankRes_boe', num2str(ds(i)), '.txt']);
    [~, ind] = sort(res(:, 2));
    res = res(ind, :);

    strc = load(['edgePatts', num2str(ds(i))]);
    edgePatts = strc.edgePatts;

    logrankRes = [res(:, 1), edgePatts(res(:, 1), :), res(:, 2)];
    save(['logrankResSort_boe', num2str(ds(i))], 'logrankRes');
end