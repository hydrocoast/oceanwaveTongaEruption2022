clear
close all

%% topo
% topofile = '../bathtopo/gebco_2022_n29.0_s24.0_w124.0_e130.0.nc';
% gauge_lonlat = [...
%         129.540, 28.327; ... % Amami
%         124.170, 24.320; ... % Ishigaki
%         ];
% -----
topofile = '../bathtopo/gebco_2022_n34.0_s33.0_w135.0_e136.0.nc';
gauge_lonlat = [135.761, 33.470]; % Kushimoto
% -----
% topofile = '../bathtopo/gebco_2022_n44.5_s43.5_w144.0_e145.0.nc';
% gauge_lonlat = [144.295, 44.018]; % Abashiri


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
