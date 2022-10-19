clear
close all

%% 水深データの確認空間分布の表示
% --- GEBCO2022, 2021
% --- sqrt(g*h) から長波の波速分布も表示


%% read
topofile = '../bathtopo/gebco_2022_n60.0_s-60.0_w110.0_e240.0.nc';
[lon,lat,topo] = grdread2(topofile);

%% bath
figure
ax = gca;
imagesc(lon,lat,topo); ax.YDir  = 'normal';
axis equal tight
demcmap([-7000,4000]);
cb = colorbar;

%% wave celerity
g = 9.8;
c = -topo;
c(c<0.0) = NaN;
c = sqrt(g*c); % sqrt(g*h)

[~,ind_west] = min(abs(lon-110.0));
[~,ind_east] = min(abs(lon-155.0));
[~,ind_south] = min(abs(lat-10.0));
[~,ind_north] = min(abs(lat-50.0));

lonj = lon(ind_west:ind_east);
latj = lat(ind_south:ind_north);
cj = c(ind_south:ind_north,ind_west:ind_east);


figure;
ax = gca;
pcolor(lonj,latj,cj); shading flat
axis equal tight
colormap(ax,parula(15));
caxis(ax,[170,320]);
cb = colorbar;





