clear
close all

%% load obs
load('obs_airpressure_anomaly.mat');

lat_obs = [table_obs_pres.Lat];
lon_obs = [table_obs_pres.Lon];
np_obs = size(table_obs_pres,1);

%% parametric pressure file
load('pres_l.mat');
% load('pres_lg.mat');


%% 
for i = 1:np_obs
    [~,indobs_lon(i)] = min(abs(lon_obs(i)-lon));
    [~,indobs_lat(i)] = min(abs(lat_obs(i)-lat));
end

figure
gax = geoaxes;
geoplot(lat(indobs_lat), lon(indobs_lon), 'ko', 'MarkerFaceColor','m');


figure
tile = tiledlayout(2,1);

i = 6;
ax = nexttile;
p1 = plot(t./3600, squeeze(pres(indobs_lat(i), indobs_lon(i),:))); hold on
p2 = plot(cell2mat(table_obs_pres{i,"Time"})./3600,cell2mat(table_obs_pres{i,"Pressure_anomaly"}));
xlim(ax,[-0.5,13.0]);
grid on
set(ax,'FontName','Helvetica','FontSize',12)
xlabel(ax,'Time (hour)','FontName','Helvetica','FontSize',14);
ylabel(ax,'Pressure anomaly (hPa)','FontName','Helvetica','FontSize',14);
text(ax, 0.1*(ax.XLim(end)-ax.XLim(1))+ax.XLim(1), 0.9*(ax.YLim(end)-ax.YLim(1))+ax.YLim(1), table_obs_pres{i,"Station"},'FontName','Helvetica','FontSize',14);
legend([p1,p2],{'cal.','obs.'},'FontName','Helvetica','FontSize',14)

i = 15;
ax = nexttile;
p1 = plot(t./3600, squeeze(pres(indobs_lat(i), indobs_lon(i),:))); hold on
p2 = plot(cell2mat(table_obs_pres{i,"Time"})./3600,cell2mat(table_obs_pres{i,"Pressure_anomaly"}));
xlim(ax,[-0.5,13.0]);
grid on
set(ax,'FontName','Helvetica','FontSize',12)
xlabel(ax,'Time (hour)','FontName','Helvetica','FontSize',14);
ylabel(ax,'Pressure anomaly (hPa)','FontName','Helvetica','FontSize',14);
text(ax, 0.1*(ax.XLim(end)-ax.XLim(1))+ax.XLim(1), 0.9*(ax.YLim(end)-ax.YLim(1))+ax.YLim(1), table_obs_pres{i,"Station"},'FontName','Helvetica','FontSize',14);
legend([p1,p2],{'cal.','obs.'},'FontName','Helvetica','FontSize',14)


tile.Padding = 'compact';
tile.TileSpacing = 'tight';






