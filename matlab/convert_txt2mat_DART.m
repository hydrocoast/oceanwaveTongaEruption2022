clear
close all

%% station info
file_loc = '~/Dropbox/miyashita/dataset/Tonga2022/DART_Filtered100/DART_depth_latlon.txt';
table_DART = readtable(file_loc);
table_DART = renamevars(table_DART,"Var1","DART");
table_DART = renamevars(table_DART,"Var2","Depth");
table_DART = renamevars(table_DART,"Var3","Lat");
table_DART = renamevars(table_DART,"Var4","Lon");

%% save
save("DART.mat",'-v7.3','table_DART');
