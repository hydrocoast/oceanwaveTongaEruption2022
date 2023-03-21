clear
close all

%% filename
mat_pres_obs = 'obs_airpressure_anomaly.mat';
mat_pres_1 = 'pres_lg_A.mat';
mat_pres_2 = 'pres_lg_B.mat';
mat_pres_3 = 'pres_lg_C.mat';

load(mat_pres_obs);
D1 = load(mat_pres_1);
D2 = load(mat_pres_2,'pres','t','dt');
D3 = load(mat_pres_3,'pres','t','dt');

lon = D1.lon;
lat = D1.lat;

stationname = 'Naze';
istation = find(cellfun(@(x) strcmp(x,'Naze'),table_obs_pres.Station));

dt_obs = 1;
label_station = table_obs_pres.Station{istation};
%% 時系列データを等間隔に内挿
t_obs = table_obs_pres.Time{istation};
t_uniform = t_obs(1):dt_obs:t_obs(end);
pres_obs = table_obs_pres.Pressure_anomaly{istation};
pres_interp = interp1(t_obs,pres_obs,t_uniform(:),"spline");
%% wavelet analysis
[wt0,f0] = cwt(pres_interp,'morse',1/dt_obs);
perT0 = 1./f0;


% checkpoint = [129.4977,28.3991];
checkpoint = table2array(table_obs_pres(istation,["Lon","Lat"]));
[~,indchk_lon] = min(abs(checkpoint(1)-lon));
[~,indchk_lat] = min(abs(checkpoint(2)-lat));

pres_point1 = squeeze(D1.pres(indchk_lat,indchk_lon,:));
pres_point2 = squeeze(D2.pres(indchk_lat,indchk_lon,:));
pres_point3 = squeeze(D3.pres(indchk_lat,indchk_lon,:));

%% wavelet analysis
[wt1,f1] = cwt(pres_point1,'morse',(1/D1.dt));
[wt2,f2] = cwt(pres_point2,'morse',(1/D2.dt));
[wt3,f3] = cwt(pres_point3,'morse',(1/D3.dt));
perT1 = 1./f1;
perT2 = 1./f2;
perT3 = 1./f3;

%% plot
range_p = [-1.2,2.0];
range_c = [-35,-10];
range_t = [4,15];
tick_t = 0:1:20;
range_perT = [5,120];
tick_perT = [5,10,20,50,100,200];

fig = figure;
p = fig.Position;
fig.Position = [p(1),p(2)-p(4),p(3),2.0*p(4)];
tile = tiledlayout(5,1);

%% time-series
axt = nexttile;
hold on
p0 = plot(t_obs./3600,pres_obs,'k-');
p1 = plot(D1.t./3600, pres_point1, '-');
p2 = plot(D2.t./3600, pres_point2, '-');
p3 = plot(D3.t./3600, pres_point3, '-');
ylim(axt,range_p);
legend([p0,p1,p2,p3],{'Obs.','A','B','C'},'FontName','Helvetica','FontSize',14,'NumColumns',2,'Location','northeast');
grid on; box on
set(axt,'FontName','Helvetica','FontSize',12);
ylabel(axt,'P_{a} (hPa)','FontName','Helvetica','FontSize',14);
axt.XAxis.TickLabels = [];
axt.XAxis.TickValues = tick_t;

%% scalogram
%% Obs
axw0 = nexttile;
pcolor(t_uniform./3600, perT0/60, 20*log10(abs(wt0))); shading flat
ylim(gca,range_perT);
ylabel(gca,'Period (min)','FontName','Helvetica','FontSize',14);
yline([1,10,100],'-','Color',[.8,.8,.8]);
yline([2:1:9,20:10:90,200],'--','Color',[.8,.8,.8],'Alpha',0.5,'LineWidth',0.5);
clim(gca,range_c);
set(gca,'YScale','log','YDir','reverse','FontName','Helvetica','FontSize',12);
axw0.YAxis.TickValues = tick_perT;
axw0.XAxis.TickValues = tick_t;
axw0.XAxis.TickLabels = [];

cb = colorbar(axw0,'east','FontName','Helvetica','FontSize',12);
cb.Label.String = 'Power (dB)';
cb.Label.Color = 'w';
cb.Color = 'w';

%% A
axw1 = nexttile;
pcolor(D1.t./3600, perT1/60, 20*log10(abs(wt1))); shading flat
ylim(gca,range_perT);
% ylabel(gca,'Period (min)','FontName','Helvetica','FontSize',14);
yline(gca,[1,10,100],'-','Color',[.8,.8,.8]);
yline(gca,[2:1:9,20:10:90,200],'--','Color',[.8,.8,.8],'Alpha',0.5,'LineWidth',0.5);
clim(gca,range_c);
set(gca,'YScale','log','YDir','reverse','FontName','Helvetica','FontSize',12);
axw1.YAxis.TickValues = tick_perT;
axw1.XAxis.TickValues = tick_t;
axw1.XAxis.TickLabels = [];

%% B
axw2 = nexttile;
pcolor(D2.t./3600, perT2/60, 20*log10(abs(wt2))); shading flat
ylim(gca,range_perT);
% ylabel(gca,'Period (min)','FontName','Helvetica','FontSize',14);
yline(gca,[1,10,100],'-','Color',[.8,.8,.8]);
yline(gca,[2:1:9,20:10:90,200],'--','Color',[.8,.8,.8],'Alpha',0.5,'LineWidth',0.5);
clim(gca,range_c);
set(gca,'YScale','log','YDir','reverse','FontName','Helvetica','FontSize',12);
axw2.YAxis.TickValues = tick_perT;
axw2.XAxis.TickValues = tick_t;
axw2.XAxis.TickLabels = [];

%% C
axw3 = nexttile;
pcolor(D3.t./3600, perT3/60, 20*log10(abs(wt3))); shading flat
ylim(gca,range_perT);
% ylabel(gca,'Period (min)','FontName','Helvetica','FontSize',14);
yline(gca,[1,10,100],'-','Color',[.8,.8,.8]);
yline(gca,[2:1:9,20:10:90,200],'--','Color',[.8,.8,.8],'Alpha',0.5,'LineWidth',0.5);
clim(gca,range_c);
set(gca,'YScale','log','YDir','reverse','FontName','Helvetica','FontSize',12);
axw3.YAxis.TickValues = tick_perT;
axw3.XAxis.TickValues = tick_t;
% axw3.XAxis.TickLabels = [];
xlabel(axw3,'Elapsed time (h)','FontName','Helvetica','FontSize',14);
linkaxes([axw0,axw1,axw2,axw3],'xy');
linkaxes([axt,axw0,axw1,axw2,axw3],'x');
xlim(axt,range_t);

tile.TileSpacing = 'tight';
tile.Padding = 'compact';


%% text
text(axw0,5,15,'Obs.','FontName','Helvetica','FontSize',16,'HorizontalAlignment','left','VerticalAlignment','middle','Color','w');
text(axw1,5,15,'A','FontName','Helvetica','FontSize',16,'HorizontalAlignment','left','VerticalAlignment','middle','Color','w');
text(axw2,5,15,'B','FontName','Helvetica','FontSize',16,'HorizontalAlignment','left','VerticalAlignment','middle','Color','w');
text(axw3,5,15,'C','FontName','Helvetica','FontSize',16,'HorizontalAlignment','left','VerticalAlignment','middle','Color','w');

% %% print
% filename_png = ['wavelet_pres_',label_station,'.png'];
% filename_pdf = strrep(filename_png,'.png','.pdf');
% exportgraphics(gcf,fullfile(figdir,filename_png),'ContentType','image','Resolution',300);
