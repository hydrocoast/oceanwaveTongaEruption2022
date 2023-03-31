clear
close all

%% 大気重力波の分散関係の確認用

%% parameters
g = 9.8; % m/s^2
cs = 360.0; % m/s
N = 1.16e-2; % /s
mu = 0.5*(N^2/g + g/cs^2); % /m ?
sigma0 = mu*cs;

Hs = 8.4e3;% R*Tc/g;

%% parameters
n = [0,0.4/Hs,0.8/Hs];
num_n = length(n);

nHs = n*Hs;

L = [20e3:10e3:5000e3]';
k = 2*pi./L;
num_k = length(L);

sigma_g = zeros(num_k,num_n);
sigma_a = zeros(num_k,num_n);
for i = 1:num_k
for j = 1:num_n
    sigma_g(i,j) = dispersion_relation_airgravitywave(k(i),mu,N,cs,n(j));
    sigma_a(i,j) = dispersion_relation_acousticwave(k(i),mu,N,cs,n(j));
end
end
cg = sigma_g./k;

line_c = colormap(lines(3)); close

%% plot dispersion relation
figure
ax = axes;
set(ax,'FontName','Helvetica','FontSize',16);


hold on

% ag = area(k*Hs, sigma_g(:,1)/N,'FaceColor',[0.9,0.9,0.9],'EdgeColor','none');
% aa = area(k*Hs, sigma_a(:,1)/N,'FaceColor',[0.9,0.9,0.9],'EdgeColor','none','BaseValue',10);
% ag = area(repmat(k*Hs,[2,1]), vertcat(sigma_a(:,1)/N,sigma_g(:,1)/N),'EdgeColor','none','BaseValue',10);

ag = patch(vertcat(k*Hs,0,k(1)*Hs), vertcat(sigma_g(:,1)/N,0,0),[0.90,0.90,0.90],'EdgeColor','none');
aa = patch(vertcat(k*Hs,0,k(1)*Hs), vertcat(sigma_a(:,1)/N,10,10),[0.90,0.90,0.90],'EdgeColor','none');
text(1.75,0.25,'Gravity wave','FontSize',20,'FontName','Helvetica','HorizontalAlignment','right','VerticalAlignment','bottom');
text(0.05,3.0,'Acoustic wave','FontSize',20,'FontName','Helvetica','HorizontalAlignment','left','VerticalAlignment','middle');

yline(1,'k--','LineWidth',1);
% yline(sigma0/N,'k--','LineWidth',1);
for j = 1:num_n
    lg(j) = plot(k*Hs, sigma_g(:,j)/N, '-','LineWidth',1,'Color',line_c(j,:));
    la(j) = plot(k*Hs, sigma_a(:,j)/N, '-','LineWidth',1,'Color',line_c(j,:));
end
plot(k*Hs,k*cs/N,'k-','LineWidth',1);
grid on
axis tight
box on
xlabel('$$ k H_s$$','FontName','Helvatica','FontSize',20,'Interpreter','latex');
ylabel('$$ \sigma/N $$','FontName','Helvatica','FontSize',20,'Interpreter','latex');
xlim(ax,[0,2])
ylim(ax,[0,3.5])

le = legend(la,{sprintf('$$nH_s$$ = %0.1f',nHs(1)),...
                sprintf('$$nH_s$$ = %0.1f',nHs(2)),...
                sprintf('$$nH_s$$ = %0.1f',nHs(3))},...
                'Location','northeast','FontSize',20,'Interpreter','latex');

ax.XAxis.TickLabelFormat = '%0.1f';
ax.YAxis.TickLabelFormat = '%0.1f';

annotation('textarrow',[0.4,0.35],[0.50,0.55],'String','Lamb wave','FontName','Helvetica','FontSize',20)

exportgraphics(ax,'dispersion_relation.pdf','ContentType','vector');

% %% plot phase speed
% figure
% ax = axes;
% set(ax,'FontName','Helvetica','FontSize',16);
% plot(1e-3*L,cg);
% grid on
% box on
% xlabel('Wavelength (km)','FontName','Helvatica','FontSize',20);
% ylabel('wave speed (m/s)','FontName','Helvatica','FontSize',20);
% xlim([0,700])

%% formula
function sigma_g = dispersion_relation_airgravitywave(k,mu,N,cs,n)
    sigma_g = sqrt( ...
                    0.5*cs^2*(k^2+n^2+mu^2)* ...
                    (1-sqrt(1-(4*k^2*N^2/(cs^2*(k^2+n^2+mu^2)^2)))) ...
                   );
end
function sigma_a = dispersion_relation_acousticwave(k,mu,N,cs,n)
    sigma_a = sqrt( ...
                    0.5*cs^2*(k^2+n^2+mu^2)* ...
                    (1+sqrt(1-(4*k^2*N^2/(cs^2*(k^2+n^2+mu^2)^2)))) ...
                   );
end



