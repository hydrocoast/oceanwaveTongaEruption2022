clear
close all

fgridnumber = 2;
% simdir = '/home/miyashita/h100_home/miyashita/Research/AMR/oceanwaveTongaEruption2022/run_presA_L3_v590/_output';
simdir = '/home/miyashita/h100_home/miyashita/Research/AMR/oceanwaveTongaEruption2022/run_presC_L3_v590/_output';

flist = dir(fullfile(simdir,[sprintf('fgout%04d.q',fgridnumber),'*']));
nfile = size(flist,1);

simname = fileparts(simdir);
simname = strrep(simname,'/_output','');
lastind_slash = strfind(simname,'/');
lastind_slash = lastind_slash(end);
simname = simname(lastind_slash+1:end);
fgmat = [simname,sprintf('_fg%d.mat',fgridnumber)];


%% read header
fname = fullfile(simdir,flist(1).name);
fid = fopen(fname,'r');
header = textscan(fid,'%f %s\n',8);
fclose(fid);
nx = header{1}(3);
ny = header{1}(4);

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

    % full matrix
    % v1 = reshape(dat(:,1),[nx,ny])';
    % v4 = reshape(dat(:,4),[nx,ny])';
    % land = v1==0;
    % eta = v4;
    % eta(land) = NaN;
    % eta_fg(:,:,k) = eta;

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

save(fgmat,'-v7.3','nx','ny','nfile','eta_sp','etamax','header');
