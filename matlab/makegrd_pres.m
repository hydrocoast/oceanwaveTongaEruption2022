clear
close all

%% filename
matfile = 'pres_l.mat';
load(matfile)

nskip = 20;

for k = nskip:nskip:nt
    fname_grd = sprintf('pres_%04dmin.grd',round(t(k)/60));
    grdwrite2(lon,lat,squeeze(pres(:,:,k)),fname_grd);
end
