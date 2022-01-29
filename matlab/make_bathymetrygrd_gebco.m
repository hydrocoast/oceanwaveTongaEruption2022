clear
close all

%% filenames
dname = '../../dataset/GEBCO';
file1 = 'gebco_2021_n60.0_s-60.0_w-160.0_e-60.0.nc';
file2 = 'gebco_2021_n60.0_s-60.0_w120.0_e200.0.nc';
file_out = 'gebco_2021_n60.0_s-60.0_w120.0_e300.0.nc';

%% grdread
[lat1,lon1,b1] = Topo.grdread2(fullfile(dname,file1));
[lat2,lon2,b2] = Topo.grdread2(fullfile(dname,file2));

%% combine
lon1 = lon1+360.0;
lon = horzcat(lon2,lon1);
lat = lat1;
bath = horzcat(b2,b1);

%% grdwrite
Topo.grdwrite2(lon,lat,bath,file_out);


%% plot
figure
ax = gca;
imagesc(lon,lat,bath); ax.YDir = 'normal';
axis equal tight
demcmap([-5000,5000]);
colorbar;

