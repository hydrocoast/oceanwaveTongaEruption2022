clear
close all

load("IOC_JPRUS.mat");

%% obs data
obsdir = '~/Dropbox/miyashita/dataset/Tonga2022/IOC_Filtered_JPRUS_10_100';
list_obs = dir(fullfile(obsdir,"Ftd_*.txt"));
nobs = size(list_obs,1);

table_obs = addvars(table_obs,cell(size(table_obs,1),1),cell(size(table_obs,1),1));
table_obs = renamevars(table_obs,"Var6","Time");
table_obs = renamevars(table_obs,"Var7","Eta_filtered");

for i = 1:nobs
% for i = 1:1
    obsname = strsplit(list_obs(i).name,'_');
    obsname = strrep(obsname{2},'.txt','');
    num_row = find(cellfun(@(x) ~isempty(x),strfind(table_obs.Name,obsname)));

    obsdat = readmatrix(fullfile(obsdir,list_obs(i).name),"FileType","text");

    table_obs.Time{num_row} = obsdat(:,1);
    table_obs.Eta_filtered{num_row} = obsdat(:,2);
end


%% save
save("IOC_JPRUS_surf.mat",'-v7.3','table_obs');
