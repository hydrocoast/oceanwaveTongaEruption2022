clear
close all

load("JMA.mat");

%% obs data
obsdir = '~/Dropbox/miyashita/dataset/Tonga2022/JMA_Data_Ho/Data';
list_JMA = dir(fullfile(obsdir,"Ftd_*.txt"));
nobs = size(list_JMA,1);
ncol = size(table_JMA,2);
table_JMA = addvars(table_JMA,cell(size(table_JMA,1),1),cell(size(table_JMA,1),1));
table_JMA = renamevars(table_JMA,sprintf('Var%d',ncol+1),"Time");
table_JMA = renamevars(table_JMA,sprintf('Var%d',ncol+2),"Eta_filtered");

for i = 1:nobs
% for i = 1:1
    obsname = strsplit(list_JMA(i).name,'_');
    obsname = strrep(obsname{2},'.txt','');
    num_row = find(cellfun(@(x) ~isempty(x),strfind(table_JMA.ID,obsname)));
    obsdat = readmatrix(fullfile(obsdir,list_JMA(i).name),"FileType","text");

    table_JMA.Time{num_row} = obsdat(:,1);
    table_JMA.Eta_filtered{num_row} = obsdat(:,2);
end


%% save
save("JMA_records.mat",'-v7.3','table_JMA');
