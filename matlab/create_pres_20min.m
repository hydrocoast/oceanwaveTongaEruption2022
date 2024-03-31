clear
close all

%% 気圧データの作成
% --- 様々な周期を持つ正弦波 --- %

%% filenames
matname_pres = 'pres_20min.mat';
  
%% origin 原点
lat0 =  26.42914;
lon0 = 139.30162;

%% lonlat
latrange = [25,35];
lonrange = [125,140];

dl = 0.20;
nlon = round(abs(diff(lonrange))/dl)+1;
nlat = round(abs(diff(latrange))/dl)+1;
lon = linspace(lonrange(1),lonrange(2),nlon);
lat = linspace(latrange(1),latrange(2),nlat);
[LON,LAT] = meshgrid(lon,lat);

degmesh = sqrt((LON-lon0).^2 + (LAT-lat0).^2);
kmmesh = deg2km(degmesh);

checkpoint = [135.0,32.5]; %気圧が出力される地点
[~,indchk_lon] = min(abs(checkpoint(1)-lon));
[~,indchk_lat] = min(abs(checkpoint(2)-lat));


%% parameters
dt = 60;
t = dt:dt:3600*15;
nt = length(t);

%% parameters below are based on Gusman et al.(2022), PAGEOPH
cs = 310.0; % m/s
amp = @(r,a) sign(a)*min(abs(a),abs(a*r^(-0.5))); % km

%% parameters for air gravity waves

g = 9.8; % m/s^2
N = 1.16e-2; % /s
mu = 0.5*(N^2/g + g/cs^2); % /m
sigma0 = mu*cs;

nrepeat = 10;
wavelength_g = 115; %波長(Km)
wavelength_g = repmat(wavelength_g,[nrepeat,1]); %同じ波長の繰り返し
coef_g = 20; %振幅(peak)

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
xlim([0.0,10.0]);
ylim([-1.2,2.0]);
xticks(0.0:1.0:10.0)
ylabel(ax,'Pressure anomaly (hPa)','FontName','Times','FontSize',18,HorizontalAlignment='center');
xlabel(ax,'Elapsed time (hour)','FontName','Times','FontSize',18,HorizontalAlignment='center');
set(ax,'FontName','Times','FontSize',18);
grid on
% exportgraphics(fig,'create_press_.png','ContentType','image','Resolution',300);

% %% save
% save(matname_pres,'-v7.3',...
%      'lon0','lat0','lonrange','latrange','lon','lat',...
%      'nlon','nlat','dl','pres',...
%      'cs','wavelength_g','dt','t','nt')


snap = round(linspace(1,round(0.4*nt),9));

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
%pres = amp_antinode*cos(pi/wavelength_g*distance_from_antinode*t_line);
%     pres = amp_antinode*(1-min(distance_from_antinode/wavelength,1));
end

% % 時間ベクトルの作成
% t = linspace(0, 8*pi, 1000);
% 
% % sin波の生成
% amplitude = 1;    % 振幅
% frequency = 1;    % 周波数
% sin_wave = amplitude * sin(frequency * t);
% 
% % プロット
% figure;
% plot(t, sin_wave, 'LineWidth', 1.5);
% grid on;
% xlabel('Time');
% ylabel('Amplitude');
% title('Repeating Sin Wave');
% 
% % 軸を拡張して繰り返しを表示
% axis([0 4*pi -1.5 1.5]);
% 

