clear
close all

outputdir = './_output';
file_config = 'fgout_grids.data';

if ~isfile(fullfile(outputdir,file_config)); return; end

fgconfig = readmatrix(fullfile(outputdir,file_config),"FileType","text","CommentStyle",'#',"Delimiter",' ');
nfgout = fgconfig(1);

if ~isfolder('_mat'); mkdir('_mat'); end
if ~isfolder('_plots'); mkdir('_plots'); end

% for fgridnumber = 1:nfgout
% fg = 1;
for fg = 1:nfgout

    flist = dir(fullfile(outputdir,[sprintf('fgout%04d.q',fg),'*']));
    nfile = size(flist,1);
    fgmat = sprintf('fgout%02d.mat',fg);

    %% read header
    fname = fullfile(outputdir,flist(1).name);
    fid = fopen(fname,'r');
    header = textscan(fid,'%f %s\n',8);
    fclose(fid);
    nx = header{1}(3);
    ny = header{1}(4);
    x = linspace(header{1}(5), header{1}(5) + (nx-1)*header{1}(7), nx);
    y = linspace(header{1}(6), header{1}(6) + (ny-1)*header{1}(8), ny);

    % sparse matrix
    eta_sp = cell(nfile,1);

    t_elapsed = zeros(nfile,1);

    %% read all
    for k = 1:nfile
        % for k = 1:10
        fname = fullfile(outputdir,flist(k).name);
        disp([fname,'  ...']);

        dat = readmatrix(fname,"FileType","text","NumHeaderLines",9);
        dat_t = readmatrix(strrep(fname,'.q','.t'),"FileType","text");
        t_elapsed(k) = dat_t(1,1);

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

    %% save
    save(fgmat,'-v7.3','nx','ny','nfile','eta_sp','etamax','header','t_elapsed','x','y');
    movefile(fgmat,'_mat');

    %% plot and print
    clf;
    pcolor(x,y,etamax); shading flat;
    axis equal tight;
    clim([0.0,0.2])
    colorbar;
    exportgraphics(gcf,sprintf('./_plots/fgout%02d_max.png',fg),"ContentType","image","Resolution",300);

    clear x y header nx ny
end