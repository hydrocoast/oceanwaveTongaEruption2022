clear
close all

%% load obs
load('obs_airpressure_anomaly.mat');

lat_obs = [table_obs_pres.Lat];
lon_obs = [table_obs_pres.Lon];
np_obs = size(table_obs_pres,1);

%% parametric pressure file
% load('pres_l_wp.mat');
% load('pres_lg_wp.mat');
load('pres_lg_B.mat');


%% 
for i = 1:np_obs
    [~,indobs_lon(i)] = min(abs(lon_obs(i)-lon));
    [~,indobs_lat(i)] = min(abs(lat_obs(i)-lat));
end

fig1 = figure;
gax = geoaxes;
geoplot(lat(indobs_lat), lon(indobs_lon), 'ko', 'MarkerFaceColor','m');


fig2 = figure;
tile = tiledlayout(2,1);

i = 6;
ax(1) = nexttile;
p1 = plot(t./3600, squeeze(pres(indobs_lat(i), indobs_lon(i),:))); hold on
p2 = plot(cell2mat(table_obs_pres{i,"Time"})./3600,cell2mat(table_obs_pres{i,"Pressure_anomaly"}));
xlim(ax(1),[-0.5,16.0]);
grid on
set(ax(1),'FontName','Helvetica','FontSize',12)
% xlabel(ax(1),'Time (hour)','FontName','Helvetica','FontSize',14);
% ylabel(ax(1),'Pressure anomaly (hPa)','FontName','Helvetica','FontSize',14);
ax(1).XAxis.TickLabels = [];
ax(1).YAxis.TickLabelFormat = '%0.1f';
% text(ax(1), 0.1*(ax(1).XLim(end)-ax(1).XLim(1))+ax(1).XLim(1), 0.9*(ax(1).YLim(end)-ax(1).YLim(1))+ax(1).YLim(1), table_obs_pres{i,"Station"},'FontName','Helvetica','FontSize',14);
text(ax(1),1.0,1.5,table_obs_pres{i,"Station"},'FontName','Helvetica','FontSize',14)
legend(ax(1),[p1,p2],{'cal.','obs.'},'FontName','Helvetica','FontSize',14)

i = 15;
ax(2) = nexttile;
p1 = plot(t./3600, squeeze(pres(indobs_lat(i), indobs_lon(i),:))); hold on
p2 = plot(cell2mat(table_obs_pres{i,"Time"})./3600,cell2mat(table_obs_pres{i,"Pressure_anomaly"}));
xlim(ax(2),[-0.5,16.0]);
grid on
set(ax(2),'FontName','Helvetica','FontSize',12)
xlabel(ax(2),'Time (hour)','FontName','Helvetica','FontSize',14);
ylabel(ax(2),'Pressure anomaly (hPa)','FontName','Helvetica','FontSize',14);
ax(2).YAxis.TickLabelFormat = '%0.1f';
% text(ax(2), 0.1*(ax(2).XLim(end)-ax(2).XLim(1))+ax(2).XLim(1), 0.9*(ax(2).YLim(end)-ax(2).YLim(1))+ax(1).YLim(1), table_obs_pres{i,"Station"},'FontName','Helvetica','FontSize',14);
text(ax(2),1.0,1.5,table_obs_pres{i,"Station"},'FontName','Helvetica','FontSize',14)
legend([p1,p2],{'cal.','obs.'},'FontName','Helvetica','FontSize',14)

linkaxes(ax,'xy');
tile.Padding = 'compact';
tile.TileSpacing = 'tight';


%% print
exportgraphics(fig2,'comparison_pressure.png','Resolution',300);
exportgraphics(fig2,'comparison_pressure.pdf','ContentType','vector');



