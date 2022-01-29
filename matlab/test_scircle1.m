clear
close all

%% origin
lat0 =  -20.544686;
lon0 = -175.393311 + 360.0;

%%
latrange = [-60,60];
lonrange = [120,300];

%% dt
dt = 1800;
t = dt:dt:3600*8;
nt = length(t);
speed = 0.3;

%% test
% [lat1,lon1] = scircle1(lat0,lon0,10,'degrees');
% lon1(lon1<=90.0) = lon1(lon1<=90.0)+360.0;
%%
lat1 = zeros(100,nt);
lon1 = zeros(100,nt);
deg1 = zeros(nt,1);
for j = 1:nt
    deg1(j) = km2deg(speed*t(j));
    [lat1(:,j),lon1(:,j)] = scircle1(lat0,lon0,deg1(j),'degrees');
end
lon1(lon1<=-60.0) = lon1(lon1<=-60.0)+360.0;

%% 2d
figure
gx = geoaxes;
hold(gx,'on')
p = geoplot(lat0,lon0,'kp','MarkerFaceColor','y','MarkerSize',20);
% geoplot(gx,lat1,lon1,'r','LineWidth',2)
for j = 1:2:nt
    geoplot(gx,lat1(:,j),lon1(:,j),'k--','LineWidth',1)
end
for j = 2:2:nt
    geoplot(gx,lat1(:,j),lon1(:,j),'k-','LineWidth',1)
end
geobasemap(gx,'colorterrain')
geolimits(gx,latrange,lonrange)

%% 3d
% uif = uifigure;
% g = geoglobe(uif,'Terrain','none');
% hold(g,'on')
% geoplot3(g,lat0,lon0,0,'ko');
% geoplot3(g,lat1,lon1,zeros(numel(lon1),1),'r','LineWidth',2)





