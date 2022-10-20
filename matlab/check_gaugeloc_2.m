clear
close all

%% topo
topofile = '../bathtopo/gebco_2022_n50.0_s20.0_w120.0_e150.0.nc';
[lon,lat,topo] = grdread2(topofile);

%% gauge
gauge_lonlat = [...
        129.5333, 28.3167; ... % Amami
        124.1667, 24.3333; ... % Ishigaki
        135.7667, 33.4833; ... % Kushimoto
        144.2833, 44.0167; ... % Abashiri
        ];
ngauge = size(gauge_lonlat,1);

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
