clear
close all

fg_number = 1;
simdir = './_output';

flist = dir(fullfile(simdir,[sprintf('fort.fg%02d_',fg_number),'*']));
nfile = size(flist,1);

%simname = fileparts(simdir);
simname = pwd;
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

%% read
for k = nfile:nfile
    fname = fullfile(simdir,flist(k).name);
    disp([fname,'  ...']);

    dat = readmatrix(fname,"FileType","text","NumHeaderLines",9);
    v8 = reshape(dat(:,8),[nx,ny])';
end
etamax = v8;

pcolor(x,y,etamax); shading flat; axis equal tight
caxis([0,0.4]);
colorbar;

figfile = [simname,sprintf('_fixedgrid%d_max.png',fg_number)];
exportgraphics(gcf,figfile,"ContentType","image","Resolution",300);
if isfolder("_plots")
    movefile(figfile,"_plots/");
end

save(fgmat,'-v7.3','nx','ny','nfile','etamax','header','x','y');
grdwrite2(x,y,etamax,strrep(fgmat,'.mat','.grd'))
if isfolder("_mat")
    movefile(fgmat,"_mat/");
    movefile(strrep(fgmat,'.mat','.grd'),"_mat/");
end

