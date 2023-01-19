clear
close all

%% topo
% -----
% topofile = '../bathtopo/M7005.asc';
% gauge_lonlat = [...
%                 141.7500, 39.0200; ... % Ofunato
%                 141.8060, 40.1879; ... % Kuji
%                 ]; % 
% -----
% topofile = '../bathtopo/M7006.asc';
% gauge_lonlat = [140.7230, 41.7854]; % Hakodate
% -----
% topofile = '../bathtopo/M7007.asc';
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
% topofile = '../bathtopo/depth_0090-07_zone09_lonlat.asc';
% gauge_lonlat = [139.8240, 34.9199]; % Mera
% -----
% topofile = '../bathtopo/depth_0090-01_zone08_lonlat.asc';
% gauge_lonlat = [138.2220, 34.6097]; % Omaezaki
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
