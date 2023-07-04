clear
close all

%% filenames
dir1 = '../../../AMR/oceanwaveTongaEruption2022/run_presA_L6_Muroto_v571/_mat';
matname1 = 'run_presA_L6_Muroto_v571_fixedgrid1.mat';
dir2 = '../../../AMR/oceanwaveTongaEruption2022/run_presA_L5_Muroto/_mat';
matname2 = 'run_presA_L5_Muroto_fixedgrid1.mat';
grdname_out = 'diff_L5L6_Muroto_v571.grd';

%% load
load(fullfile(dir1,matname1));
etamax1 = etamax;
load(fullfile(dir2,matname2));
etamax2 = etamax;
clear etamax

%% diff
diff_etamax = etamax1-etamax2;
pcolor(x,y,etamax1-etamax2); shading flat; axis equal tight;
colorbar;
caxis([0.0,0.1]);

%% print
grdwrite2(x,y,diff_etamax,grdname_out);

