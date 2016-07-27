%% JawImpact 6.5 TeV Secondary skew
clearvars all;
%% Import data

% Pure
filename = '/home/HR/Downloads/65_JawImpact/jaw_impact_TCSG.B5L7.B2_Pure.txt';
delimiter = {'          ','          ','        ','       ','      ','     ','    ','   ','  ','\t',' '};
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
x = dataArray{:, 1};
xp = dataArray{:, 2};
y = dataArray{:, 3};
yp = dataArray{:, 4};
ct = dataArray{:, 5};
dp = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Comp
filename = '/home/HR/Downloads/65_JawImpact/jaw_impact_TCSG.B5L7.B2_Comp.txt';
delimiter = {'          ','          ','        ','       ','      ','     ','    ','   ','  ','\t',' '};
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
cx = dataArray{:, 1};
cxp = dataArray{:, 2};
cy = dataArray{:, 3};
cyp = dataArray{:, 4};
cct = dataArray{:, 5};
cdp = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Pure 4D
filename = '/home/HR/Downloads/65_JawImpact/jaw_impact_TCSG.B5L7.B2_Pure4D.txt';
delimiter = {'          ','          ','        ','       ','      ','     ','    ','   ','  ','\t',' '};
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
x4 = dataArray{:, 1};
xp4 = dataArray{:, 2};
y4 = dataArray{:, 3};
yp4 = dataArray{:, 4};
ct4 = dataArray{:, 5};
dp4 = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Comp 4D
filename = '/home/HR/Downloads/65_JawImpact/jaw_impact_TCSG.B5L7.B2_Comp4D.txt';
delimiter = {'          ','          ','        ','       ','      ','     ','    ','   ','  ','\t',' '};
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
cx4 = dataArray{:, 1};
cxp4 = dataArray{:, 2};
cy4 = dataArray{:, 3};
cyp4 = dataArray{:, 4};
cct4 = dataArray{:, 5};
cdp4 = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Pure Transport
filename = '/home/HR/Downloads/65_JawImpact/jaw_impact_TCSG.B5L7.B2_PureTrans.txt';
delimiter = {'          ','          ','        ','       ','      ','     ','    ','   ','  ','\t',' '};
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
xt = dataArray{:, 1};
xpt = dataArray{:, 2};
yt = dataArray{:, 3};
ypt = dataArray{:, 4};
ctt = dataArray{:, 5};
dpt = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Comp Transport
filename = '/home/HR/Downloads/65_JawImpact/jaw_impact_TCSG.B5L7.B2_CompTrans.txt';
delimiter = {'          ','          ','        ','       ','      ','     ','    ','   ','  ','\t',' '};
startRow = 2;
formatSpec = '%*s%f%f%f%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
cxt = dataArray{:, 1};
cxpt = dataArray{:, 2};
cyt = dataArray{:, 3};
cypt = dataArray{:, 4};
cctt = dataArray{:, 5};
cdpt = dataArray{:, 6};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot relevent data
figure;

binwidth = 1E-4;
binwidth2 = 1E-4;
ngap = 0.00121; % TCLD 8
% ngap = 0.00146; % TCLD 10

% subplot(2,2,1)        % add first plot in 2 x 2 grid
subplot(2,2,1)        % add first plot in 2 x 2 grid
h5=histogram(xt), hold on; h5.Normalization = 'pdf'; h5.BinWidth = binwidth; h5.FaceColor = c_gray;
h6=histogram(cxt), hold on; h6.Normalization = 'pdf'; h6.BinWidth = binwidth; h6.FaceColor = 'b';
% h3=histogram(x), hold on; h3.Normalization = 'pdf'; h3.BinWidth = binwidth; h3.FaceColor = 'k';
% h1=histogram(cx), hold on; h1.Normalization = 'pdf'; h1.BinWidth = binwidth; h1.FaceColor = 'r';
% h2=histogram(x4), hold on; h2.Normalization = 'pdf'; h2.BinWidth = binwidth; h2.FaceColor = c_dodger;
% h4=histogram(cx4), hold on; h4.Normalization = 'pdf'; h4.BinWidth = binwidth; h4.FaceColor = c_orange;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([-5E-3, 5E-3, 0, 5E2]);
% legend('Location', 'northwest', 'Pure 6D', 'Comp 6D', 'Pure 4D', 'Comp 4D');
legend('Location', 'north', 'Pure 6D Trans', 'Comp 6D Trans');
% legend('Location', 'northwest', 'Pure 6D', 'Comp 6D');
% legend('Location', 'northwest', 'Pure 4D', 'Comp 4D');
hold off;

title('Jaw Impact 6.5 TeV Beam 2 TCSG.B5L7.B2');

