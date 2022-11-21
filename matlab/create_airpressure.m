clear
close all

%% 気圧データの作成
% --- Lamb波＋大気重力波
%% gravity wave switch
active_g = 0; % 1: on, otherwise: off

%% filenames
if active_g==1
    matname_pres = 'pres_lg.mat';
else
    matname_pres = 'pres_l.mat';
end

%% origin
lat0 =  -20.544686;
lon0 = -175.393311 + 360.0;

%% lonlat
latrange = [-60,60];
lonrange = [110,300];
dl = 0.25;
nlon = round(abs(diff(lonrange))/dl)+1;
nlat = round(abs(diff(latrange))/dl)+1;
lon = linspace(lonrange(1),lonrange(2),nlon);
lat = linspace(latrange(1),latrange(2),nlat);
[LON,LAT] = meshgrid(lon,lat);

degmesh = sqrt((LON-lon0).^2 + (LAT-lat0).^2);
kmmesh = deg2km(degmesh);

checkpoint = [135.0,32.5];
[~,indchk_lon] = min(abs(checkpoint(1)-lon));
[~,indchk_lat] = min(abs(checkpoint(2)-lat));


%% parameters
dt = 300;
t = dt:dt:3600*14;
nt = length(t);
%% parameters below are based on Gusman et al.(2022), PAGEOPH
% https://link.springer.com/article/10.1007/s00024-022-03154-1
% cs = 317.0; % m/s
cs = 310.0; % m/s
wavelength = 1500*cs*1e-3; % km
coef_lamb_peak = 169;
coef_lamb_trough = -107;
amp = @(r,a) sign(a)*min(abs(a),abs(a*r^(-0.5))); % km

coef_lamb_add = 25;
wavelength_add = 4.0*wavelength; % km


%% parameters for air gravity waves
if active_g == 1
    g = 9.8; % m/s^2
%     N = 1.16e-2; % /s
    N = 1.7e-2; % /s
    mu = 0.5*(N^2/g + g/cs^2); % /m
    sigma0 = mu*cs;
%     wavelength_g = wavelength*[2.0; 1.00; 0.50; 0.40; 0.35; 0.30; 0.27; 0.25; 0.22; 0.20; 0.18; 0.17; 0.16; 0.15; 0.14]; % km
%     coef_g = [20; -20; -10; -10; -10; -10; -40; -40; -40; -20; 20; -20; 20; -20; 20];
    wavelength_g = wavelength*[2.0; 1.00; 0.50; 0.40; 0.35; 0.30; 0.27; 0.25; 0.22; 0.20; 0.18; 0.17; 0.16; 0.15; 0.14]; % km
    coef_g = [20; -20; -10; -10; -10; -10; -40; -40; -40; -20; 20; -20; 20; -20; 20];
    nwave_g = length(wavelength_g);
    k_g = 2*pi./(wavelength_g.*1e3);


    sigma_g = zeros(nwave_g,1);
    for iwave = 1:nwave_g
        sigma_g(iwave) = dispersion_relation_airgravitywave(k_g(iwave),mu,N,cs,0.0);
    end
    c_g = sigma_g./k_g;
end


% fig = figure;
%% create pressure data
pres = zeros(nlat, nlon, nt);
for k = 1:nt
    fprintf('%03d,',k);

    %% Lamb wave
    dist_peak = cs*t(k)*1e-3; % km
    amp_peak = amp(dist_peak,coef_lamb_peak);
%     dist_trough = max(1,dist_peak-wavelength); % km
    dist_trough = max(1,dist_peak-0.4*wavelength); % km
    amp_trough = amp(dist_trough,coef_lamb_trough);

    dist_peak_add = max(1,dist_peak-0.7*wavelength_add); % km
    amp_peak_add = amp(dist_peak_add,coef_lamb_add);

    for i = 1:nlat
    for j = 1:nlon
        %% Lamb wave peak side
        dist_from_antinode = abs(kmmesh(i,j)-dist_peak); % km
        if dist_from_antinode > 0.5*wavelength
            pres_lamb = 0.0;
        else
            pres_lamb = pressure_anomaly_Lamb(amp_peak, wavelength, dist_from_antinode);
        end
        %% Lamb wave trough side
        dist_from_antinode = abs(kmmesh(i,j)-dist_trough); % km
        if dist_from_antinode <= 0.5*wavelength
            pres_lamb = pres_lamb + pressure_anomaly_Lamb(amp_trough, wavelength, dist_from_antinode);
        end

        %% Additional peak
        dist_from_antinode = abs(kmmesh(i,j)-dist_peak_add); % km
        if dist_from_antinode <= 0.5*wavelength_add
            pres_lamb = pres_lamb + pressure_anomaly_Lamb(amp_peak_add, wavelength_add, dist_from_antinode) -0.1;
        end
        
        %% Composite pressure data
        pres(i,j,k) = pres(i,j,k) + pres_lamb;
    end
    end
%     clf(fig); pcolor(lon,lat,pres(:,:,k)); shading flat; caxis([-1,1]); colorbar; drawnow; 
end
fprintf('\n');

if active_g == 1

    %% Gravity wave(s)
    for k = 1:nt
        fprintf('%03d,',k);
        dist_peak = c_g.*t(k)*1e-3; % km
        for i = 1:nlat
            for j = 1:nlon
                pres_grav = 0.0;
                for iwave = 1:nwave_g
                    pres_add = 0.0;
                    amp_peak = amp(dist_peak(iwave),coef_g(iwave));
                    %% peak side
                    dist_from_antinode = kmmesh(i,j)-dist_peak(iwave); % km
                    if abs(dist_from_antinode) <= 0.5*wavelength_g(iwave)
                        pres_add = pressure_anomaly_airgravitywave(amp_peak, wavelength_g(iwave), abs(dist_from_antinode));
                    end

                    %% trough side
                    dist_trough = max(1,dist_peak(iwave)-wavelength_g(iwave)); % km
                    amp_trough = -amp(dist_trough,coef_g(iwave));
                    dist_from_antinode = kmmesh(i,j)-dist_trough; % km
                    if abs(dist_from_antinode) <= 0.5*wavelength_g(iwave)
                        pres_add = pressure_anomaly_airgravitywave(amp_trough, wavelength_g(iwave), abs(dist_from_antinode));
                    end

                    pres_grav = pres_grav + pres_add;
                end
                pres(i,j,k) = pres(i,j,k) + pres_grav;
            end
        end
%         clf(fig); pcolor(lon,lat,pres(:,:,k)); shading flat; caxis([-1,1]); colorbar; drawnow;
    end
    fprintf('\n');

end

%% check time-series of the air pressure
figure
plot(t/3600,squeeze(pres(indchk_lat,indchk_lon,:)));
xlim([6.0,12.0]);
grid on


%% save
save(matname_pres,'-v7.3',...
     'lon0','lat0','lonrange','latrange','lon','lat',...
     'nlon','nlat','dl','pres',...
     'cs','wavelength','dt','t','nt','active_g')


%% formula - Lamb wave
function pres = pressure_anomaly_Lamb(amp_antinode, wavelength, distance_from_antinode)
    pres = amp_antinode*cos(pi/wavelength*distance_from_antinode);
%     pres = amp_antinode*(1-min(distance_from_antinode/wavelength,1));
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
   pres = amp_antinode*cos(pi/wavelength*distance_from_antinode);
%     pres = amp_antinode*(1-min(distance_from_antinode/wavelength,1));
end


