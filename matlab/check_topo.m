clear
close all

%% 水深データの確認空間分布の表示

%% read
topofile = '../bathtopo/zone01_depth_0090-03_lonlat.asc';

topodata = Topo(topofile);

topodata.plottopo();
axis equal tight
demcmap([-1000,500])
colorbar;
