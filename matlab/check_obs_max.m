clear
close all

%% obs data
load('JMA_records.mat');

nsta = size(table_JMA,1);

t_range = [0,16*3600];
t_zmax = zeros(nsta,1);
zmax = zeros(nsta,1);

for i = 1:nsta
% for i = 1:1
% for i = 28:28
    dat = cell2mat(table2array(table_JMA(i,["Time","Eta_filtered"])));
    if isempty(dat); continue; end

    [~,ind_s] = min(abs(t_range(1)-dat(:,1)));
    [~,ind_e] = min(abs(t_range(2)-dat(:,1)));
    t = dat(ind_s:ind_e,1);
    z = dat(ind_s:ind_e,2);

    [zmax(i), ind_zmax] = max(z);
    t_zmax(i) = t(ind_zmax);

    % plot(t,z);
    % hold on
    % plot(t_zmax(i),zmax(i),'ko','MarkerFaceColor','red');
    % grid on
    % box on
end

t_zmax_hhmm = seconds(t_zmax);
t_zmax_hhmm.Format = 'hh:mm';

% table_JMA = addvars(table_JMA,t_zmax,t_zmax_hhmm,zmax,'NewVariableNames',["Time_Etamax","Time_Etamax_HM","Etamax"]);
table_JMA = addvars(table_JMA,t_zmax_hhmm,'NewVariableNames',"Time_Etamax_HM");


save('JMA_records.mat','table_JMA');

