clear
close all

%% fgout
matdir = '../run_presA_Amami_Kikai/_mat';
matname = 'fgout02.mat';
load(fullfile(matdir,matname));
[~,runname] = fileparts(strrep(matdir,'/_mat',''));
if ~exist(runname,'dir'); mkdir(runname); end

%% topofile
topodir = '../bathtopo';
topofile = 'zone01_depth_0090_blend34.asc';
topodata = Topo(fullfile(topodir,topofile));

cmap = createcolormap(20,[0,0,.5;1,1,1;.5,0,0]);

fig = figure;
print(fig,'-dpng','tmp.png'); ! rm -f tmp.png;

for k = 1:nfile
% for k = 1:1
    clf(fig); ax = axes;

    eta = reshape(eta_sp(:,k),[nx,ny])';
    pcolor(x,y,eta); shading flat; hold on
    colormap(ax,cmap)
    [~,L] = topodata.coastline;
    set(L,'EdgeColor','k','LineWidth',1);
%     [C,h] = contour(x,y,eta,-2.0:0.2:2.0);
    axis equal tight
    clim(ax,[-0.5,0.5]);
    cb = colorbar;

    title(cb,'m','FontName','Helvetica','FontSize',14)
    set(ax,'FontName','Helvetica','FontSize',16)
    xlabel(ax,'Longitude \circE','FontName','Helvetica','FontSize',16);
    ylabel(ax,'Latitude \circN','FontName','Helvetica','FontSize',16);

    cb.Ticks = -0.5:0.1:0.5;
    cb.TickLabels = num2str(cb.Ticks','%0.1f');

    ax.XAxis.TickLabelFormat = '%0.1f';
    ax.YAxis.TickLabelFormat = '%0.1f';

    
    tx = text(ax,...
          0.95*diff(ax.XLim)+ax.XLim(1),...
          0.95*diff(ax.YLim)+ax.YLim(1),...
          sprintf('%03d min',round(t_elapsed(k)/60)),...
          'FontName','Helvetica','FontSize',18,...
          'HorizontalAlignment','right','VerticalAlignment','top');

    pngname = sprintf('fgout_%03d.png',k);
    exportgraphics(ax,pngname,'ContentType','image','Resolution',150);
    movefile(pngname,runname);

end
