%% Jaw Inelastic s 7 TeV nominal b1
clearvars all;
%% Import data MERLIN
filename = '/home/HR/Downloads/7_Jaw/JawInelastic/JI_TCSG.B5L7.B1_Pure.txt';
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

filename = '/home/HR/Downloads/7_Jaw/JawInelastic/JI_TCSG.B5L7.B1_Composite.txt';
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

filename = '/home/HR/Downloads/7_Jaw/JawInelastic/JI_TCSG.B5L7.B1_MoGr_2e.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
mx = dataArray{:, 2};
mxp = dataArray{:, 3};
my = dataArray{:, 4};
myp = dataArray{:, 5};
mct = dataArray{:, 6};
mdp = dataArray{:, 7};
mz = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/7_Jaw/JawInelastic/JI_TCSG.B5L7.B1_CuCD_2e.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
dx = dataArray{:, 2};
dxp = dataArray{:, 3};
dy = dataArray{:, 4};
dyp = dataArray{:, 5};
dct = dataArray{:, 6};
ddp = dataArray{:, 7};
dz = dataArray{:, 8};
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
stairs(X1,N1,'Linewidth',1, 'Color', c_gray);
hold on;

range_4=min(cz):(max(cz)-min(cz))/hh:max(cz);
[N4,X4] = hist(cz,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_teal);
hold on;

range_3=min(mz):(max(mz)-min(mz))/hh:max(mz);
[N3,X3] = hist(mz,range_3);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

range_2=min(dz):(max(dz)-min(dz))/hh:max(dz);
[N2,X2] = hist(dz,range_2);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend({'Pure', 'Composite', 'MoGr', 'CuCD'},'FontSize',16,'location','northwest');
xlabel('s [m]');
ylabel('PDF');
title ('7 TeV Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of x all
figure;
% Number of bins
hh=1000;

range_1=min(x):(max(x)-min(x))/hh:max(x);
[N1,X1] = hist(x,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_gray);
hold on;

range_4=min(cx):(max(cx)-min(cx))/hh:max(cx);
[N4,X4] = hist(cx,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_teal);
hold on;

range_3=min(mx):(max(mx)-min(mx))/hh:max(mx);
[N3,X3] = hist(mx,range_3);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

range_2=min(dx):(max(dx)-min(dx))/hh:max(dx);
[N2,X2] = hist(dx,range_2);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend({'Pure', 'Composite', 'MoGr', 'CuCD'},'FontSize',16,'location','northwest');
xlabel('x [m]');
ylabel('PDF');
title ('7 TeV Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of xp all
figure;
% Number of bins
hh=1000;

range_1=min(xp):(max(xp)-min(xp))/hh:max(xp);
[N1,X1] = hist(xp,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_gray);
hold on;

range_4=min(cxp):(max(cxp)-min(cxp))/hh:max(cxp);
[N4,X4] = hist(cxp,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_teal);
hold on;

range_3=min(mxp):(max(mxp)-min(mxp))/hh:max(mxp);
[N3,X3] = hist(mxp,range_3);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

range_2=min(dxp):(max(dxp)-min(dxp))/hh:max(dxp);
[N2,X2] = hist(dxp,range_2);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-4E-4 4E-4]);
legend({'Pure', 'Composite', 'MoGr', 'CuCD'},'FontSize',16,'location','northwest');
xlabel('xp [rad]');
ylabel('PDF');
title ('7 TeV Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of y all
figure;
% Number of bins
hh=1000;

range_1=min(y):(max(y)-min(y))/hh:max(y);
[N1,X1] = hist(y,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_gray);
hold on;

range_4=min(cy):(max(cy)-min(cy))/hh:max(cy);
[N4,X4] = hist(cy,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_teal);
hold on;

range_3=min(my):(max(my)-min(my))/hh:max(my);
[N3,X3] = hist(my,range_3);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

range_2=min(dy):(max(dy)-min(dy))/hh:max(dy);
[N2,X2] = hist(dy,range_2);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.01 0.01]);
legend({'Pure', 'Composite', 'MoGr', 'CuCD'},'FontSize',16,'location','northwest');
xlabel('y [m]');
ylabel('PDF');
title ('7 TeV Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of yp all
figure;
% Number of bins
hh=1000;

range_1=min(yp):(max(yp)-min(yp))/hh:max(yp);
[N1,X1] = hist(yp,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_gray);
hold on;

range_4=min(cyp):(max(cyp)-min(cyp))/hh:max(cyp);
[N4,X4] = hist(cyp,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_teal);
hold on;

range_3=min(myp):(max(myp)-min(myp))/hh:max(myp);
[N3,X3] = hist(myp,range_3);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

range_2=min(dyp):(max(dyp)-min(dyp))/hh:max(dyp);
[N2,X2] = hist(dyp,range_2);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-2E-4 2E-4]);
legend({'Pure', 'Composite', 'MoGr', 'CuCD'},'FontSize',16,'location','northwest');
xlabel('yp [rad]');
ylabel('PDF');
title ('7 TeV Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;

%% Plot histogram of dp all
figure;
% Number of bins
hh=1000;

range_1=min(dp):(max(dp)-min(dp))/hh:max(dp);
[N1,X1] = hist(dp,range_1);
stairs(X1,N1,'Linewidth',1, 'Color', c_gray);
hold on;

range_4=min(cdp):(max(cdp)-min(cdp))/hh:max(cdp);
[N4,X4] = hist(cdp,range_4);
stairs(X4,N4,'Linewidth',1, 'Color', c_teal);
hold on;

range_3=min(mdp):(max(mdp)-min(mdp))/hh:max(mdp);
[N3,X3] = hist(mdp,range_3);
stairs(X3,N3,'Linewidth',1, 'Color', c_orange);
hold on;

range_2=min(ddp):(max(ddp)-min(ddp))/hh:max(ddp);
[N2,X2] = hist(ddp,range_2);
stairs(X2,N2,'Linewidth',1, 'Color', c_dodger);
hold on;

grid on;
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.2 0],'YLim',[0 1E5]);
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend({'Pure', 'Composite', 'MoGr', 'CuCD'},'FontSize',16,'location','northwest');
xlabel('dp [GeV]');
ylabel('PDF');
title ('7 TeV Beam 1 TCSG.B5L7.B1 Secondary Material','FontSize',16);
hold off;