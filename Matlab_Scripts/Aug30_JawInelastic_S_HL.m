%% Jaw Inelastic s 7 TeV nominal b1
clearvars all;
%% Import data MERLIN
filename = '/home/HR/Downloads/HL_JI/jaw_inelastic_TCSG.B5L7.B1_C.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
x = dataArray{:, 2};
xp = dataArray{:, 3};
y = dataArray{:, 4};
yp = dataArray{:, 5};
ct = dataArray{:, 6};
dp = dataArray{:, 7};
z = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/HL_JI/jaw_inelastic_TCSG.B5L7.B1_AC150K.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
cx = dataArray{:, 2};
cxp = dataArray{:, 3};
cy = dataArray{:, 4};
cyp = dataArray{:, 5};
cct = dataArray{:, 6};
cdp = dataArray{:, 7};
cz = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot histogram of z all
figure;
% Number of bins
hh=1000;

range_1=min(z):(max(z)-min(z))/hh:max(z);
[N1,X1] = hist(z,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_dodger);
hold on;

range_4=min(cz):(max(cz)-min(cz))/hh:max(cz);
[N4,X4] = hist(cz,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_orange);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend({'Pure', 'Composite'},'FontSize',16,'location','southwest');
xlabel('s [m]');
ylabel('PDF');
title ('HL-LHC Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of x all
figure;
% Number of bins
hh=1000;

range_1=min(x):(max(x)-min(x))/hh:max(x);
[N1,X1] = hist(x,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_dodger);
hold on;

range_4=min(cx):(max(cx)-min(cx))/hh:max(cx);
[N4,X4] = hist(cx,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_orange);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend({'Pure', 'Composite'},'FontSize',16,'location','northwest');
xlabel('x [m]');
ylabel('PDF');
title ('HL-LHC Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of xp all
figure;
% Number of bins
hh=1000;

range_1=min(xp):(max(xp)-min(xp))/hh:max(xp);
[N1,X1] = hist(xp,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_dodger);
hold on;

range_4=min(cxp):(max(cxp)-min(cxp))/hh:max(cxp);
[N4,X4] = hist(cxp,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_orange);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-4E-4 4E-4]);
legend({'Pure', 'Composite'},'FontSize',16,'location','northwest');
xlabel('xp [rad]');
ylabel('PDF');
title ('HL-LHC Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of y all
figure;
% Number of bins
hh=1000;

range_1=min(y):(max(y)-min(y))/hh:max(y);
[N1,X1] = hist(y,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_dodger);
hold on;

range_4=min(cy):(max(cy)-min(cy))/hh:max(cy);
[N4,X4] = hist(cy,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_orange);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.01 0.01]);
legend({'Pure', 'Composite'},'FontSize',16,'location','northwest');
xlabel('y [m]');
ylabel('PDF');
title ('HL-LHC Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of yp all
figure;
% Number of bins
hh=1000;

range_1=min(yp):(max(yp)-min(yp))/hh:max(yp);
[N1,X1] = hist(yp,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_dodger);
hold on;

range_4=min(cyp):(max(cyp)-min(cyp))/hh:max(cyp);
[N4,X4] = hist(cyp,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_orange);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-2E-4 2E-4]);
legend({'Pure', 'Composite'},'FontSize',16,'location','northwest');
xlabel('yp [rad]');
ylabel('PDF');
title ('HL-LHC Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of dp all
figure;
% Number of bins
hh=1000;

range_1=min(dp):(max(dp)-min(dp))/hh:max(dp);
[N1,X1] = hist(dp,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_dodger);
hold on;

range_4=min(cdp):(max(cdp)-min(cdp))/hh:max(cdp);
[N4,X4] = hist(cdp,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_orange);
hold on;
grid on;
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend({'Pure', 'Composite'},'FontSize',16,'location','northwest');
xlabel('dp [GeV]');
ylabel('PDF');
title ('HL-LHC Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;