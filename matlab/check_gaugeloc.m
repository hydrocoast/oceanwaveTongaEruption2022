clear
close all

%% 
T = readtable('~/Dropbox/miyashita/dataset/Tonga2022/IOC_JPRUS.txt');
ngauge = size(T);

%% read
topofile = '../bathtopo/gebco_2022_n60.0_s-60.0_w110.0_e240.0.nc';
[lon,lat,topo] = Topo.grdread2(topofile);

%% bath
figure
ax = gca;
imagesc(lon,lat,topo); ax.YDir  = 'normal';
axis equal tight
demcmap([-7000,4000]);
cb = colorbar;
xlim([125,150]);
ylim([25,50]);

hold on
plot(T.Lon,T.Lat,'ko','MarkerFaceColor','r');
hold off




