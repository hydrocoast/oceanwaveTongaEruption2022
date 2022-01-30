if ~exist('_mat','dir'); disp('Directory _mat not found.'); exit; end

if ~exist('_mat/track.mat','file'); disp('_mat/track.mat not found.'); exit; end
load _mat/track.mat
%% list fgmax files
flist = dir('_mat/fgmax_*.mat');
nfile = size(flist,1);
if nfile == 0; disp('No file to plot'); exit; end

%% plot
if ~exist('_plots','dir'); mkdir('_plots'); end
for i = 1:nfile
    load(fullfile('_mat',flist(i).name));
    
    [X,Y] = meshgrid(linspace(xlims(1),xlims(2),double(nx)), linspace(ylims(1),ylims(2),double(ny)));
    eta(abs(eta)<1e-2) = NaN;
    
    clf;
    pcolor(X,Y,eta); axis equal tight; shading flat
    colormap(parula(10))
    caxis([0.0,0.5])
    cb = colorbar;
    hold on
    contour(X,Y,topo,[0,0],'k-')
    plot(track(:,1),track(:,2),'m-')
    hold off
    xlim(xlims)
    ylim(ylims)
    set(gca,'FontName','Helvetica','FontSize',12)
    set(cb,'FontName','Helvetica','FontSize',10)
    
    %% print as a png
    print(gcf,'-dpng','-r300',fullfile('_plots',strrep(flist(i).name,'.mat','_mat.png')))
end


