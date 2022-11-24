clear
close all

%% station info
file_loc = '~/Dropbox/miyashita/dataset/Tonga2022/JMA_Data_Ho/JMA_location.xlsx';
table_JMA = readtable(file_loc,'FileType','spreadsheet');

table_JMA = renamevars(table_JMA,["x_____","x____","x________"],["Type","Address","Location"]);
table_JMA = renamevars(table_JMA,["filename","x______1","x______2"],["ID","Lat","Lon"]);
table_JMA = renamevars(table_JMA,["x______3","x_________1"],["Height","Depth"]);
table_JMA = renamevars(table_JMA,["x_______","x___________"],["Organization_ja","Organization_en"]);
table_JMA = renamevars(table_JMA,["x_________","x__"],["StartYear","StartMonth"]);

%% save
save("JMA.mat",'-v7.3','table_JMA');
