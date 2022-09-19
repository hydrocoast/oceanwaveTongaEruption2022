clear
close all

%% origin
lat0 =  -20.544686;
lon0 = -175.393311 + 360.0;

%% lonlat
latrange = [-60,60];
lonrange = [120,300];
dl = 0.25;
nlon = round(abs(diff(lonrange))/dl)+1;
nlat = round(abs(diff(latrange))/dl)+1;
lon = linspace(lonrange(1),lonrange(2),nlon);
lat = linspace(latrange(1),latrange(2),nlat);
[LON,LAT] = meshgrid(lon,lat);

degmesh = sqrt((LON-lon0).^2 + (LAT-lat0).^2);
kmmesh = deg2km(degmesh);

%% params
dt = 600;
t = dt:dt:3600*10;
nt = length(t);
c_phapse = 0.3;
wavelength = 1500*c_phapse;
amp = @(r) min(50,180*r^(-0.5));

%% create
for k = 1:nt
    minpres = amp(c_phapse*t(k));


% 
%     for j = 1:nlat
%     for i = 1:nlon
% 
%     end
%     end
end

% %% save
% save('pres.mat','-v7.3',...
%      'lon0','lat0','lonrange','latrange','lon','lat',...
%      'nlon','nlat','dl','pres',...
%      'c_phapse','wavelength','dt','t','nt')


function calpres