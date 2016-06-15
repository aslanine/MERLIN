%% Plot 1cm scatter plots with no MCS or Ionisation
clear all;

%% Import SixTrack data
material=dir('*.dat');
STfilename = cell(length(material),1); 
dataST = cell(length(material),1); 

% 1 inelastic    2 MCS      3 SD     4 nElast
for k = 1:length(material)
  STfilename{k} = material(k).name;
   dataST{k} = importdata(STfilename{k});
end

%% Import MERLIN Composite data

Mmaterial=dir('Mselect*.txt');
Mfilename = cell(length(Mmaterial),1); 
dataM = cell(length(Mmaterial),1); 

% 1 Elastic   2 Inelastic     3 SD
for k = 1:length(Mmaterial)
  Mfilename{k} = Mmaterial(k).name;
  dataM{k} = importdata(Mfilename{k});
end

%% Import MERLIN ST-like data

Nmaterial=dir('Sselect*.txt');
Nfilename = cell(length(Nmaterial),1); 
dataN = cell(length(Nmaterial),1); 

% 1 Elastic   2 Inelastic     3 SD
for k = 1:length(Nmaterial)
  Nfilename{k} = Nmaterial(k).name;
  dataN{k} = importdata(Nfilename{k});
end

%% Import MERLIN SD Hist
filename = '/home/HR/Downloads/IPAC16/1cm/input6T/1CM/MoGr/MHIST_MoGr_4.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
SD_bxp = dataArray{:, 1};
SD_xp = dataArray{:, 2};
SD_bdp = dataArray{:, 3};
SD_dp = dataArray{:, 4};
SD_bth = dataArray{:, 5};
SD_th = dataArray{:, 6};
SD_bt = dataArray{:, 7};
SD_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import ST-like SD Hist
filename = '/home/HR/Downloads/IPAC16/1cm/input6T/1CM/MoGr/SHIST_MoGr_4.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
SSD_bxp = dataArray{:, 1};
SSD_xp = dataArray{:, 2};
SSD_bdp = dataArray{:, 3};
SSD_dp = dataArray{:, 4};
SSD_bth = dataArray{:, 5};
SSD_th = dataArray{:, 6};
SSD_bt = dataArray{:, 7};
SSD_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import MERLIN pn elastic
filename = '/home/HR/Downloads/IPAC16/1cm/input6T/1CM/MoGr/MHIST_MoGr_2.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
El2_bxp = dataArray{:, 1};
El2_xp = dataArray{:, 2};
El2_bdp = dataArray{:, 3};
El2_dp = dataArray{:, 4};
El2_bth = dataArray{:, 5};
El2_th = dataArray{:, 6};
El2_bt = dataArray{:, 7};
El2_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import ST-like pn elastic
filename = '/home/HR/Downloads/IPAC16/1cm/input6T/1CM/MoGr/SHIST_MoGr_2.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
SEl2_bxp = dataArray{:, 1};
SEl2_xp = dataArray{:, 2};
SEl2_bdp = dataArray{:, 3};
SEl2_dp = dataArray{:, 4};
SEl2_bth = dataArray{:, 5};
SEl2_th = dataArray{:, 6};
SEl2_bt = dataArray{:, 7};
SEl2_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot nuclear+nucleon elastic

% figure;
% nuclear/nucleon elastic
i = 4;
j = 1;
% x plane
k = 2;
l = 3;

fig1=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

[Ns,Xs] = hist(dataST{i,1}.data(:,k),-1E-4:2E-7:1E-4);
stairs(Xs,Ns,'color',c_gray,'Linewidth',2); hold on;
% [Nm,Xm] = hist(dataM{j,1}.data(:,l), -1E-4:2E-7:1E-4);
% stairs(Xm,Nm,'color',c_orange,'Linewidth',2); hold on;

plot(El2_bxp, El2_xp,'color',c_orange,'Linewidth',2); hold on;
plot(SEl2_bxp, SEl2_xp,'color',c_dodger,'Linewidth',2); hold on;

