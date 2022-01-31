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
speed = 0.3;
wavelength = 1500*0.3;


%% draw border lines
npts = 500;
deg1 = zeros(nt,1);
lat1 = zeros(npts,nt);
lon1 = zeros(npts,nt);
latf = zeros(npts,nt);
lonf = zeros(npts,nt);
latb = zeros(npts,nt);
lonb = zeros(npts,nt);
for j = 1:nt
    deg1(j) = km2deg(speed*t(j));
    [lat1(:,j),lon1(:,j)] = scircle1(lat0,lon0,deg1(j),[],[],'degrees',npts);
    [latf(:,j),lonf(:,j)] = scircle1(lat0,lon0,km2deg(speed*t(j)+0.5*wavelength),[],[],'degrees',npts);
    [latb(:,j),lonb(:,j)] = scircle1(lat0,lon0,max(km2deg(speed*t(j)-0.5*wavelength),1),[],[],'degrees',npts);
end
clon = -60.0;
lon1(lon1<=clon) = lon1(lon1<=clon)+360.0;
lonf(lonf<=clon) = lonf(lonf<=clon)+360.0;
lonb(lonb<=clon) = lonb(lonb<=clon)+360.0;

%% meshgrid interpolation
edge_lon = vertcat(lon(:), lon(:), repmat(lonrange(1),[nlat,1]), repmat(lonrange(2),[nlat,1]));
edge_lat = vertcat(repmat(latrange(1),[nlon,1]), repmat(latrange(2),[nlon,1]), lat(:), lat(:));
edge_0 = zeros(2*(nlon+nlat),1);

p = 2.0;
pres = zeros(nlat,nlon,nt);
for j = 1:nt
    disp(num2str(j,'%d'));
    F = scatteredInterpolant( ...
        vertcat(lon1(:,j),lonf(:,j),lonb(:,j), edge_lon), ...
        vertcat(lat1(:,j),latf(:,j),latb(:,j), edge_lat), ...
        vertcat(p*ones(npts,1),zeros(npts,1),zeros(npts,1), edge_0), ...
        'natural','none');
    pres(:,:,j) = reshape(F(LON(:),LAT(:)),[nlat,nlon]);    
end


%% save
save('pres.mat','-v7.3',...
     'lon0','lat0','lonrange','latrange','lon','lat',...
     'nlon','nlat','dl','pres','npts',...
     'speed','wavelength','dt','t','nt')

 