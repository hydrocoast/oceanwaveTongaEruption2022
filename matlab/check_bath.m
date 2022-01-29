clear
close all


topofile = './gebco_2021_n60.0_s-60.0_w120.0_e300.0.nc';

[lon,lat,bath] = Topo.grdread2(topofile);


figure
ax = gca;
imagesc(lon,lat,bath); ax.YDir  = 'normal';
axis equal tight
demcmap([-5000,5000]);
cb = colorbar;



