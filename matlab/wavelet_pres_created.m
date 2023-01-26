clear
close all

% matname_pres = 'pres_l.mat';
matname_pres = 'pres_lg.mat';
% matname_pres = 'pres_lg_N1.6.mat';
load(matname_pres);

%% parameters
fs = 1/dt; % Hz


checkpoint = [135.0,32.5];
[~,indchk_lon] = min(abs(checkpoint(1)-lon));
[~,indchk_lat] = min(abs(checkpoint(2)-lat));

pres_point = squeeze(pres(indchk_lat,indchk_lon,:));


%% wavelet analysis
[wt,f] = cwt(pres_point,'morse',fs);
perT = 1./f;

%% plot
range_t = [0,15];

fig = figure;
tile = tiledlayout(3,1);

%% time-series
axt = nexttile;
plot(t./3600, pres_point, '-'); hold on
grid on
set(axt,'FontName','Helvetica','FontSize',12);
ylabel(axt,'P_{a} (hPa)','FontName','Helvetica','FontSize',14);
axt.XAxis.TickLabels = [];


%% scalogram
axw = nexttile([2,1]);
pcolor(t./3600,perT/60,20*log10(abs(wt))); shading flat
ylim(axw,[1,240]);
ylabel(axw,'Period (min)','FontName','Helvetica','FontSize',14);
axw.YAxis.TickValues = [1,2,5,10,20,50,100,200];
yline([1,10,100],'-','Color',[.8,.8,.8]);
yline([2:1:9,20:10:90,200],'--','Color',[.8,.8,.8],'Alpha',0.5,'LineWidth',0.5);

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

% %% print
% filename_png = ['wavelet_pres_',label_station,'.png'];
% filename_pdf = strrep(filename_png,'.png','.pdf');
% exportgraphics(gcf,fullfile(figdir,filename_png),'ContentType','image','Resolution',300);
