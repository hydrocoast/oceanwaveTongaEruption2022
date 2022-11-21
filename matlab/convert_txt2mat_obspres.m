clear
close all

%% station info
file_loc = '~/Dropbox/miyashita/dataset/Tonga2022/Near_Japan/AP_nearJapan.txt';
table_obs_pres = readtable(file_loc);

for i = 1:size(table_obs_pres,1)
    filename = string(table_obs_pres{i,"Filename"});    
    if ~contains(filename,'LDO')
        table_obs_pres{i,"Filename"} = {strrep(filename,'.txt','_prs.txt')};
    end
end


%% save
save("obs_airpressure.mat",'-v7.3','table_obs_pres');
