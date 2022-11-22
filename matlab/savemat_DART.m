clear
close all

load("DART.mat");

%% obs data
obsdir = '~/Dropbox/miyashita/dataset/Tonga2022/DART_Filtered100/DART_Filtered100';
list_DART = dir(fullfile(obsdir,"Ftd_*.txt"));
nobs = size(list_DART,1);

table_DART = addvars(table_DART,cell(size(table_DART,1),1),cell(size(table_DART,1),1));
table_DART = renamevars(table_DART,"Var5","Time");
table_DART = renamevars(table_DART,"Var6","Eta_filtered");

for i = 1:nobs
% for i = 1:1
    obsname = strsplit(list_DART(i).name,'_');
    id_DART = str2double(strrep(obsname{2},'.txt',''));
    num_row = find(table_DART.DART==id_DART);

    obsdat = readmatrix(fullfile(obsdir,list_DART(i).name),"FileType","text");
    table_DART.Time{num_row} = obsdat(:,1);
    table_DART.Eta_filtered{num_row} = obsdat(:,2);
end

%% save
save("DART_records.mat",'-v7.3','table_DART');
