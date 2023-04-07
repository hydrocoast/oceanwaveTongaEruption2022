clear
close all

%% sim data
simdir1 = '../result_gauge/presA_L3';
list_gauge = dir(fullfile(simdir1,'gauge*.txt'));
ngauge = size(list_gauge,1);
%% obs data
load('JMA_records.mat');

%% read and compare
ind_intable = zeros(ngauge,1);
dist = zeros(ngauge,1);
for i = 1:ngauge
% for i = 1:1
    file = fullfile(simdir1,list_gauge(i).name);

    %% read header
    fid = fopen(file,'r');
    header = textscan(fid,'# gauge_id= %d location=( %f %f)',1);
    fclose(fid);
    gid = header{1};
    lon = header{2};
    lat = header{3};

    %% find the closest observation point
    [dist(i),ind_intable(i)] = min(sqrt((table_JMA.Lat-lat).^2+(table_JMA.Lon-lon).^2));
end
JMA = table_JMA(ind_intable,:);

%% remove Harumi
JMA(31,:) = [];

id = 1:size(JMA,1);

JMA = addvars(JMA,id','NewVariableNames','Number','Before',"Type");

save('JMA_records_limited.mat','-v7.3','JMA');


