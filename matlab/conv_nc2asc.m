clear
close all


ncfile = '../bathtopo/gebco_2022_n60.0_s-60.0_w110.0_e240.0.nc';
[x,y,bath] = Topo.grdread2(ncfile);
topo = Topo(ncfile);
topo.ncols = length(x);
topo.nrows = length(y);
topo.xlower = x(1);
topo.ylower = y(1);
topo.cellsize = 1/60/4;
topo.nodata_value = -9999;
topo.topo = -bath;
topo.coordinates = 'lonlat';


topo.printtopo(strrep(ncfile,'.nc','.asc'));

