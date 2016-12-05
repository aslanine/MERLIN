%% Plot TAS / IPB particle distribution after tracking in MERLIN
% 
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/29_Oct_Inelastic/Bunch_Distn/IPB_bunch.txt';
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/29_Oct_Inelastic/Bunch_Distn/TAS_bunch.txt';
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/7_Nov_inelastic_nearest_forcedloss/Bunch_Distn/TAS_bunch.txt';

formatSpec = '%*70s%35f%35f%35f%35f%35f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

x = dataArray{:, 1};
xp = dataArray{:, 2};
y = dataArray{:, 3};
yp = dataArray{:, 4};
ct = dataArray{:, 5};
dp = dataArray{:, 6};
E = (50E3*(1+dp)); % Energy in GeV

clearvars filename formatSpec fileID dataArray ans;

%% Size and means etc
sz = size(x);

mx = mean(x);
rmx = sqrt(mean(x.^2));

my = mean(y);
rmy = sqrt(mean(y.^2));

me = mean(E);
rme = sqrt(mean(E.^2));

%% Plot XY scatter

figure;

scatter(x,y,2);
grid on;
xlabel('x [m]','FontSize',20);
ylabel('y [m]','FontSize',20);

% t=({['IPB xy'];['Entries ' num2str(sz(1)) ', Mean_x' num2str(mx) ', RMS_x ' num2str(rmx) ];['Mean_y' num2str(my) ', RMS_y ' num2str(rmy) ]});
t=({['TAS xy'];['Entries ' num2str(sz(1)) ', Mean_x' num2str(mx) ', RMS_x ' num2str(rmx) ];['Mean_y' num2str(my) ', RMS_y ' num2str(rmy) ]});
% h = title(t);

title (t,'FontSize',20);
% title (['IPB xy. Entries ' num2str(sz(1)) ', Mean_x' num2str(mx) ', RMS_x ' num2str(rmx) ],'FontSize',10);

% set(gca,'FontSize',20,'XLim',[-0.005 0.005],'YLim',[-0.005 0.005]);
set(gca,'FontSize',20,'XLim',[-0.04 0.04],'YLim',[-0.04 0.04]);

%% Plot x histogram

figure;
% set(gcf,'color','w');
bins = 150;

    [Ns,Xs] = hist(x, bins);
    stairs(Xs,Ns,'color','k','Linewidth',2); hold on;
    
    grid on;
        
    title (['TAS x. Entries ' num2str(sz(1)) ', Mean ' num2str(mx) ', RMS ' num2str(rmx) ],'FontSize',20);    
%     title (['IPB x. Entries ' num2str(sz(1)) ', Mean ' num2str(mx) ', RMS ' num2str(rmx) ],'FontSize',20);
    
    ylabel('Frequency [-]','FontSize',20);
    xlabel('x [m]','FontSize',20);
    
     set(gca,'FontSize',20,'XLim',[-0.02 0.02]);     
%      set(gca,'FontSize',20,'XLim',[-0.005 0.005],'YScale','log');
    hold off;
        
%% Plot y histogram

figure;
% set(gcf,'color','w');
bins = 200;

    [Ns,Xs] = hist(y, bins);
    stairs(Xs,Ns,'color','k','Linewidth',2); hold on;
    
    grid on;
        
    title (['TAS y. Entries ' num2str(sz(1)) ', Mean ' num2str(my) ', RMS ' num2str(rmy) ],'FontSize',20);
%     title (['IPB y. Entries ' num2str(sz(1)) ', Mean ' num2str(my) ', RMS ' num2str(rmy) ],'FontSize',20);
    
    ylabel('Frequency [-]','FontSize',20);
    xlabel('y [m]','FontSize',20);
    
    set(gca,'FontSize',20,'XLim',[-0.02 0.02]);
%     set(gca,'FontSize',20,'XLim',[-0.005 0.005],'YScale','log');
    hold off;

    
        
%% Plot E histogram

figure;
% set(gcf,'color','w');
bins = 100;

    [Ns,Xs] = hist(E, bins);
    stairs(Xs,Ns,'color','k','Linewidth',2); hold on;
    
    grid on;
        
    title (['TAS E. Entries ' num2str(sz(1)) ', Mean ' num2str(me, '%10.5e\t') ', RMS ' num2str(rme, '%10.5e\t') ],'FontSize',20);
%     title (['IPB E. Entries ' num2str(sz(1)) ', Mean ' num2str(me, '%10.5e\t') ', RMS ' num2str(rme, '%10.5e\t') ],'FontSize',20);
    
    ylabel('Frequency [-]','FontSize',20);
    xlabel('E [GeV]','FontSize',20);
    
     set(gca,'FontSize',20,'YScale','log','XLim',[0 50000]);
%     set(gca,'FontSize',20,'YScale','log','XLim',[49000 50000]);
%     set(gca,'FontSize',20,'YScale','log');
    hold off;
    
    
    
     
%      set(gca,'FontSize',10,'YScale','log');
%     set(gca,'FontSize',10,'YScale','log','XLim',[-1E-4 1E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2],'PlotBoxAspectRatio',[4 2 2]);