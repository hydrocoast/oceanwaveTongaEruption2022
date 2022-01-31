clear
close all

%% filename
matfile = 'pres_10h_dt10min_speed300.mat';
load(matfile)

ts = seconds(t);
th = hour(ts);
tm = minutes(ts-hours(th));

fc = '1d.con';
fp = 'slp_d01.swt';
fu = 'u10_d01.swt';
fv = 'v10_d01.swt';
strtime_base='           000001HHMM\n';
p_amb = 1013.0;
p_out = pres + p_amb;


%% print
% -- header
fid_c = fopen(fc,'w');
fprintf(fid_c,'%d %d\n',[nlon,nlat]);
fprintf(fid_c,'%0.2f %0.2f %0.2f\n',[lonrange(1),latrange(1),dl]);
fprintf(fid_c,'%0.2f %0.2f %0.2f\n',[lonrange(2),latrange(2),dl]);
fclose(fid_c);

% -- puv
fmt_p = [repmat('%7.1f ',[1,nlon-1]),'%7.1f\n'];
fmt_uv = [repmat('%4.1f ',[1,nlon-1]),'%4.1f\n'];
fid_p = fopen(fp,'w');
fid_u = fopen(fu,'w');
fid_v = fopen(fv,'w');

% -- initial time
strtime='           0000010000\n';
fprintf(fid_p,strtime);
fprintf(fid_p,fmt_p,p_amb*ones(nlat,nlon)');
fprintf(fid_u,strtime);
fprintf(fid_u,fmt_uv,zeros(nlat,nlon)');
fprintf(fid_v,strtime);
fprintf(fid_v,fmt_uv,zeros(nlat,nlon)');

for k = 1:nt
    %% time header
    strtime = strrep(strtime_base,'HH',sprintf('%02d',th(k)));
    strtime = strrep(strtime,'MM',sprintf('%02d',tm(k)));

    %% print
    fprintf(fid_p,strtime);
    fprintf(fid_p,fmt_p,squeeze(flipud(p_out(:,:,k)))');    
    fprintf(fid_u,strtime);
    fprintf(fid_u,fmt_uv,zeros(nlat,nlon)');
    fprintf(fid_v,strtime);
    fprintf(fid_v,fmt_uv,zeros(nlat,nlon)');
end

fclose(fid_p);
fclose(fid_u);
fclose(fid_v);
