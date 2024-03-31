clear
close all

%!wget https://www.ngdc.noaa.gov/hazard/data/DART/20220115_tonga/dart52405_20220114to20220119_meter_resid.txt


fname = 'dart52405_20220114to20220119_meter_resid.txt';

dat = readmatrix(fname);


time_org = datetime(dat(:,2:7));
z_org = dat(:,10);
ind = z_org==9999;
time_org(ind) = [];
z_org(ind) = [];


time = (time_org(1):minutes(1):time_org(end))';

z_interp = interp1(time_org,z_org,time);


z_filtered = highpass(z_interp,1/60);


plot(time_org,z_org); hold on
plot(time,z_interp); hold on
plot(time,z_filtered); hold on

time_relative = seconds(time - datetime(2022,01,15,4,14,45));


load DART_records.mat


