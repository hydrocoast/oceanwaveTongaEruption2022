clear
close all


%% filenames
matfile_DART = 'DART_records.mat';
figdir = 'fig_wlanalysis';

%% load
load(matfile_DART);
nstation = size(table_DART,1);

%% parameters
fs = 1/60; % Hz
dt = 1/fs; % s


%% wavelet analysis for each station
if ~isfolder(figdir); mkdir(figdir); end
fig = figure; print(fig,'-dpng','tmp.png'); delete('tmp.png');

% for i = 1:nstation
for i = 1:1

    label_station = sprintf('%d',table_DART.DART(i));

    %% 時系列データを等間隔に内挿
    t_obs = table_DART.Time{i};
    if isempty(t_obs); disp(['skip: ',label_station]); continue; end

    t_uniform = t_obs(1):dt:t_obs(end);
    surf_obs = table_DART.Eta_filtered{i};
    surf_interp = interp1(t_obs,surf_obs,t_uniform(:),"spline");
        
    %% wavelet analysis
    [wt,f] = cwt(surf_interp,'morse',fs);
    perT = 1./f;

    %% plot
    range_t = [-2,18];

    figure(fig); clf(fig);
    tile = tiledlayout(3,1);

    %% time-series
    axt = nexttile;
    plot(t_uniform./3600, surf_interp, '-'); hold on
    grid on
    set(axt,'FontName','Helvetica','FontSize',12);
    ylabel(axt,'\eta (cm)','FontName','Helvetica','FontSize',14);
    axt.XAxis.TickLabels = [];
    
    %% scalogram
    axw = nexttile([2,1]);
    pcolor(t_uniform./3600,perT./60,20*log10(abs(wt))); shading flat
    ylim(axw,[2,240]);
    ylabel(axw,'Period (min)','FontName','Helvetica','FontSize',14);
    axw.YAxis.TickValues = [2,5,10,20,50,100,200];
    yline([10,100],'-','Color',[.8,.8,.8]);
    yline([2:1:9,20:10:90,200],'--','Color',[.8,.8,.8],'Alpha',0.5,'LineWidth',0.5);

    caxis(axw,[-30,0]);
    set(axw,'YScale','log','YDir','reverse','FontName','Helvetica','FontSize',12);

    cb = colorbar(axw,'west','FontName','Helvetica','FontSize',12);
    cb.Label.String = 'Power (dB)';
    cb.Label.Color = 'w';
    cb.Color = 'w';

    xlabel(axw,'Time (h)','FontName','Helvetica','FontSize',14);
    linkaxes([axt,axw],'x');
    xlim(axt,range_t);

    tile.TileSpacing = 'tight';
    tile.Padding = 'compact';

    %% print
    filename_png = ['wavelet_DART_',label_station,'.png'];
    filename_pdf = strrep(filename_png,'.png','.pdf');
    exportgraphics(gcf,fullfile(figdir,filename_png),'ContentType','image','Resolution',300);


end

