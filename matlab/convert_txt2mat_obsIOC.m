clear
close all

%% station info
file_loc = '~/Dropbox/miyashita/dataset/Tonga2022/IOC_JPRUS.txt';
table_obs = readtable(file_loc);


%% save
save("IOC_JPRUS.mat",'-v7.3','table_obs');
