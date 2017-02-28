%% Script to merge split data and plot no_particles for HL-LHC HEL Runs
clear all;
%% List of all directories

%% Current Modulating

% NH
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/NH/R'
% DC
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DC/R'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DC/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DC/O'
% AC
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/AC/R'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/AC/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/AC/O'
% DIFF
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/R'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/O'

%% Geometric Modulating
% Elliptical
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/Geometric/Elliptical/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/Geometric/Elliptical/O'
% Hula
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/Geometric/Hula/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/Geometric/Hula/O'
% CloseHula
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/Geometric/CloseHula/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/Geometric/CloseHula/O'
% Pogo
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/Geometric/Pogo/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/Geometric/Pogo/O'

%% Parameter Changes

% Current
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_5A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_6A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_7A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_8A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_10A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Current/NR_6A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Current/NR_7A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Current/NR_8A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Current/NR_9A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Current/NR_10A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Current/R_10A'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Current/O_10A'
% Length
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Length/NR_4m'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Length/NR_5m'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Length/R_5m'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Length/O_5m'
% Energy
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Energy/NR_15keV'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Energy/NR_20keV'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Energy/R_20keV'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Energy/O_20keV'
% Max
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/NR'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/R'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/DIFF/O'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/MAX/NR_Max'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/MAX/R_Max'
% '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/MAX/O_Max'

%% Import data files
clear all;
turns = 100000;
turns = turns + 1;

%% HA
cd('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_5A');
list = dir('*.txt'); 
HA = zeros(turns, 2); A = zeros(turns, 2);
for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        HA(:,1) = A(:,1);
        HA(:,2) = A(:,2);
    else    
        HA(:,2) = HA(:,2) + A(:,2);
    end
end
npart = HA(1,2);
clear A list;

%% HB
cd('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_6A');
list = dir('*.txt'); 
HB = zeros(turns, 2); A = zeros(turns, 2);
for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        HB(:,1) = A(:,1);
        HB(:,2) = A(:,2);
    else    
        HB(:,2) = HB(:,2) + A(:,2);
    end
end
clear A list;

%% HC
cd('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_7A');
list = dir('*.txt'); 
HC = zeros(turns, 2); A = zeros(turns, 2);
for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        HC(:,1) = A(:,1);
        HC(:,2) = A(:,2);
    else    
        HC(:,2) = HC(:,2) + A(:,2);
    end
end
clear A list;

%% HD
cd('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_8A');
list = dir('*.txt'); 
HD = zeros(turns, 2); A = zeros(turns, 2);
for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        HD(:,1) = A(:,1);
        HD(:,2) = A(:,2);
    else    
        HD(:,2) = HD(:,2) + A(:,2);
    end
end
clear A list;

%% HE
cd('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/HEL_Table/NR_10A');
list = dir('*.txt'); 
HE = zeros(turns, 2); A = zeros(turns, 2);
for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        HE(:,1) = A(:,1);
        HE(:,2) = A(:,2);
    else    
        HE(:,2) = HE(:,2) + A(:,2);
    end
end
clear A list;
%% HF
% cd('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/24May_HEL/CurrentModulating/Current/O_10A');
% list = dir('*.txt'); 
% HF = zeros(turns, 2); A = zeros(turns, 2);
% for ii = 1:length(list)
%     clear A;
%     A = importdata(list(ii).name);
%     if(ii==1)
%         HF(:,1) = A(:,1);
%         HF(:,2) = A(:,2);
%     else    
%         HF(:,2) = HF(:,2) + A(:,2);
%     end
% end
% clear A list;
%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot

plot(HA(:,1), HA(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 3), hold on;
plot(HB(:,1), HB(:,2)/npart, '-', 'Color', 'r', 'LineWidth', 3), hold on;
% plot(HC(:,1), HC(:,2)/npart, '-', 'Color', 'g', 'LineWidth', 3), hold on;
plot(HD(:,1), HD(:,2)/npart, '-', 'Color', 'b', 'LineWidth', 3), hold on;
plot(HE(:,1), HE(:,2)/npart, '-', 'Color', 'c', 'LineWidth', 3), hold on;
% plot(HF(:,1), HF(:,2)/npart, ':', 'Color', c_dodger, 'LineWidth', 3), hold on;

% plot(HA(:,1), HA(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 3), hold on;
% plot(HB(:,1), HB(:,2)/npart, '-', 'Color', 'r', 'LineWidth', 3), hold on;
% plot(HC(:,1), HC(:,2)/npart, '-', 'Color', 'g', 'LineWidth', 3), hold on;
% plot(HD(:,1), HD(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(HE(:,1), HE(:,2)/npart, '-', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(HF(:,1), HF(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;

%% Legend

% legend('Location', 'southwest', 'R 3 [m]', 'NR 3 [m]', 'O 3 [m]', 'R 5 [m]', 'NR 5 [m]', 'O 5 [m]');
% legend('Location', 'southwest', 'R', 'NR', 'O', 'R Max', 'NR Max', 'O Max');
% legend('Location', 'southwest', 'NR 5 [A]', 'NR 6 [A]', 'NR 7 [A]', 'NR 8 [A]', 'NR 10 [A]');
legend('Location', 'southwest', 'NR 5 [A]', 'NR 6 [A]', 'NR 8 [A]', 'NR 10 [A]');
% legend('Location', 'southwest', 'R 10 [keV]',  'NR 10 [keV]', 'O 10 [keV]','R 20 [keV]', 'NR 20 [keV]', 'O 20 [keV]');


%% Plot Settings

title ('Current','FontSize',16);
% Full axes
set(gca,'FontSize',16,'XLim',[0 1E5],'Xtick',[0:1E4:1E5],'YLim',[0 1],'Ytick',[0:0.1:1],'PlotBoxAspectRatio',[4 2 2]);
% Zoom axes
% ymin = 0.4;
% ymax = 1;
% yint = 0.1;
% set(gca,'FontSize',16,'XLim',[0 1E5],'Xtick',[0:1E4:1E5],'YLim',[ymin ymax],'Ytick',[ymin:yint:ymax],'PlotBoxAspectRatio',[4 2 2]);

grid on;
xlabel('Turn [-] ','FontSize',16);
ylabel('Survival N/N_0 [-]','FontSize',16);

hold off;