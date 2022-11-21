clear
close all


load("obs_airpressure.mat");

%% obs data
obsdir = '~/Dropbox/miyashita/dataset/Tonga2022/Near_Japan';

np_obs = size(table_obs_pres,1);
table_obs_pres = addvars(table_obs_pres,cell(np_obs,1),cell(np_obs,1));
table_obs_pres = renamevars(table_obs_pres,"Var7","Time");
table_obs_pres = renamevars(table_obs_pres,"Var8","Pressure_anomaly");


for i = 1:np_obs
% for i = 1:1
    filename = string(table_obs_pres{i,"Filename"});    
    obsdat = readmatrix(fullfile(obsdir,filename),"FileType","text");
    table_obs_pres.Time{i} = obsdat(:,1);
    table_obs_pres.Pressure_anomaly{i} = obsdat(:,2);
end

%% save
save("obs_airpressure_anomaly.mat",'-v7.3','table_obs_pres');
