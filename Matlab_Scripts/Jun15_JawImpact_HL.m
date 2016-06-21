%% Plot JawImpact - i.e. TCLD impact distributions
clear all;
%% Import AC150K
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/15June_HL_JawImpact/Comp_TCLD.8R7.B1.txt';
% delimiter = {'\t',' '};
% startRow = 2;
% formatSpec = '%*s%f%*s%f%*s%*s%f%*s%*s%[^\n\r]';
% fileID = fopen(filename,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
% fclose(fileID);
% P_x = dataArray{:, 1};
% P_y = dataArray{:, 2};
% P_dp = dataArray{:, 3};
% clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/15June_HL_JawImpact/Comp_TCLD.10R7.B1.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%*s%f%*s%f%*s%*s%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
P_x = dataArray{:, 1};
P_y = dataArray{:, 2};
P_dp = dataArray{:, 3};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import CuCD
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/15June_HL_JawImpact/CuCD_TCLD.8R7.B1.txt';
% delimiter = {'\t',' '};
% startRow = 2;
% formatSpec = '%*s%f%*s%f%*s%*s%f%*s%*s%[^\n\r]';
% fileID = fopen(filename,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
% fclose(fileID);
% C_x = dataArray{:, 1};
% C_y = dataArray{:, 2};
% C_dp = dataArray{:, 3};
% clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/15June_HL_JawImpact/CuCD_TCLD.10R7.B1.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%f%*s%f%*s%*s%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
C_x = dataArray{:, 1};
C_y = dataArray{:, 2};
C_dp = dataArray{:, 3};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import MoGr
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/15June_HL_JawImpact/MoGr_TCLD.8R7.B1.txt';
% delimiter = {'\t',' '};
% startRow = 2;
% formatSpec = '%*s%f%*s%f%*s%*s%f%*s%*s%[^\n\r]';
% fileID = fopen(filename,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
% fclose(fileID);
% M_x = dataArray{:, 1};
% M_y = dataArray{:, 2};
% M_dp = dataArray{:, 3};
% clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/15June_HL_JawImpact/CuCD_TCLD.10R7.B1.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%f%*s%f%*s%*s%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
M_x = dataArray{:, 1};
M_y = dataArray{:, 2};
M_dp = dataArray{:, 3};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot histogram of x
% figure;
% binwidth = 1E-2;
% hh=200;
% 
% range_3=min(M_x):(max(M_x)-min(M_x))/hh:max(M_x);
% [N3,X3] = hist(M_x,range_3);
% stairs(X3,N3/sum(N3)/(max(M_x)-min(M_x)/hh ),'Linewidth',1.5, 'Color', c_orange);
% hold on;
% 
% range_2=min(C_x):(max(C_x)-min(C_x))/hh:max(C_x);
% [N2,X2] = hist(C_x,range_2);
% stairs(X2,N2/sum(N2)/ (max(C_x)-min(C_x)/hh ),'Linewidth',1.5, 'Color', c_dodger);
% hold on;
% 
% range_1=min(P_x):(max(P_x)-min(P_x))/hh:max(P_x);
% [N1,X1] = hist(P_x,range_1);
% stairs(X1,N1/sum(N1)/ (max(P_x)-min(P_x)/hh ),'Linewidth',1, 'Color', 'k');
% hold on;
% 
% grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% legend({'MoGr', 'CuCD', 'AC150K'},'FontSize',16);
% xlabel('x [m]');
% ylabel('PDF');
% title ('HL-LHC Beam TCLD.10R7.B1','FontSize',16);
% hold off;

%% Plot histogram of dp
figure;
binwidth = 1E-2;
hh=300;

range_3=min(M_dp):(max(M_dp)-min(M_dp))/hh:max(M_dp);
[N3,X3] = hist(M_dp,range_3);
stairs(X3,N3/sum(N3)/(max(M_dp)-min(M_dp)/hh ),'Linewidth',1.5, 'Color', c_orange);
hold on;

range_2=min(C_dp):(max(C_dp)-min(C_dp))/hh:max(C_dp);
[N2,X2] = hist(C_dp,range_2);
stairs(X2,N2/sum(N2)/ (max(C_dp)-min(C_dp)/hh ),'Linewidth',1.5, 'Color', c_dodger);
hold on;
% 
% range_1=min(P_dp):(max(P_dp)-min(P_dp))/hh:max(P_dp);
% [N1,X1] = hist(P_dp,range_1);
% stairs(X1,N1/sum(N1)/ (max(P_dp)-min(P_dp)/hh ),'Linewidth',1, 'Color', 'k');
% hold on;

grid on;
set(gca,'yscale','log','XLim',[-0.02 0],'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend({'MoGr', 'CuCD', 'AC150K'},'FontSize',16, 'location', 'northwest');
xlabel('\delta [GeV]');
ylabel('PDF');
title ('HL-LHC Beam TCLD.10R7.B1','FontSize',16);
hold off;