clear
close all

%% filename
matfile = 'pres_10h_dt30min_speed300.mat';
load(matfile)

%% plot
sizen= 512;
delaytime = 0.5;
savegif = 'test.gif';

fig = figure;
for k = 1:nt-3
    clf(fig);    
    ax = gca;
    ax.FontName = 'Helvetica';
    
    imagesc(lon,lat,pres(:,:,k)); ax.YDir = 'normal';
    axis equal tight
    hold on
    plot(lon0,lat0,'kp','MarkerFaceColor','y','MarkerSize',14)
    hold off
    cb = colorbar('FontName','Helvetica');
    caxis([0,2]);
    title(sprintf('%d min',t(k)/60),'FontName','Helvetica')
    
    xlabel('Longitude (\circE)','FontName','Helvetica')
    ylabel('Latitude (\circN)','FontName','Helvetica')
    
    
    % Capture the plot as an image
    frame = getframe(fig);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,sizen);
    % Write to the GIF File
    if k == 1
        imwrite(imind,cm,savegif,'gif', 'Loopcount',inf,'DelayTime',delaytime);
    else
        imwrite(imind,cm,savegif,'gif','WriteMode','append','DelayTime',delaytime);
    end    
    
end


% fig = figure;
% for k = 1:nt-3
%     clf(fig);
%     
%     gx = geoaxes;
%     geobasemap(gx,'colorterrain')
%     geolimits(gx,latrange,lonrange)
%     
%     ax = axes;
%     p = pcolor(lon,lat,pres(:,:,k)); shading flat
%     p.FaceAlpha = 0.3;
%     colormap(flipud(hot));
%     axis tight
%     hold on
%     plot(lon0,lat0,'kp','MarkerFaceColor','y','MarkerSize',14)
%     hold off
%     caxis([0,2]);
%     title(sprintf('%d min',t(k)/60),'FontName','Helvetica')    
%     ax.Visible = 'off';
%     ax.XTick = [];
%     ax.YTick = [];    
%     ax.Position = gx.Position;    
%     print(gcf,'-djpeg',sprintf('step%03d.jpg',k));    
% end
% 
% !ffmpeg -i step%03d.jpg -vf palettegen palette.png
% !ffmpeg -r 2 -i step%03d.jpg -i palette.png -filter_complex paletteuse pres.gif