subplot(2,2,2)        % add first plot in 2 x 2 grid
h5=histogram(yt), hold on; h5.Normalization = 'pdf'; h5.BinWidth = binwidth; h5.FaceColor = c_gray;
h6=histogram(cyt), hold on; h6.Normalization = 'pdf'; h6.BinWidth = binwidth; h6.FaceColor = 'b';
% h3=histogram(y), hold on; h3.Normalization = 'pdf'; h3.BinWidth = binwidth; h3.FaceColor = 'k';
% h1=histogram(cy), hold on; h1.Normalization = 'pdf'; h1.BinWidth = binwidth; h1.FaceColor = 'r';
% h2=histogram(y4), hold on; h2.Normalization = 'pdf'; h2.BinWidth = binwidth; h2.FaceColor = c_dodger;
% h4=histogram(cy4), hold on; h4.Normalization = 'pdf'; h4.BinWidth = binwidth; h4.FaceColor = c_orange;
xlabel('y [m]');
ylabel('PDF');
grid on;
axis([-5E-3, 5E-3, 0, 5E2]);
hold off;

% subplot(2,2,2)        % add second plot in 2 x 2 grid
% h3=histogram(x), hold on; h3.Normalization = 'pdf'; h3.BinWidth = binwidth; h3.FaceColor = 'k';
% h1=histogram(cx), hold on; h1.Normalization = 'pdf'; h1.BinWidth = binwidth; h1.FaceColor = 'r';
% h2=histogram(x4), hold on; h2.Normalization = 'pdf'; h2.BinWidth = binwidth; h2.FaceColor = c_dodger;
% h4=histogram(cx4), hold on; h4.Normalization = 'pdf'; h4.BinWidth = binwidth; h4.FaceColor = c_orange;
% xlabel('x [m]');
% ylabel('PDF');
% grid on;
% axis([-5E-3, 2E-2, 0, 5E2]);
% hold off;

% subplot(2,2,3)    % add third plot to span positions 3 and 4
subplot(2,2,[3,4])    % add third plot to span positions 3 and 4
scatter(xt, yt, 2, c_gray), hold on;
scatter(cxt, cyt, 2, 'b'), hold on;
% scatter(x, y, 2, 'k'), hold on;
% scatter(cx, cy, 2, 'r'), hold on;
% scatter(x4, y4, 2, c_dodger), hold on;
% scatter(cx4, cy4, 2, c_orange), hold on;
xlabel('x [m]');
ylabel('y [m]');
grid on;
axis([-1E-2, 1E-2, -1E-2, 1E-2]);
hold off;

% subplot(2,2,4)    % add third plot to span positions 3 and 4
% scatter(x, y, 2, 'k'), hold on;
% scatter(cx, cy, 2, 'r'), hold on;
% scatter(x4, y4, 2, c_dodger), hold on;
% scatter(cx4, cy4, 2, c_orange), hold on;
% xlabel('x [m]');
% ylabel('y [m]');
% grid on;
% axis([-5E-3, 2E-2, -2E-2, 1E-2]);
% hold off;

%% Plot histogram of dp
figure;
binwidth = 1E-2;
hh=1000;

range_3=min(dp):(max(dp)-min(dp))/hh:max(dp);
[N3,X3] = hist(dp,range_3);
stairs(X3,N3/sum(N3)/(max(dp)-min(dp)/hh ),'Linewidth',1.5, 'Color', 'k');
hold on;

range_2=min(cdp):(max(cdp)-min(cdp))/hh:max(cdp);
[N2,X2] = hist(cdp,range_2);
stairs(X2,N2/sum(N2)/ (max(cdp)-min(cdp)/hh ),'Linewidth',1.5, 'Color', 'r');
hold on;

range_1=min(dp4):(max(dp4)-min(dp4))/hh:max(dp4);
[N1,X1] = hist(dp4,range_1);
stairs(X1,N1/sum(N1)/(max(dp4)-min(dp4)/hh ),'Linewidth',1.5, 'Color', c_dodger);
hold on;

range_4=min(cdp4):(max(cdp4)-min(cdp4))/hh:max(cdp4);
[N4,X4] = hist(cdp4,range_4);
stairs(X4,N4/sum(N4)/ (max(cdp4)-min(cdp4)/hh ),'Linewidth',1.5, 'Color', c_orange);
hold on;

range_5=min(dpt):(max(dpt)-min(dpt))/hh:max(dpt);
[N5,X5] = hist(dpt,range_5);
stairs(X5,N5/sum(N5)/(max(dpt)-min(dpt)/hh ),'Linewidth',1.5, 'Color', c_gray);
hold on;

range_6=min(cdpt):(max(cdpt)-min(cdpt))/hh:max(cdpt);
[N6,X6] = hist(cdpt,range_6);
stairs(X6,N6/sum(N6)/ (max(cdpt)-min(cdpt)/hh ),'Linewidth',1.5, 'Color', 'b');
hold on;

grid on;
set(gca,'yscale','log','XLim',[-0.02 0],'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend('Location', 'northwest', 'Pure 6D', 'Comp 6D', 'Pure 4D', 'Comp 4D');
legend('Location', 'northwest', 'Pure 6D', 'Comp 6D', 'Pure 4D', 'Comp 4D', 'Pure 6D Trans', 'Comp 6D Trans');
xlabel('\delta [GeV]');
ylabel('PDF');
title ('Jaw Impact 6.5 TeV Beam 2 TCSG.B5L7.B2','FontSize',16);
hold off;
