clear
close all

%% topo
% -----
% topofile = '../bathtopo/M7005a.asc';
% gauge_lonlat = [141.5040, 38.2931; 141.7490, 39.0174]; % Ayukawa, Ofunato
% -----
% topofile = '../bathtopo/M7005b.asc';
% gauge_lonlat = [141.8060, 40.1879]; % Kuji
% -----
% topofile = '../bathtopo/M7006.asc';
% gauge_lonlat = [140.7230, 41.7854]; % Hakodate
% -----
% topofile = '../bathtopo/M7007a.asc';
% gauge_lonlat = [144.3690, 42.9813]; % Kushiro
% -----
% topofile = '../bathtopo/M7007b.asc';
% gauge_lonlat = [145.5700, 43.2771]; % Hanasaki
% -----
% topofile = '../bathtopo/M7020.asc';
% gauge_lonlat = [127.6560, 26.2229]; % Naha
% -----
% topofile = '../bathtopo/M7021.asc';
% gauge_lonlat = [124.169, 24.3229]; % Ishigaki
% -----
% topofile = '../bathtopo/M7023.asc';
% gauge_lonlat = [142.1960, 27.0931]; % Chichijima
% -----
% topofile = '../bathtopo/depth_0090-01_zone08_lonlat.asc';
% gauge_lonlat = [138.2220, 34.6097]; % Omaezaki
% -----
% topofile = '../bathtopo/depth_0090-03_zone01_lonlat.asc';
% gauge_lonlat = [129.5370, 28.3229]; % Amami
% -----
% topofile = '../bathtopo/depth_0090-03_zone06_lonlat.asc';
% gauge_lonlat = [135.7720, 33.4757; 135.9060, 33.5618]; % Kushimoto, Uragami
% -----
% topofile = '../bathtopo/depth_0030-07_zone06_lonlat.asc';
% gauge_lonlat = [135.7740, 33.4773]; % Kushimoto
% -----
% topofile = '../bathtopo/depth_0030-08_zone06_lonlat.asc';
% gauge_lonlat = [135.8970, 33.5591]; % Uragami
% -----
% topofile = '../bathtopo/depth_0090-02_zone04_lonlat.asc';
% gauge_lonlat = [132.9580, 32.7745]; % Tosashimizu
% -----
% topofile = '../bathtopo/depth_0030-06_zone04_lonlat.asc';
% gauge_lonlat = [132.9580, 32.7779]; % Tosashimizu
% -----
% topofile = '../bathtopo/depth_0090-04_zone04_lonlat.asc';
% gauge_lonlat = [134.1640, 33.2634]; % Muroto
% -----
% topofile = '../bathtopo/depth_0030-11_zone04_lonlat.asc';
% gauge_lonlat = [134.1642, 33.2644]; % Muroto
% -----
% topofile = '../bathtopo/depth_0090-05_zone09_lonlat.asc';
% gauge_lonlat = [139.6130, 35.1477]; % Misakigyoko
% -----
% topofile = '../bathtopo/depth_0090-07_zone09_lonlat.asc';
% gauge_lonlat = [139.8240, 34.9199; 140.2500, 35.1310]; % Mera, Katuura
% -----
% topofile = '../bathtopo/depth_0090-09_zone09_lonlat.asc';
% gauge_lonlat = [140.8585, 35.7522]; % Choshi
% -----
% topofile = '../bathtopo/depth_0090-10_zone09_lonlat.asc';
% gauge_lonlat = [140.5745, 36.3054]; % Oarai
% -----
% topofile = '../bathtopo/depth_0090-11_zone09_lonlat.asc';
% gauge_lonlat = [140.8916, 36.9330]; % Onahama
% -----


ngauge = size(gauge_lonlat,1);

topo = Topo(topofile);
topo.coordinates = 'lonlat';

%% plot
    figure
    topo.plottopo;
    axis equal tight
    demcmap([-6000,4000]);
    hold on
    plot(gauge_lonlat(:,1),gauge_lonlat(:,2),'ko','MarkerFaceColor','m');
    hold off
