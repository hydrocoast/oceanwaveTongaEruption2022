clear
close all

%% parameters
g = 9.8; % m/s^2
cs = 310.0; % m/s
% N = 1.16e-2; % /s
N = 1.7e-2; % /s
mu = 0.5*(N^2/g + g/cs^2); % /m ?
sigma0 = mu*cs;

%% parameters
n = [0,5e-5,10e-5];
num_n = length(n);

L = [20e3:10e3:1000e3]';
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


%% plot dispersion relation
figure
ax = axes;
set(ax,'FontName','Helvetica','FontSize',12);

hold on
yline(N,'k--');
yline(sigma0,'k--');
plot(k,sigma_g,'-');
plot(k,sigma_a,'-');
plot(k,k*cs,'k-');
grid on
axis tight
box on
xlabel('$$ k ~ (\mathrm{m^{-1}})$$','FontName','Helvatica','FontSize',14,'Interpreter','latex');
ylabel('$$ \sigma ~ (\mathrm{s^{-1}}$$)','FontName','Helvatica','FontSize',14,'Interpreter','latex');


%% plot phase speed
figure
ax = axes;
set(ax,'FontName','Helvetica','FontSize',12);
plot(1e-3*L,cg);
grid on
box on
xlabel('Wavelength (km)','FontName','Helvatica','FontSize',14);
ylabel('wave speed (m/s)','FontName','Helvatica','FontSize',14);


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



