clear
close all


%% filenames
matfile_pres = 'obs_airpressure_anomaly.mat';
figdir = 'fig_wlanalysis';

%% load
load(matfile_pres);
nstation = size(table_obs_pres,1);

%% parameters
fs = 1; % Hz
dt = 1/fs; % s


%% wavelet analysis for each station
if ~isfolder(figdir); mkdir(figdir); end
fig = figure; print(fig,'-dpng','tmp.png'); delete('tmp.png');

% for i = 1:nstation
for i = 1:1

    label_station = table_obs_pres.Station{i};
    %% 時系列データを等間隔に内挿
    t_obs = table_obs_pres.Time{i};
    t_uniform = t_obs(1):dt:t_obs(end);
    pres_obs = table_obs_pres.Pressure_anomaly{i};
    pres_interp = interp1(t_obs,pres_obs,t_uniform(:),"spline");


    %% 気圧偏差が最大(+)の時刻
    [~,ind_pmax] = max(pres_interp);
    t_pmax = t_uniform(ind_pmax);

%     %% check
%     figure
%     plot(t_obs, pres_obs, '-'); hold on
%     plot(t_uniform, pres_interp, '--'); hold on
%     grid on

    %% wavelet analysis
    [wt,f] = cwt(pres_interp,'morse',fs);
    perT = 1./f;

    %% plot
    range_t = [-2,18];

    figure(fig); clf(fig);
    tile = tiledlayout(3,1);

    %% time-series
    axt = nexttile;
    plot(t_uniform./3600, pres_interp, '-'); hold on
    grid on
    set(axt,'FontName','Helvetica','FontSize',12);
    ylabel(axt,'P_{a} (hPa)','FontName','Helvetica','FontSize',14);
    axt.XAxis.TickLabels = [];
    xline(t_pmax/3600,'k--');
    
    %% scalogram
    axw = nexttile([2,1]);
    pcolor(t_uniform./3600,perT./60,20*log10(abs(wt))); shading flat
    ylim(axw,[1,240]);
    ylabel(axw,'Period (min)','FontName','Helvetica','FontSize',14);
    axw.YAxis.TickValues = [1,2,5,10,20,50,100,200];
    yline([1,10,100],'-','Color',[.8,.8,.8]);
    yline([2:1:9,20:10:90,200],'--','Color',[.8,.8,.8],'Alpha',0.5,'LineWidth',0.5);

    xline(t_pmax/3600,'w-','LineWidth',1);

    caxis(axw,[-40,-10]);
    set(axw,'YScale','log','YDir','reverse','FontName','Helvetica','FontSize',12);

    cb = colorbar(axw,'east','FontName','Helvetica','FontSize',12);
    cb.Label.String = 'Power (dB)';
    cb.Label.Color = 'w';
    cb.Color = 'w';

    xlabel(axw,'Time (h)','FontName','Helvetica','FontSize',14);
    linkaxes([axt,axw],'x');
    xlim(axt,range_t);

    tile.TileSpacing = 'tight';
    tile.Padding = 'compact';

    %% print
    filename_png = ['wavelet_pres_',label_station,'.png'];
    filename_pdf = strrep(filename_png,'.png','.pdf');
    exportgraphics(gcf,fullfile(figdir,filename_png),'ContentType','image','Resolution',300);


end

