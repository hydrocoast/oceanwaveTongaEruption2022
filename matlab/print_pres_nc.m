clear
close all

%% 作成した気圧データをGeoClawで計算するためのテキストファイルに出力

%% filename
% matfile = 'pres_lamb.mat';
matfile = 'pres_lg_A.mat';
% matfile = 'pres_lg_B.mat';
load(matfile)

%% output
ncdir = './slp_nc';
if exist(ncdir,'dir'); system(['rm -rf  ', ncdir]); end
mkdir(ncdir);

ncfile_base = 'slp_XXX.nc';

nt = length(t);

% for k = 1:3
for k = 1:nt
    ncfile = fullfile(ncdir,strrep(ncfile_base,'XXX',sprintf('%04d',k)));
    disp([ncfile, '   ...']);

    % % pressure
    nccreate(ncfile,'slp',"Dimensions",{"x",nlon,"y",nlat},"FillValue","disable","Format","netcdf4");
    ncwrite(ncfile,'slp',squeeze(pres(:,:,k))');
    % % lonlat
    nccreate(ncfile,'lon',"Dimensions",{"x",nlon},"FillValue","disable");
    nccreate(ncfile,'lat',"Dimensions",{"y",nlat},"FillValue","disable");
    ncwrite(ncfile,'lon',lon);
    ncwrite(ncfile,'lat',lat);
    % % time
    nccreate(ncfile,'time');
    ncwrite(ncfile,'time',t(k));
end
