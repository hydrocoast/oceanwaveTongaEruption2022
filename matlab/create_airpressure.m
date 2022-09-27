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
t = dt:dt:3600*14;
nt = length(t);
cs = 310.0; % m/s
wavelength = 1500*cs*1e-3; % km
amp = @(r) min(50,180*r^(-0.5)); % km


%% parameters for air gravity waves
g = 9.8; % m/s^2
% N = 1.16e-2; % /s
N = 1.7e-2; % /s
mu = 0.5*(N^2/g + g/cs^2); % /m ?
sigma0 = mu*cs;
wavelength_g = wavelength*[0.5; 0.25; 0.20]; % km
nwave_g = length(wavelength_g);
k_g = 2*pi./(wavelength_g.*1e3);

sigma_g = zeros(nwave_g,1);
for iwave = 1:nwave_g
    sigma_g(iwave) = dispersion_relation_airgravitywave(k_g(iwave),mu,N,cs,0.0);
end
c_g = sigma_g./k_g;
amp_g = 0.5;


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
%     clf(fig); pcolor(lon,lat,pres(:,:,k)); shading flat; caxis([-1,1]); colorbar; drawnow; 
end
fprintf('\n');

%% Gravity wave(s)
for k = 1:nt
    fprintf('%03d,',k);
    dist_antinode = c_g.*t(k)*1e-3; % km
    for i = 1:nlat
    for j = 1:nlon
        pres_grav = 0.0;
        for iwave = 1:nwave_g
           dist_from_antinode = kmmesh(i,j)-dist_antinode(iwave); % km
           if abs(dist_from_antinode) > 0.5*wavelength_g(iwave); continue; end
           pres_add = pressure_anomaly_airgravitywave(amp_g,wavelength_g(iwave),dist_from_antinode);
           if isnan(pres_add)
               disp(pres_add);
           end
           pres_grav = pres_grav + pres_add;
        end
        pres(i,j,k) = pres(i,j,k) + pres_grav;
    end
    end
    clf(fig); pcolor(lon,lat,pres(:,:,k)); shading flat; caxis([-1,1]); colorbar; drawnow; 
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


%% formula - dispersion relation of gravity waves
function sigma_g = dispersion_relation_airgravitywave(k,mu,N,cs,n)
    sigma_g = sqrt( ...
                    0.5*cs^2*(k^2+n^2+mu^2)* ...
                    (1-sqrt(1-(4*k^2*N^2/(cs^2*(k^2+n^2+mu^2)^2)))) ...
                   );
end

%% formula - air gravity wave
function pres = pressure_anomaly_airgravitywave(amp_antinode, wavelength, distance_from_antinode)
    x = linspace(-0.5*wavelength,0.5*wavelength,100);
    p = amp_antinode*sin(2*pi/wavelength*x);
    pres = interp1(x,p,distance_from_antinode,'linear');
end


