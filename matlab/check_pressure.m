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



