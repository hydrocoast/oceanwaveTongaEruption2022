clear
close all

%% sim data
simdir1 = '../run_lamb/_output';
simdir2 = '../run_lamb_ag/_output';
simcase_label = {'Lamb','Lamb + gravity'};
simcase_prefix = 'Lamb_LambGravity';

list_gauge1 = dir(fullfile(simdir1,'gauge*.txt'));
ngauge = size(list_gauge1,1);
list_gauge2 = dir(fullfile(simdir2,'gauge*.txt'));
if ngauge ~= size(list_gauge2,1)
    error(['Number of gauges ',simdir1,' and ',simdir2,' is inconsistent.'])
end

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
g = cell(ngauge,2);
for i = 1:ngauge
% for i = 1:1

    if ~strcmp(list_gauge1(i).name,list_gauge2(i).name)
        error(['Gauge number is inconsistent.', list_gauge1(i).name, ' and ', list_gauge2(i).name]);
    end

    file1 = fullfile(simdir1,list_gauge1(i).name);
    file2 = fullfile(simdir2,list_gauge1(i).name);

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
    dat1 = readmatrix(file1,"FileType","text","NumHeaderLines",3);
    if ~isdart
        dat1(dat1(:,2)<5.5*3600, 6) = 0.0; % 解像度が低い時点の水位を0に
    end
    g{i,1} = [dat1(:,2),dat1(:,6),dat1(:,1)]; % time, eta, AMRlevel

    % --- simulation B
    dat2 = readmatrix(file2,"FileType","text","NumHeaderLines",3);
    if ~isdart
        dat2(dat2(:,2)<5.5*3600, 6) = 0.0; % 解像度が低い時点の水位を0に
    end
    g{i,2} = [dat2(:,2),dat2(:,6),dat2(:,1)]; % time, eta, AMRlevel

    %% 近い観測点がない場合はスキップ
    if isempty(ind_row); continue; end

    %% plot
    fig = figure;
    ax = axes;
    p1 = plot(g{i,1}(:,1)./3600, g{i,1}(:,2),'-','LineWidth',1.0);
    hold on
    p2 = plot(g{i,2}(:,1)./3600, g{i,2}(:,2),'-','LineWidth',1.0);
    grid on
    xlabel("Time (min)",'FontName','Helvetica','FontSize',14);
    ylabel("Water surface height (m)",'FontName','Helvetica','FontSize',14);

    hold on
    if isdart
        p3 = plot(cell2mat(table_DART.Time(ind_row))./3600, 1e-2*cell2mat(table_DART.Eta_filtered(ind_row)),'k-','LineWidth',0.5);
        title(sprintf('DART %05d',table_DART.DART(ind_row)),'FontName','Helvetica','FontSize',14);
    else
        p3 = plot(cell2mat(table_JMA.Time(ind_row))./3600, 1e-2*cell2mat(table_JMA.Eta_filtered(ind_row)),'k-','LineWidth',0.5);
        title(table_JMA.Name(ind_row),'FontName','Helvetica','FontSize',14);
    end

    xlim([-1,13])
    xline(0.0,'k--');
    hold off

    legend([p1,p2,p3],{simcase_label{1},simcase_label{2},'Obs.'},'FontName','Helvetica','FontSize',14,'Location','northwest');
    set(ax,'FontName','Helvetica','FontSize',12)
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
            figfile = [simcase_prefix,'_',char(table_JMA.Name(ind_row)),'.png'];
        end
        exportgraphics(gcf,fullfile(figdir,figfile),'Resolution',300,'ContentType','image');
        exportgraphics(gcf,strrep(fullfile(figdir,figfile),'.png','.pdf'),'ContentType','vector');
    end
end

