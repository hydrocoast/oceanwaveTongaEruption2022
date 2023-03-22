clear
close all

fgridnumber = 1;
simdir = '../run_presA_L3_v590/_output';

flist = dir(fullfile(simdir,[sprintf('fgout%04d.q',fgridnumber),'*']));
nfile = size(flist,1);

simname = fileparts(simdir);
simname = simname(strfind(simname,'/')+1:end);
fgmat = [simname,sprintf('_fg%d.mat',fgridnumber)];


%% read header
fname = fullfile(simdir,flist(1).name);
fid = fopen(fname,'r');
header = textscan(fid,'%f %s\n',8);
fclose(fid);
nx = header{1}(3);
ny = header{1}(4);

eta_fg = zeros(ny,nx,nfile);

%% read all
for k = 1:nfile
    fname = fullfile(simdir,flist(k).name);
    disp([fname,'  ...']);

    dat = readmatrix(fname,"FileType","text","NumHeaderLines",9);

    v1 = reshape(dat(:,1),[nx,ny])';
    % v2 = reshape(dat(:,2),[nx,ny])';
    % v3 = reshape(dat(:,3),[nx,ny])';
    v4 = reshape(dat(:,4),[nx,ny])';
    land = v1==0;
    eta = v4;
    eta(land) = NaN;

    eta_fg(:,:,k) = eta;
    clear eta v1 v4 dat
end

save(fgmat,'-v7.3','ny','ny','nfile','eta_fg','header');


% bwr = createcolormap([0,0,0.5;1,1,1;0.5,0,0]);
% pcolor(eta); axis equal tight; shading flat
% colormap(bwr)
% clim([-0.1,0.1])

% figure
% tile = tiledlayout(2,2);
% 
% ax = nexttile;
% pcolor(v1); axis equal tight; shading flat
% axis off
% ax = nexttile;
% pcolor(v2); axis equal tight; shading flat
% axis off
% ax = nexttile;
% pcolor(v3); axis equal tight; shading flat
% axis off
% ax = nexttile;
% pcolor(v4); axis equal tight; shading flat
% axis off
% 
% 
