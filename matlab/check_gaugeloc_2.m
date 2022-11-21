clear
close all

%% topo
% topofile = '../bathtopo/gebco_2022_n29.0_s28.0_w129.0_e130.0.nc';
% gauge_lonlat = [129.555, 28.325];% Amami
% -----
% topofile = '../bathtopo/gebco_2022_n25.0_s24.0_w123.6_e124.6.nc';
% gauge_lonlat = [124.171, 24.315]; % Ishigaki
% -----
% topofile = '../bathtopo/gebco_2022_n34.0_s33.0_w135.0_e136.0.nc';
% gauge_lonlat = [135.758, 33.470]; % Kushimoto
% -----
% topofile = '../bathtopo/gebco_2022_n44.5_s43.5_w144.0_e145.0.nc';
% gauge_lonlat = [144.297, 44.020]; % Abashiri
% -----
% topofile = '../bathtopo/gebco_2022_n43.5_s42.5_w144.0_e146.0.nc';
% gauge_lonlat = [145.5770, 43.2771]; % Hanasaki
% -----
% topofile = '../bathtopo/gebco_2022_n43.5_s42.5_w144.0_e146.0.nc';
% gauge_lonlat = [144.369, 42.9813]; % Kushiro
% -----
% topofile = '../bathtopo/gebco_2022_n42.0_s41.0_w140.0_e141.0.nc';
% gauge_lonlat = [140.723, 41.7854]; % Hakodate
% -----
% topofile = '../bathtopo/gebco_2022_n40.0_s38.0_w140.0_e142.0.nc';
% gauge_lonlat = [141.75, 39.02]; % Ofunato
% -----
% topofile = '../bathtopo/gebco_2022_n36.0_s34.0_w139.0_e140.0.nc';
% gauge_lonlat = [139.8230, 34.9188]; % Mera
% -----
% topofile = '../bathtopo/gebco_2022_n36.0_s34.0_w137.0_e139.0.nc';
% gauge_lonlat = [138.2270, 34.6146]; % Omaezaki
% -----
topofile = '../bathtopo/gebco_2022_n37.0_s25.0_w127.0_e129.0.nc';
gauge_lonlat = [127.6520, 26.2271]; % Naha
% -----


ngauge = size(gauge_lonlat,1);
[lon,lat,topo] = grdread2(topofile);


%% plot
for i = 1:ngauge
    figure
    pcolor(lon,lat,topo); axis equal; shading flat
    demcmap([-6000,4000]);
    hold on
    plot(gauge_lonlat(i,1),gauge_lonlat(i,2),'ko','MarkerFaceColor','m');
    hold off
    xlim([gauge_lonlat(i,1)-0.1,gauge_lonlat(i,1)+0.1])
    ylim([gauge_lonlat(i,2)-0.1,gauge_lonlat(i,2)+0.1])
end
