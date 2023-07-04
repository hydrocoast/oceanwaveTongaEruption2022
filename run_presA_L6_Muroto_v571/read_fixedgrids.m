clear
close all

fg_number = 1;
simdir = './_output';

flist = dir(fullfile(simdir,[sprintf('fort.fg%02d_',fg_number),'*']));
nfile = size(flist,1);

simname = fileparts(simdir);
simname = strrep(simname,'/_output','');
lastind_slash = strfind(simname,'/');
lastind_slash = lastind_slash(end);
simname = simname(lastind_slash+1:end);
fgmat = [simname,sprintf('_fixedgrid%d.mat',fg_number)];


%% read header
fname = fullfile(simdir,flist(1).name);
fid = fopen(fname,'r');
header = textscan(fid,'%f %s\n',8);
fclose(fid);
nx = header{1}(2);
ny = header{1}(3);
xl = header{1}(4);
yl = header{1}(5);
xh = header{1}(6);
yh = header{1}(7);
x = linspace(xl,xh,nx);
y = linspace(yl,yh,ny);

% full matrix
% eta_fg = zeros(ny,nx,nfile);

% sparse matrix
eta_sp = cell(nfile,1);

%% read all
for k = 1:nfile
% for k = 1:10
    fname = fullfile(simdir,flist(k).name);
    disp([fname,'  ...']);

    dat = readmatrix(fname,"FileType","text","NumHeaderLines",9);

%     % full matrix
%     v1 = reshape(dat(:,1),[nx,ny])';
%     v4 = reshape(dat(:,4),[nx,ny])';
%     land = v1==0;
%     eta = v4;
%     eta(land) = NaN;
%     eta_fg(:,:,k) = eta;

    % sparse matrix
    v1 = dat(:,1);
    v4 = dat(:,4);
    land = v1==0;
    eta = v4;
    eta(land) = 0.0;
    ind = find(abs(eta)>1e-2);
    eta_sp{k} = sparse(ind,ones(length(ind),1),eta(ind),ny*nx,1);

    clear eta v1 v4 dat
end

eta_sp = cat(2,eta_sp{:});
etamax = reshape(max(eta_sp,[],2),[nx,ny])';

pcolor(x,y,etamax); shading flat; axis equal tight
caxis([0,0.4]);
colorbar;

figfile = [simname,sprintf('_fixedgrid%d_max.png',fg_number)];
exportgraphics(gcf,figfile,"ContentType","image","Resolution",300);
if isfolder("_plots")
    movefile(figfile,"_plots/");
end

save(fgmat,'-v7.3','nx','ny','nfile','eta_sp','etamax','header');
if isfolder("_mat")
    movefile(fgmat,"_mat/");
end
