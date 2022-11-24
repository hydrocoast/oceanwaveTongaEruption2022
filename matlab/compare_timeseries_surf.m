clear
close all

%% sim data
simdir = '../run_lamb/_output';
list_gauge = dir(fullfile(simdir,'gauge*.txt'));
ngauge = size(list_gauge,1);


%% obs data
load('IOC_JPRUS_surf.mat');
% load('JMA_records.mat');
load('DART_records.mat');

g = cell(ngauge,1);
for i = 1:ngauge
% for i = 1:1
    file = fullfile(simdir,list_gauge(i).name);

    %% read
    dat = readmatrix(file,"FileType","text","NumHeaderLines",3);
    dat(abs(dat(:,6))>4.0, 6) = 0.0;
    g{i} = [dat(:,2),dat(:,6),dat(:,1)]; % time, eta, AMRlevel

    %% read header
    fid = fopen(file,'r');
        header = textscan(fid,'# gauge_id= %d location=( %f %f)',1);
    fclose(fid);
    gid = header{1};
    lon = header{2};
    lat = header{3};

    %% find the closest gauge obs
    [dist,ind_row] = min(sqrt((table_obs.Lat-lat).^2+(table_obs.Lon-lon).^2));
    if dist>0.5
        ind_row = []; % not found
    end

    if isempty(ind_row)
        %% find the closest DART buoy
        [dist,ind_row] = min(sqrt((table_DART.Lat-lat).^2+(table_DART.Lon-lon).^2));
        if dist>0.5
            ind_row = []; % not found
        end
        isdart = true;
    else
        isdart = false;
    end

    if isempty(ind_row); continue; end

    %% plot
    figure
    p1 = plot(g{i}(:,1)./3600,g{i}(:,2));
    grid on
    xlabel("Time (min)",'FontName','Helvetica','FontSize',14);
    ylabel("Water surface height (m)",'FontName','Helvetica','FontSize',14);

    hold on
    if isdart
        p2 = plot(cell2mat(table_DART.Time(ind_row))./3600, 1e-2*cell2mat(table_DART.Eta_filtered(ind_row)),'k-');
        title(sprintf('DART %05d',table_DART.DART(ind_row)),'FontName','Helvetica','FontSize',14);
    else
        p2 = plot(cell2mat(table_obs.Time(ind_row))./3600, cell2mat(table_obs.Eta_filtered(ind_row)),'k-');
        title(table_obs.Name(ind_row),'FontName','Helvetica','FontSize',14);
    end

    xlim([-1,13])
    xline(0.0,'k--');
    hold off

    legend([p1,p2],{'Sim.','Obs.'},'FontName','Helvetica','FontSize',14,'Location','northwest');
    
end

