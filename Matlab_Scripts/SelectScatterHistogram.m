%% Plot SelectScatter and MCS histograms for 1cm AC150K

%% Import AC150K Inelastic
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/M/AC150K/HIST_AC150K_1.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
bdp_1 = dataArray{:, 1};
dp1 = dataArray{:, 2};
btheta_1 = dataArray{:, 3};
theta1 = dataArray{:, 4};
bt_1 = dataArray{:, 5};
t1 = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import AC150K Nuclear Elastic
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/M/AC150K/HIST_AC150K_2.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
bdp_2 = dataArray{:, 1};
dp2 = dataArray{:, 2};
btheta_2 = dataArray{:, 3};
theta2 = dataArray{:, 4};
bt_2 = dataArray{:, 5};
t2 = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import AC150K nucleon Elastic
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/M/AC150K/HIST_AC150K_3.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
bdp_3 = dataArray{:, 1};
dp3 = dataArray{:, 2};
btheta_3 = dataArray{:, 3};
theta3 = dataArray{:, 4};
bt_3 = dataArray{:, 5};
t3 = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import AC150K Single Diffractive
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/M/AC150K/HIST_AC150K_4.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
bdp_4 = dataArray{:, 1};
dp4 = dataArray{:, 2};
btheta_4 = dataArray{:, 3};
theta4 = dataArray{:, 4};
bt_4 = dataArray{:, 5};
t4 = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import MCS
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/M/AC150K/hist_MCS_AC150K_.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
bdp_5 = dataArray{:, 1};
dp5 = dataArray{:, 2};
btheta_5 = dataArray{:, 3};
theta5 = dataArray{:, 4};
bt_5 = dataArray{:, 5};
t5 = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Plot dp
% 
% stairs(bdp_1,dp1/sum(dp1),'Linewidth',1);
% hold on;
% stairs(bdp_2,dp2/sum(dp2),'Linewidth',1);
% hold on;
% stairs(bdp_3,dp3/sum(dp3),'Linewidth',1);
% hold on;
% stairs(bdp_5,dp5/sum(dp5),'Linewidth',1);
% hold on;
% 
% grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[0 1E-5]);
% legend({'Inelastic','Nuclear Elastic','Nucleon Elastic', 'MCS'},'FontSize',16);
% xlabel('dp [GeV]');
% ylabel('Normalised Frequency [-]');

%% Plot t

% stairs(bt_1,t1/sum(t1),'Linewidth',1);
% hold on;
% stairs(bt_2,t2/sum(t2),'Linewidth',1);
% hold on;
% stairs(bt_3,t3/sum(t3),'Linewidth',1);
% hold on;
% stairs(bt_4,t4/sum(t4),'Linewidth',1);
% hold on;
% stairs(bt_5,t5/sum(t5),'Linewidth',1);
% hold on;
% 
% grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-1E9 0]);
% legend({'Inelastic','Nuclear Elastic','Nucleon Elastic','Single Diffractive', 'MCS'},'FontSize',16,'location','northwest');
% xlabel('t [GeV^2]');
% ylabel('Normalised Frequency [-]');

%% Plot theta

stairs(btheta_1,theta1/sum(theta1),'Linewidth',1);
hold on;

grid on;
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[0 1.2E-6]);
legend({'Inelastic'},'FontSize',16,'location','northeast');
xlabel('Polar Angle [rad]');
ylabel('Normalised Frequency [-]');

hold off;