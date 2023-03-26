clear
close all

%% filename
matname = 'run_presA_L3_v590_fg2.mat';
load(matname);

[nx,ny,nt] = size(eta_fg);
%% 
etamax = max(eta_fg,[],3,'omitnan');

pcolor(etamax); shading flat;
axis equal tight
colormap(turbo(10));
clim([0,0.2]);
colorbar

