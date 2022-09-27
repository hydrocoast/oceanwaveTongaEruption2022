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

%% parameters
dt = 600;
t = dt:dt:3600*12;
nt = length(t);
cs = 310.0; % m/s
wavelength = 1500*cs*1e-3; % km
amp = @(r) min(50,180*r^(-0.5)); % km

fig = figure;
%% create pressure data
pres = zeros(nlat, nlon, nt);
for k = 1:nt
    fprintf('%03d,',k);

    %% Lamb wave
    dist_antinode = cs*t(k)*1e-3; % km
    amp_antinode = amp(dist_antinode);

    for i = 1:nlat
    for j = 1:nlon
        %% Lamb wave
        dist_from_antinode = abs(kmmesh(i,j)-dist_antinode); % km
        if dist_from_antinode > 0.5*wavelength
            pres_lamb = 0.0;
        else
            pres_lamb = pressure_anomaly_Lamb(amp_antinode, wavelength, dist_from_antinode);
        end

        %% Composite pressure data
        pres(i,j,k) = pres(i,j,k) + pres_lamb;
    end
    end
    clf(fig); p = pcolor(lon,lat,pres(:,:,k)); shading flat; caxis([-2,2]); colorbar; drawnow; 
end
fprintf('\n');

%% save
save('pres.mat','-v7.3',...
     'lon0','lat0','lonrange','latrange','lon','lat',...
     'nlon','nlat','dl','pres',...
     'cs','wavelength','dt','t','nt')


%% formula - Lamb wave
function pres = pressure_anomaly_Lamb(amp_antinode, wavelength, distance_from_antinode)
    pres = interp1([0; 0.5*wavelength], [amp_antinode; 0.0], distance_from_antinode,'spline');
end
