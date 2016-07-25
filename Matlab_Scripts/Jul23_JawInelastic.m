%% Jaw Inelastic Z
clearvars all;
%% Import data MERLIN
filename = '/home/HR/Downloads/JawInelastic/jaw_inelastic_TCSG.B5L7.B2_Pure.txt';
% filename = '/home/HR/Downloads/JawInelastic/jaw_inelastic_TCP.C6R7.B2_Pure.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
x = dataArray{:, 1};
xp = dataArray{:, 2};
y = dataArray{:, 3};
yp = dataArray{:, 4};
ct = dataArray{:, 5};
dp = dataArray{:, 6};
z = dataArray{:, 7};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/JawInelastic/jaw_inelastic_TCSG.B5L7.B2_Comp.txt';
% filename = '/home/HR/Downloads/JawInelastic/jaw_inelastic_TCP.C6R7.B2_Comp.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
cx = dataArray{:, 1};
cxp = dataArray{:, 2};
cy = dataArray{:, 3};
cyp = dataArray{:, 4};
cct = dataArray{:, 5};
cdp = dataArray{:, 6};
cz = dataArray{:, 7};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/JawInelastic/jaw_inelastic_TCSG.B5L7.B2_Pure4D.txt';
% filename = '/home/HR/Downloads/JawInelastic/jaw_inelastic_TCP.C6R7.B2_Pure4D.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
x4 = dataArray{:, 1};
xp4 = dataArray{:, 2};
y4 = dataArray{:, 3};
yp4 = dataArray{:, 4};
ct4 = dataArray{:, 5};
dp4 = dataArray{:, 6};
z4 = dataArray{:, 7};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/JawInelastic/jaw_inelastic_TCSG.B5L7.B2_Comp4D.txt';
% filename = '/home/HR/Downloads/JawInelastic/jaw_inelastic_TCP.C6R7.B2_Comp4D.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
cx4 = dataArray{:, 1};
cxp4 = dataArray{:, 2};
cy4 = dataArray{:, 3};
cyp4 = dataArray{:, 4};
cct4 = dataArray{:, 5};
cdp4 = dataArray{:, 6};
cz4 = dataArray{:, 7};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import data SixTrack
filename = '/home/HR/Downloads/JawInelastic/impacts_real_icoll10_ievent1_col4_zoomNegJaw_fort.72';
startRow = 18;
formatSpec = '%19f%19f%11f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
ST_xneg_min = dataArray{:, 1};
ST_Xneg_max = dataArray{:, 2};
ST_xneg_counts = dataArray{:, 3};
clearvars filename startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/JawInelastic/impacts_real_icoll10_ievent1_col3_fort.72';
startRow = 16;
formatSpec = '%19f%19f%11f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
ST_smin = dataArray{:, 1};
ST_smax  = dataArray{:, 2};
ST_s_counts = dataArray{:, 3};
clearvars filename startRow formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot histogram of z all
figure;
% Number of bins
hh=1000;

range_1=min(z4):(max(z4)-min(z4))/hh:max(z4);
[N1,X1] = hist(z4,range_1);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X1,N1,'Linewidth',1, 'Color', c_teal);
hold on;

% plot(ST_smin,ST_s_counts, 'Color', c_gray);

range_4=min(cz4):(max(cz4)-min(cz4))/hh:max(cz4);
[N4,X4] = hist(cz4,range_4);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X4,N4,'Linewidth',1, 'Color', 'k');
hold on;

range_3=min(z):(max(z)-min(z))/hh:max(z);
[N3,X3] = hist(z,range_3);
% stairs(X3,N3/sum(N3)/(max(z)-min(z)/hh ),'Linewidth',1.5, 'Color', c_orange);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

range_2=min(cz):(max(cz)-min(cz))/hh:max(cz);
[N2,X2] = hist(cz,range_2);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% legend({'MERLIN Pure 4D', 'SixTrack', 'MERLIN Composite 4D', 'MERLIN Pure 6D', 'MERLIN Composite 6D'},'FontSize',16);
legend({'MERLIN Pure 4D', 'MERLIN Composite 4D', 'MERLIN Pure 6D', 'MERLIN Composite 6D'},'FontSize',16);
xlabel('s [m]');
ylabel('PDF');
title ('6.5 TeV Beam 2 TCSG.B5L7.B2','FontSize',16);
hold off;

%% Plot histogram of z 4D + 6D
figure;
% Number of bins
hh=1000;

range_1=min(z4):(max(z4)-min(z4))/hh:max(z4);
[N1,X1] = hist(z4,range_1);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X1,N1,'Linewidth',1, 'Color', c_teal);
hold on;

range_4=min(cz4):(max(cz4)-min(cz4))/hh:max(cz4);
[N4,X4] = hist(cz4,range_4);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X4,N4,'Linewidth',1, 'Color', 'k');
hold on;

range_3=min(z):(max(z)-min(z))/hh:max(z);
[N3,X3] = hist(z,range_3);
% stairs(X3,N3/sum(N3)/(max(z)-min(z)/hh ),'Linewidth',1.5, 'Color', c_orange);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

range_2=min(cz):(max(cz)-min(cz))/hh:max(cz);
[N2,X2] = hist(cz,range_2);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend({'MERLIN Pure 4D', 'MERLIN Composite 4D', 'MERLIN Pure 6D', 'MERLIN Composite 6D'},'FontSize',16);
xlabel('s [m]');
ylabel('PDF');
title ('6.5 TeV Beam 2 TCSG.B5L7.B2','FontSize',16);
hold off;

%% Plot histogram of z 6D + ST
figure;
% Number of bins
hh=1000;

range_3=min(z):(max(z)-min(z))/hh:max(z);
[N3,X3] = hist(z,range_3);
% stairs(X3,N3/sum(N3)/(max(z)-min(z)/hh ),'Linewidth',1.5, 'Color', c_orange);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

% plot(ST_smin,ST_s_counts, 'Color', c_gray);

range_2=min(cz):(max(cz)-min(cz))/hh:max(cz);
[N2,X2] = hist(cz,range_2);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% legend({'MERLIN Pure 6D', 'SixTrack', 'MERLIN Composite 6D'},'FontSize',16);
legend({'MERLIN Pure 6D','MERLIN Composite 6D'},'FontSize',16);
xlabel('s [m]');
ylabel('PDF');
title ('6.5 TeV Beam 2 TCSG.B5L7.B2','FontSize',16);
hold off;


%% Plot histogram of z 4D + ST
figure;
% Number of bins
hh=1000;

range_1=min(z4):(max(z4)-min(z4))/hh:max(z4);
[N1,X1] = hist(z4,range_1);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X1,N1,'Linewidth',1, 'Color', c_teal);
hold on;

% plot(ST_smin,ST_s_counts, 'Color', c_gray);

range_4=min(cz4):(max(cz4)-min(cz4))/hh:max(cz4);
[N4,X4] = hist(cz4,range_4);
% stairs(X2,N2/sum(N2)/(max(cz)-min(cz)/hh ),'Linewidth',1.5, 'Color', c_dodger);
stairs(X4,N4,'Linewidth',1, 'Color', 'k');
hold on;

grid on;
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% legend({'MERLIN Pure 4D', 'SixTrack', 'MERLIN Composite 4D'},'FontSize',16);
legend({'MERLIN Pure 4D', 'MERLIN Composite 4D'},'FontSize',16);
xlabel('s [m]');
ylabel('PDF');
title ('6.5 TeV Beam 2 TCSG.B5L7.B2','FontSize',16);
hold off;