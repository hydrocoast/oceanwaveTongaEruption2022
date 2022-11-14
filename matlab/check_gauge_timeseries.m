clear
close all

%% sim data
simdir = '../testrun_kushimoto_5s/_output';
list_gauge = dir(fullfile(simdir,'gauge*.txt'));
ngauge = size(list_gauge,1);

%% obs data
obsdir = '~/Dropbox/miyashita/dataset/Tonga2022/IOC_Filtered_JPRUS_10_100';
obsfile = 'Ftd_Kushimoto.txt';
obsdat = readmatrix(fullfile(obsdir,obsfile),"FileType","text");


g = cell(ngauge,1);
for i = 1:ngauge
% for i = 1:1
    file = fullfile(simdir,list_gauge(i).name);
    
    dat = readmatrix(file,"FileType","text","NumHeaderLines",3);
    dat(abs(dat(:,6))>4.0, 6) = 0.0;
   

    g{i} = [dat(:,2),dat(:,6),dat(:,1)]; % time, eta, AMRlevel


    figure
    plot(g{i}(:,1)./3600,g{i}(:,2));
    grid on
    xlabel("Time (min)");
    ylabel("Water surface height (m)");
    title("Kushimoto")

    hold on
    plot(obsdat(:,1)./3600,obsdat(:,2),'k-'); xlim([-1,13])

    xline(0.0,'k-');
    
    
end







