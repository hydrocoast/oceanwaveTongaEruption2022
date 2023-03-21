clear
close all

%% sim data
% --------------------------------------
simdir1 = '../result_gauge/presA_L5';
simdir2 = '../result_gauge/presB_L5';
simdir3 = '../result_gauge/presC_L5';
simcase_label = {'A','B','C'};
simcase_prefix = 'ABC_';
% --------------------------------------
% simdir1 = '../result_gauge/presA_L3';
% simdir2 = '../result_gauge/presA_L4';
% simdir3 = '../result_gauge/presA_L5';
% simcase_label = {'Level 3','Level 4','Level 5'};
% simcase_prefix = 'predA_L3L4L5';
% --------------------------------------

list_gauge1 = dir(fullfile(simdir1,'gauge*.txt'));
ngauge = size(list_gauge1,1);
list_gauge2 = dir(fullfile(simdir2,'gauge*.txt'));
list_gauge3 = dir(fullfile(simdir3,'gauge*.txt'));
if ngauge ~= size(list_gauge2,1) || ngauge ~= size(list_gauge3,1)
    error(['Number of gauges ',simdir1,', ',simdir2,' and ',simdir3,' is inconsistent.'])
end

cmap = colormap(lines(5)); close;


%% obs data
load('JMA_records.mat');
load('DART_records.mat');

%% directory for export figs
figdir = 'fig';
option_printfig = 1; % 1: on, others: off
if option_printfig == 1
    if ~isfolder(figdir); mkdir(figdir); end
end

%% read and compare
fig = figure;
print(fig,'-dpng','tmp.png'); delete('tmp.png');
g = cell(ngauge,2);
for i = 1:ngauge
% for i = 1:1

    if ~strcmp(list_gauge1(i).name,list_gauge2(i).name)
        error(['Gauge number is inconsistent.', list_gauge1(i).name, ' and ', list_gauge2(i).name]);
    end

    file1 = fullfile(simdir1,list_gauge1(i).name);
    file2 = fullfile(simdir2,list_gauge1(i).name);
    file3 = fullfile(simdir3,list_gauge1(i).name);

    %% read header
    fid = fopen(file1,'r');
    header = textscan(fid,'# gauge_id= %d location=( %f %f)',1);
    fclose(fid);
    gid = header{1};
    lon = header{2};
    lat = header{3};

    %% find the closest observation point
    [dist,ind_row] = min(sqrt((table_JMA.Lat-lat).^2+(table_JMA.Lon-lon).^2));
    if dist>0.5
        ind_row = []; % not found
    end

    %% find the closest DART buoy
    if isempty(ind_row)
        [dist,ind_row] = min(sqrt((table_DART.Lat-lat).^2+(table_DART.Lon-lon).^2));
        if dist>0.5
            ind_row = []; % not found
        end
        isdart = true;
    else
        isdart = false;
    end

    %% read

    % --- simulation A
    datA = readmatrix(file1,"FileType","text","NumHeaderLines",3);
    if ~isdart
        datA(datA(:,2)<5.5*3600, 6) = 0.0; % 解像度が低い時点の水位を0に
    end
    g{i,1} = [datA(:,2),datA(:,6),datA(:,1)]; % time, eta, AMRlevel

    % --- simulation B
    datB = readmatrix(file2,"FileType","text","NumHeaderLines",3);
    if ~isdart
        datB(datB(:,2)<5.5*3600, 6) = 0.0; % 解像度が低い時点の水位を0に
    end
    g{i,2} = [datB(:,2),datB(:,6),datB(:,1)]; % time, eta, AMRlevel

    % --- simulation C
    datC = readmatrix(file3,"FileType","text","NumHeaderLines",3);
    if ~isdart
        datC(datC(:,2)<5.5*3600, 6) = 0.0; % 解像度が低い時点の水位を0に
    end
    g{i,3} = [datC(:,2),datC(:,6),datC(:,1)]; % time, eta, AMRlevel

    %% 近い観測点がない場合はスキップ
    if isempty(ind_row); continue; end

    if isdart
        time_offset = 0.0;
    else
        if contains(char(table_JMA.Name(ind_row)),'Chichijima') || (131.0 < lon && lon < 140.8)
            time_offset = 0.1;
        elseif 140.8 < lon
            time_offset = 0.2;
        else
            time_offset = 0.0;
        end
    end
    
    %% plot
    fig.CurrentObject; clf(fig);
    ax = axes;
    hold on
    p1 = plot(g{i,1}(:,1)./3600 + time_offset, g{i,1}(:,2),'-','LineWidth',1.0);
    p2 = plot(g{i,2}(:,1)./3600 + time_offset, g{i,2}(:,2),'-','LineWidth',1.0,'Color',cmap(5,:));
    p3 = plot(g{i,3}(:,1)./3600 + time_offset, g{i,3}(:,2),'-','LineWidth',1.0,'Color',cmap(2,:));
    grid on; box on
    xlabel("Time (min)",'FontName','Helvetica','FontSize',14);
    ylabel("Amplitude (m)",'FontName','Helvetica','FontSize',14);

    hold on
    if isdart
        p4 = plot(cell2mat(table_DART.Time(ind_row))./3600, 1e-2*cell2mat(table_DART.Eta_filtered(ind_row)),'k-','LineWidth',0.5);
        title(sprintf('DART %05d',table_DART.DART(ind_row)),'FontName','Helvetica','FontSize',14);
        xlim([3,13.5])
    else
        p4 = plot(cell2mat(table_JMA.Time(ind_row))./3600, 1e-2*cell2mat(table_JMA.Eta_filtered(ind_row)),'k-','LineWidth',0.5);
        title(table_JMA.Name(ind_row),'FontName','Helvetica','FontSize',14);
        xlim([6,16.5])
    end
%     xlim([-1,15])
%     xline(0.0,'k--');
    hold off

    legend([p1,p2,p3,p4],{simcase_label{1},simcase_label{2},simcase_label{3},'Obs.'},'FontName','Helvetica','FontSize',14,'Location','southwest');
    set(ax,'FontName','Helvetica','FontSize',12)
    ax.XAxis.TickValues = 0:16;
    if (ax.YLim(2)-ax.YLim(1))>1.0
        ax.YAxis.TickLabelFormat = '%0.1f';
    elseif (ax.YLim(2)-ax.YLim(1))>0.1
        ax.YAxis.TickLabelFormat = '%0.2f';
    else
        ax.YAxis.TickLabelFormat = '%0.3f';
    end

    %% print
    if option_printfig == 1
        if isdart
            figfile = [simcase_prefix,sprintf('_DART%05d.png',table_DART.DART(ind_row))];
        else
            figfile = [simcase_prefix,sprintf('_%02d_',gid),char(table_JMA.Name(ind_row)),'.png'];
        end
        exportgraphics(gcf,fullfile(figdir,figfile),'Resolution',300,'ContentType','image');
%         exportgraphics(gcf,strrep(fullfile(figdir,figfile),'.png','.pdf'),'ContentType','vector');
    end
end

