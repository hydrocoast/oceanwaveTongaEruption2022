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

    % % lonlat
    nccreate(ncfile,'lon',"Dimensions",{"lon",nlon},"FillValue","disable","Datatype", "single");
    nccreate(ncfile,'lat',"Dimensions",{"lat",nlat},"FillValue","disable","Datatype", "single");
    %nccreate(ncfile,'lon',"Dimensions",{"lon",nlon},"FillValue","disable","Datatype", "double","Format","netcdf4");
    %nccreate(ncfile,'lat',"Dimensions",{"lat",nlat},"FillValue","disable","Datatype", "double","Format","netcdf4");
    ncwrite(ncfile,'lon',lon);
    ncwrite(ncfile,'lat',lat);
    % % pressure
    nccreate(ncfile,'slp',"Dimensions",{"lon",nlon,"lat",nlat},"FillValue","disable","Datatype", "single");
    %nccreate(ncfile,'slp',"Dimensions",{"lon",nlon,"lat",nlat},"FillValue","disable","Format","netcdf4", "Datatype", "double");
    ncwrite(ncfile,'slp',flipud(permute(pres(:,:,k),[2,1])));
    %ncwrite(ncfile,'slp',permute(pres(:,:,k),[2,1]));
    % % time
    nccreate(ncfile,'time',"Datatype", "single");
    %nccreate(ncfile,'time',"Datatype", "double");
    ncwrite(ncfile,'time',t(k));
end
