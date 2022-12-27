clear
close all

%% 生成した気圧データの可視化・確認

%% filename
matfile = 'pres_l_fluc.mat';
load(matfile)

cmap = colormap(jet(100));
close
cmap(50:51,:) = repmat([1,1,1],[2,1]);

if ~isfolder("fig_pred2d"); mkdir("fig_pres2d"); end

fig = figure;
% for k = 1:nt
for k = 1:10:nt
    clf(fig);
    
    gx = geoaxes;
    geobasemap(gx,'colorterrain')
    geolimits(gx,latrange,lonrange)
    
    ax = axes;
    p = pcolor(lon,lat,pres(:,:,k)); shading flat
    p.FaceAlpha = 0.3;
    cb = colorbar;
%     colormap(flipud(hot));
%     cb.Ticks = 0.0:0.5:4.0;
%     caxis([0,4]);
    colormap(cmap);
    cb.Ticks = -2.0:0.5:2.0;
    caxis([-2,2]);

    cb.TickLabels = num2str(cb.Ticks','%0.1f');
    cb.Position(1) = 0.90;
    title(cb,'hPa')
    axis tight
    hold on
    plot(lon0,lat0,'kp','MarkerFaceColor','y','MarkerSize',14)
    hold off
    text(200, 45, sprintf('%03d min',t(k)/60),'FontName','Helvetica','FontSize',16,'HorizontalAlignment','center')
    ax.Visible = 'off';
    ax.XTick = [];
    ax.YTick = [];
    ax.Position = gx.Position;
    print(gcf,'-djpeg',sprintf('fig_pres2d/step%03d.jpg',k));
end


%% animation
% ! ffmpeg -i step%03d.jpg -vf palettegen palette.png -y
% ! ffmpeg -r 12 -i step%03d.jpg -i palette.png -filter_complex paletteuse pres.gif -y

%% animation (mac)
% ! /usr/local/bin/ffmpeg -i step%03d.jpg -vf palettegen palette.png -y
% ! /usr/local/bin/ffmpeg -r 12 -i step%03d.jpg -i palette.png -filter_complex paletteuse pres.gif -y


% %% gif
% sizen= 512;
% delaytime = 0.25;
% savegif = 'test.gif';
% 
% fig = figure;
% for k = 1:nt
%     clf(fig);    
%     ax = gca;
%     ax.FontName = 'Helvetica';
%     
%     imagesc(lon,lat,pres(:,:,k)); ax.YDir = 'normal';
%     axis equal tight
%     hold on
%     plot(lon0,lat0,'kp','MarkerFaceColor','y','MarkerSize',14)
%     hold off
%     cb = colorbar('FontName','Helvetica');
%     caxis([0,2]);
%     title(sprintf('%d min',t(k)/60),'FontName','Helvetica')
%     
%     xlabel('Longitude (\circE)','FontName','Helvetica')
%     ylabel('Latitude (\circN)','FontName','Helvetica')
%     
%     
%     % Capture the plot as an image
%     frame = getframe(fig);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,sizen);
%     % Write to the GIF File
%     if k == 1
%         imwrite(imind,cm,savegif,'gif', 'Loopcount',inf,'DelayTime',delaytime);
%     else
%         imwrite(imind,cm,savegif,'gif','WriteMode','append','DelayTime',delaytime);
%     end    
%     
% end