legend('location', 'northeast', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like');

grid on;

title ('MoGr no MCS or Ionisation: pn Elastic','FontSize',16);
ylabel('Frequency [-]','FontSize',25);
xlabel('\Delta xp [rad]','FontSize',25);

set(gca,'FontSize',20,'YScale','log','XLim',[-0.5E-4 0.5E-4]);

hold off;


%% Plot SD xp

% figure;
% SD
i = 3;
j = 3;
% x plane
k = 2;
l = 3;

fig2=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

[Ns,Xs] = hist(dataST{i,1}.data(:,k),-1E-4:2E-7:1E-4);
stairs(Xs,Ns,'color',c_gray,'Linewidth',2); hold on;

% Plot MERLIN using raw Select Scatter
% [Nm,Xm] = hist(dataM{j,1}.data(:,l), -1E-4:2E-7:1E-4);
% stairs(Xm,Nm,'color',c_orange,'Linewidth',2); hold on;

% Plot MERLIN using histogram file
plot(SD_bxp, SD_xp,'color',c_orange,'Linewidth',2); hold on;
plot(SSD_bxp, SSD_xp,'color',c_dodger,'Linewidth',2); hold on;

legend('location', 'northeast', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like');

grid on;

title ('MoGr no MCS or Ionisation: Single Diffractive','FontSize',16);
ylabel('Frequency [-]','FontSize',25);
xlabel('\Delta xp [rad]','FontSize',25);

set(gca,'FontSize',20,'YScale','log','XLim',[-1E-4 1E-4]);

hold off;

%% Plot SD dp

% figure;
% SD
i = 3;
j = 3;
% dp plane
k = 1;
l = 7;

fig3=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

[Ns,Xs] = hist(-dataST{i,1}.data(:,k),0:1.5E-4:0.15);
stairs(Xs,Ns,'color',c_gray,'Linewidth',2); hold on;

% Plot MERLIN using raw Select Scatter
% [Nm,Xm] = hist(dataM{j,1}.data(:,l), -1E-4:2E-7:1E-4);
% stairs(Xm,Nm,'color',c_orange,'Linewidth',2); hold on;

% Plot MERLIN using histogram file
plot(SD_bdp, SD_dp,'color',c_orange,'Linewidth',2); hold on;
plot(SSD_bdp, SSD_dp,'color',c_dodger,'Linewidth',2); hold on;

legend('location', 'northeast', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like');

grid on;

title ('MoGr no MCS or Ionisation: Single Diffractive','FontSize',16);
ylabel('Frequency [-]','FontSize',25);
xlabel('\Delta dp [GeV]','FontSize',25);

set(gca,'FontSize',20,'YScale','log','XLim',[0 0.15],'YLim',[0 5E3]);

hold off;

%% Plot SD theta

% figure;
% SD
i = 3;
j = 3;
% xp plane
k = 2;
l = 3;

fig4=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

% theta = atan ( sqrt( xp*xp + yp*yp ) );
% t = - (4.9E19)*(theta*theta);

[Ns,Xs] = hist( atan( sqrt( dataST{i,1}.data(:,k).*dataST{i,1}.data(:,k) + dataST{i,1}.data(:,(k+1)).*dataST{i,1}.data(:,(k+1)) ) ), 1000);
stairs(Xs,Ns,'color',c_gray,'Linewidth',2); hold on;

% Plot MERLIN using raw Select Scatter
[Nm,Xm] = hist( atan( sqrt( dataM{j,1}.data(:,l).*dataM{j,1}.data(:,l) + dataM{j,1}.data(:,(l+2)).*dataM{j,1}.data(:,(l+2))) ), 1000);
stairs(Xm,Nm,'color',c_orange,'Linewidth',2); hold on;

[Nn,Xn] = hist( atan( sqrt( dataN{j,1}.data(:,l).*dataN{j,1}.data(:,l) + dataN{j,1}.data(:,(l+2)).*dataN{j,1}.data(:,(l+2))) ), 1000);
stairs(Xn,Nn,'color',c_dodger,'Linewidth',2); hold on;

% Plot MERLIN using histogram file
% plot(SD_bth, SD_th,'color',c_orange,'Linewidth',2); hold on;
% plot(SSD_bth, SSD_th,'color',c_dodger,'Linewidth',2); hold on;

legend('location', 'northeast', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like');

grid on;

title ('MoGr no MCS or Ionisation: Single Diffractive','FontSize',16);
ylabel('Frequency [-]','FontSize',25);
xlabel('\theta [rad]','FontSize',25);

set(gca,'FontSize',20,'YScale','log','XLim',[0 2E-4],'YLim',[0 2E2]);
% set(gca,'FontSize',20,'YScale','log');

hold off;


%% Plot SD t

% figure;
% SD
i = 3;
j = 3;
% dp plane
k = 1;
l = 7;

fig5=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

[Ns,Xs] = hist( (4.9E19).*(atan( sqrt( dataST{3,1}.data(:,2).*dataST{3,1}.data(:,2) + dataST{3,1}.data(:,3).*dataST{3,1}.data(:,3)) ) ).*(atan( sqrt( dataST{3,1}.data(:,2).*dataST{3,1}.data(:,2) + dataST{3,1}.data(:,3).*dataST{3,1}.data(:,3)) ) ), 1000);
stairs(Xs,Ns,'color',c_gray,'Linewidth',2); hold on;

% Plot MERLIN using raw Select Scatter
[Nm,Xm] = hist( (4.9E19).*(atan( sqrt( dataM{3,1}.data(:,3).*dataM{3,1}.data(:,3) + dataM{3,1}.data(:,5).*dataM{3,1}.data(:,5)) ) ).*(atan( sqrt( dataM{3,1}.data(:,3).*dataM{3,1}.data(:,3) + dataM{3,1}.data(:,5).*dataM{3,1}.data(:,5)) ) ), 1000);
stairs(Xm,Nm,'color',c_orange,'Linewidth',2); hold on;

[Nn,Xn] = hist( (4.9E19).*(atan( sqrt( dataN{3,1}.data(:,3).*dataN{3,1}.data(:,3) + dataN{3,1}.data(:,5).*dataN{3,1}.data(:,5)) ) ).*(atan( sqrt( dataN{3,1}.data(:,3).*dataN{3,1}.data(:,3) + dataN{3,1}.data(:,5).*dataN{3,1}.data(:,5)) ) ), 1000);
stairs(Xn,Nn,'color',c_dodger,'Linewidth',2); hold on;

% Plot MERLIN using histogram file
% plot(SD_bt, SD_t,'color',c_orange,'Linewidth',2); hold on;
% plot(SSD_bt, SSD_t,'color',c_dodger,'Linewidth',2); hold on;

legend('location', 'northeast', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like');

grid on;
title ('MoGr no MCS or Ionisation: Single Diffractive','FontSize',16);
ylabel('Frequency [-]','FontSize',25);
xlabel('t [GeV^2]','FontSize',25);

set(gca,'FontSize',20,'YScale','log','XLim',[0 2E12],'YLim',[0 1E3]);
% set(gca,'FontSize',20,'YScale','log');

hold off;