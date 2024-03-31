clear
close all

%% 気圧データの作成
% --- 様々な周期を持つ正弦波 --- %

%% filenames
matname_pres_base = 'pres_TXXXmin.mat';
  
%% origin 原点
lat0 =  -20.544686;
lon0 = -175.393311 + 360.0;

%% lonlat
latrange = [-60,60];
lonrange = [110,200.2];
% dl = 0.20;
dl = 1.0;
nlon = round(abs(diff(lonrange))/dl)+1;
nlat = round(abs(diff(latrange))/dl)+1;
lon = linspace(lonrange(1),lonrange(2),nlon);
lat = linspace(latrange(1),latrange(2),nlat);
[LON,LAT] = meshgrid(lon,lat);

degmesh = sqrt((LON-lon0).^2 + (LAT-lat0).^2);
kmmesh = deg2km(degmesh);

checkpoint = [129.5,28.3];
[~,indchk_lon] = min(abs(checkpoint(1)-lon));
[~,indchk_lat] = min(abs(checkpoint(2)-lat));


%% parameters
dt = 120;
t = dt:dt:3600*18;
nt = length(t);

%% parameters below are based on Gusman et al.(2022), PAGEOPH
cs = 310.0; % m/s
amp = @(r,a) sign(a)*min(abs(a),abs(a*r^(-0.5))); % km

%% parameters for air gravity waves

g = 9.8; % m/s^2
N = 1.16e-2; % /s
mu = 0.5*(N^2/g + g/cs^2); % /m
sigma0 = mu*cs;

nrepeat = 3;
wavelength_g = 267.44; % 波長(km) T=45 min, c=198.10 m/s
% wavelength_g = 236.95; % 波長(km) T=40 min, c=197.45 m/s
% wavelength_g = 206.3; % 波長(km) T=35 min, c=196.47 m/s
% wavelength_g = 175.45; % 波長(km) T=30 min, c=194.9 m/s
% wavelength_g = 144.2; % 波長(km) T=25 min, c=192.3 m/s
% wavelength_g = 112.2; % 波長(km) T=20 min, c=187.1 m/s
% wavelength_g = 78.3; % 波長(km) T=15 min, c=173.9 m/s
% wavelength_g = 54.5; % 波長(km) T=12 min, c=151.3 m/s
% wavelength_g = 31.9; % 波長(km) T=10 min, c=106.3 m/s
wavelength_g = repmat(wavelength_g,[nrepeat,1]); %同じ波長の繰り返し
coef_g = 45; %振幅(peak)

nwave_g = length(wavelength_g);
k_g = pi./(wavelength_g.*1e3);

  
sigma_g = zeros(nwave_g,1);
for iwave = 1:nwave_g
    sigma_g(iwave) = dispersion_relation_airgravitywave(k_g(iwave),mu,N,cs,0.0);
    c_g = sigma_g./k_g;
    T_g = 2*pi./sigma_g/60; %min
end
       

%% create pressure data
pres = zeros(nlat, nlon, nt);

fprintf('\n');
%t_line = linspace(0, 2*pi,dt);
    %% Gravity wave(s)
    for k = 1:nt
        if mod(k,20)==0; fprintf('%03d,',k); end
        
        for i = 1:nlat
            for j = 1:nlon
                pres_grav = 0.0;
                for iwave = 1:nwave_g
                    dist_peak = c_g(iwave)*t(k)*1e-3 - 2*(iwave-1)*wavelength_g(iwave); % km
                    pres_add = 0.0;
                    amp_peak = amp(dist_peak,coef_g);
                    %% peak side
                    dist_from_antinode = kmmesh(i,j)-dist_peak; % km
%                     if abs(dist_from_antinode) <= 0.5*wavelength_g(iwave)
                    if abs(dist_from_antinode) <= wavelength_g(iwave)
                        pres_add = pressure_anomaly_airgravitywave(-sign(dist_from_antinode)*amp_peak, wavelength_g(iwave), abs(dist_from_antinode));
                    end

                    pres_grav = pres_grav + pres_add;
                end
                pres(i,j,k) = pres(i,j,k) + pres_grav ;
                %pres(i,j,k+1) = pres(i,j,k) + pres_grav;
            end
        end
%         clf(fig); pcolor(lon,lat,pres(:,:,k)); shading flat; caxis([-1,1]); colorbar; drawnow;
    end
    fprintf('\n');

%% check time-series of the air pressure


fig = figure;
p = fig.Position;
fig.Position = [0.5*p(1), 0.5*p(2), 1.2*p(3), 0.75*p(4)];
ax = nexttile;
plot(t/3600,squeeze(pres(indchk_lat,indchk_lon,:)),'Color','b','LineWidth',2.0);
xlim([0.0,t(end)/3600]);
ylim([-1.2,2.0]);
% xticks(0.0:1.0:10.0)
ylabel(ax,'Pressure anomaly (hPa)','FontName','Times','FontSize',18,HorizontalAlignment='center');
xlabel(ax,'Elapsed time (hour)','FontName','Times','FontSize',18,HorizontalAlignment='center');
set(ax,'FontName','Times','FontSize',18);
grid on
% exportgraphics(fig,'create_press_.png','ContentType','image','Resolution',300);

%% save
matname_pres = strrep(matname_pres_base,'XXX',sprintf('%03d',round(T_g(1))));
save(matname_pres,'-v7.3',...
     'lon0','lat0','lonrange','latrange','lon','lat',...
     'nlon','nlat','dl','pres',...
     'cs','wavelength_g','dt','t','nt')


snap = round(linspace(1,round(0.8*nt),9));

fig = figure;
p = fig.Position;
fig.Position = [p(1)-0.25*p(3),p(2)-0.25*p(4),1.5*p(3),1.2*p(4)];
tile = tiledlayout(3,3);
i = 0;
for k = snap
    i = i + 1;
    ax(i) = nexttile;
    pcolor(lon,lat,pres(:,:,k)); shading flat
    axis equal tight
    text(ax(i),lon(1),lat(end),sprintf('%d min',round(t(k)/60)),'FontSize',14,'VerticalAlignment','top','HorizontalAlignment','left');
    caxis(ax(i),[-0.25,0.25]);
    if i<7
        ax(i).XAxis.TickLabels = '';
    end
    if ~(mod(i,3)==1)
        ax(i).YAxis.TickLabels = '';
    end
end
tile.TileSpacing = 'tight';
tile.Padding = 'compact';


%% formula - dispersion relation of gravity waves
function sigma_g = dispersion_relation_airgravitywave(k,mu,N,cs,n)
    sigma_g = sqrt( ...
                    0.5*cs^2*(k^2+n^2+mu^2)* ...
                    (1-sqrt(1-(4*k^2*N^2/(cs^2*(k^2+n^2+mu^2)^2)))) ...
                   );
end


%% formula - air gravity wave
function pres = pressure_anomaly_airgravitywave(amp_antinode, wavelength_g, distance_from_antinode)
    pres = amp_antinode*cos((pi/wavelength_g*distance_from_antinode+pi/2));
end
