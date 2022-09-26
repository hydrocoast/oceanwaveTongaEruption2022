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
t = dt:dt:3600*12;
nt = length(t);
c_phapse = 0.3;
wavelength = 1500*c_phapse;
amp = @(r) min(50,180*r^(-0.5));

%% create
pres = zeros(nlat, nlon);
for k = 1:nt
    dist_antinode = c_phapse*t(k);
    amp_antinode = amp(dist_antinode);
    for i = 1:nlat
    for j = 1:nlon
        distance_from_antinode = abs(kmmesh(i,j)-dist_antinode);
        if distance_from_antinode > 0.5*wavelength; continue; end
        pres(i,j,k) = pressure_anomaly_Lamb(amp_antinode, wavelength, distance_from_antinode);
    end
    end
end

%% save
save('pres.mat','-v7.3',...
     'lon0','lat0','lonrange','latrange','lon','lat',...
     'nlon','nlat','dl','pres',...
     'c_phapse','wavelength','dt','t','nt')


function pres = pressure_anomaly_Lamb(amp_antinode, wavelength, distance_from_antinode)
    pres = interp1([0; 0.5*wavelength], [amp_antinode; 0.0], distance_from_antinode,'spline');
end
