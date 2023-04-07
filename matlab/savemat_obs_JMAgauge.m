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


nall = size(table_JMA,1);


t_range = [0,16*3600];
t_zmax = zeros(nall,1);
zmax = zeros(nall,1);

t_origin = datetime('2022-01-15T04:14:45');

for i = 1:nall
    dat = cell2mat(table2array(table_JMA(i,["Time","Eta_filtered"])));
    if isempty(dat); continue; end

    [~,ind_s] = min(abs(t_range(1)-dat(:,1)));
    [~,ind_e] = min(abs(t_range(2)-dat(:,1)));
    t = dat(ind_s:ind_e,1);
    z = dat(ind_s:ind_e,2);

    [zmax(i), ind_zmax] = max(z);
    t_zmax(i) = t(ind_zmax);
end
t_zmax_hhmm = seconds(t_zmax);
t_zmax_hhmm.Format = 'hh:mm';

table_JMA = addvars(table_JMA,t_zmax,t_zmax_hhmm,zmax,repmat(t_origin,[nall,1]),'NewVariableNames',["Time_Etamax","Time_Etamax_HM","Etamax","Time_Origin"]);



%% save
save("JMA_records.mat",'-v7.3','table_JMA');
