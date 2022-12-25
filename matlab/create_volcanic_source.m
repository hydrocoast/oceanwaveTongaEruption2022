clear
close all


%% origin
lat0 =  -20.544686;
lon0 = -175.393311 + 360.0;

%% lonlat
latrange = [-20.60,-20.50];
lonrange = [-175.45,-175.35] + 360.0;
dl = 1/720;
nlon = round(abs(diff(lonrange))/dl)+1;
nlat = round(abs(diff(latrange))/dl)+1;
lon = linspace(lonrange(1),lonrange(2),nlon);
lat = linspace(latrange(1),latrange(2),nlat);
[LON,LAT] = meshgrid(lon,lat);

degmesh = sqrt((LON-lon0).^2 + (LAT-lat0).^2);
kmmesh = deg2km(degmesh);


%% source parameters
R = 1960.79; % m 
eta0 =  480.945; % m

%% preallocate
eta_source = zeros(nlat,nlon);

%% calc
for i = 1:nlat
for j = 1:nlon
    eta_source(i,j) = initial_source_explosion(1e3*kmmesh(i,j),R,eta0);
end
end

%% approximate volume
dx = (1e4/90)*dl*cosd(-20); % km
vol = sum(eta_source(:))*1e-3*dx^2; % km^3
vol_abs = sum(abs(eta_source(:)))*1e-3*dx^2; % km^3

%% plot
% pcolor(LON,LAT,eta_source); shading flat
% axis equal tight
surf(LON,LAT,eta_source); shading flat
cb = colorbar;
caxis([-200,200])
axis tight


%% print
dtopofile = "./dtopo_test.asc";
% % topotype 3
fmt = [repmat('%14.6e ',[1,nlon]),'\n'];
fid = fopen(dtopofile,'w');
fprintf(fid,'%d     mx\n',nlon);
fprintf(fid,'%d     my\n',nlat);
fprintf(fid,'%d     mt\n',1);
fprintf(fid,'%e     xlower\n',lon(1));
fprintf(fid,'%e     ylower\n',lat(1));
fprintf(fid,'%f     t0\n',1.0);
fprintf(fid,'%14.8e     dx\n',dl);
fprintf(fid,'%14.8e     dy\n',dl);
fprintf(fid,'%f     dt\n',0.0);
fprintf(fid,fmt,flipud(eta_source)');
fclose(fid);


%% function
function eta = initial_source_explosion(r,R,eta0)
    ratio_r = r/R;
    if ratio_r < 0
        error('invalid r/R value.');
    end

    if ratio_r < 1
        eta = eta0*(2*ratio_r^2 -1);
    elseif ratio_r < 2
        eta = eta0*(2-ratio_r)^2;
    else
        eta = 0.0;
    end
    return
end