%% JawImpact 7 TeV Secondary skew
clearvars all;
%% Import data

% Pure
filename = '/home/HR/Downloads/HL_JI/jaw_impact_TCSG.B5L7.B1_Pure.txt';
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

% Composite
filename = '/home/HR/Downloads/HL_JI/jaw_impact_TCSG.B5L7.B1_Comp.txt';
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
h5=histogram(x), hold on; h5.Normalization = 'pdf'; h5.BinWidth = binwidth; h5.FaceColor = c_orange;
h6=histogram(cx), hold on; h6.Normalization = 'pdf'; h6.BinWidth = binwidth; h6.FaceColor = c_dodger;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([-0.02, 0, 0, 2.5E2]);
legend('Location', 'north', 'Pure', 'Composite');
hold off;

title('Jaw Impact HL-LHC Beam 1 TCSG.B5L7.B1');

subplot(2,2,2)        % add first plot in 2 x 2 grid
h5=histogram(x), hold on; h5.Normalization = 'pdf'; h5.BinWidth = binwidth; h5.FaceColor = c_orange;
h6=histogram(cx), hold on; h6.Normalization = 'pdf'; h6.BinWidth = binwidth; h6.FaceColor = c_dodger;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([0, 0.02, 0, 2.5E2]);
hold off;

% subplot(2,2,3)    % add third plot to span positions 3 and 4
subplot(2,2,[3,4])    % add third plot to span positions 3 and 4
scatter(x, y, 2, c_orange), hold on;
scatter(cx, cy, 2, c_dodger), hold on;
% scatter(x4, y4, 2, c_dodger), hold on;
% scatter(cx4, cy4, 2, c_orange), hold on;
xlabel('x [m]');
ylabel('y [m]');
grid on;
% axis([-1E-2, 1E-2, -1E-2, 1E-2]);
hold off;

%% Plot MoGr CuCD
figure;

binwidth = 1E-4;
binwidth2 = 1E-4;
ngap = 0.00121; % TCLD 8
% ngap = 0.00146; % TCLD 10

% subplot(2,2,1)        % add first plot in 2 x 2 grid
subplot(2,2,1)        % add first plot in 2 x 2 grid
h5=histogram(x), hold on; h5.Normalization = 'pdf'; h5.BinWidth = binwidth; h5.FaceColor = c_gray;
h6=histogram(cx), hold on; h6.Normalization = 'pdf'; h6.BinWidth = binwidth; h6.FaceColor = c_teal;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([-0.02, 0, 0, 2.5E2]);
% legend('Location', 'northwest', 'Pure 6D', 'Comp 6D', 'Pure 4D', 'Comp 4D');
legend('Location', 'north', 'Pure', 'Composite');
% legend('Location', 'northwest', 'Pure 6D', 'Comp 6D');
% legend('Location', 'northwest', 'Pure 4D', 'Comp 4D');
hold off;

title('Jaw Impact 7 TeV Beam 1 TCSG.B5L7.B1');

subplot(2,2,2)        % add first plot in 2 x 2 grid
h5=histogram(x), hold on; h5.Normalization = 'pdf'; h5.BinWidth = binwidth; h5.FaceColor = c_gray;
h6=histogram(cx), hold on; h6.Normalization = 'pdf'; h6.BinWidth = binwidth; h6.FaceColor = c_teal;
xlabel('y [m]');
ylabel('PDF');
grid on;
axis([0, 0.02, 0, 2.5E2]);
hold off;

% subplot(2,2,3)    % add third plot to span positions 3 and 4
subplot(2,2,[3,4])    % add third plot to span positions 3 and 4
scatter(x, y, 2, c_gray), hold on;
scatter(cx, cy, 2, c_teal), hold on;
xlabel('x [m]');
ylabel('y [m]');
grid on;
% axis([-1E-2, 1E-2, -1E-2, 1E-2]);
hold off;

%% Plot Pure Composite
figure;

binwidth = 1E-4;
binwidth2 = 1E-4;
ngap = 0.00121; % TCLD 8
% ngap = 0.00146; % TCLD 10

% subplot(2,2,1)        % add first plot in 2 x 2 grid
subplot(2,2,1)        % add first plot in 2 x 2 grid
h5=histogram(x), hold on; h5.Normalization = 'pdf'; h5.BinWidth = binwidth; h5.FaceColor = c_gray;
h6=histogram(cx), hold on; h6.Normalization = 'pdf'; h6.BinWidth = binwidth; h6.FaceColor = c_teal;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([-0.02, 0, 0, 2.5E2]);
% legend('Location', 'northwest', 'Pure 6D', 'Comp 6D', 'Pure 4D', 'Comp 4D');
legend('Location', 'north', 'Pure', 'Composite');
% legend('Location', 'northwest', 'Pure 6D', 'Comp 6D');
% legend('Location', 'northwest', 'Pure 4D', 'Comp 4D');
hold off;

title('Jaw Impact 7 TeV Beam 1 TCSG.B5L7.B1');

subplot(2,2,2)        % add first plot in 2 x 2 grid
h5=histogram(x), hold on; h5.Normalization = 'pdf'; h5.BinWidth = binwidth; h5.FaceColor = c_gray;
h6=histogram(cx), hold on; h6.Normalization = 'pdf'; h6.BinWidth = binwidth; h6.FaceColor = c_teal;
xlabel('y [m]');
ylabel('PDF');
grid on;
axis([0, 0.02, 0, 2.5E2]);
hold off;

% subplot(2,2,3)    % add third plot to span positions 3 and 4
subplot(2,2,[3,4])    % add third plot to span positions 3 and 4
scatter(x, y, 2, c_gray), hold on;
scatter(cx, cy, 2, c_teal), hold on;
% scatter(mx, my, 2, c_dodger), hold on;
% scatter(dx, dy, 2, c_orange), hold on;
% scatter(x4, y4, 2, c_dodger), hold on;
% scatter(cx4, cy4, 2, c_orange), hold on;
xlabel('x [m]');
ylabel('y [m]');
grid on;
% axis([-1E-2, 1E-2, -1E-2, 1E-2]);
hold off;

%% Plot histogram of dp
figure;
binwidth = 1E-2;
hh=1000;

range_3=min(dp):(max(dp)-min(dp))/hh:max(dp);
[N3,X3] = hist(dp,range_3);
stairs(X3,N3/sum(N3)/(max(dp)-min(dp)/hh ),'Linewidth',1.5, 'Color', c_orange);
hold on;

range_2=min(cdp):(max(cdp)-min(cdp))/hh:max(cdp);
[N2,X2] = hist(cdp,range_2);
stairs(X2,N2/sum(N2)/ (max(cdp)-min(cdp)/hh ),'Linewidth',1.5, 'Color', c_dodger);
hold on;

grid on;
set(gca,'yscale','log','XLim',[-0.2 0],'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
legend('Location', 'northwest', 'Pure', 'Composite');
xlabel('\delta [GeV]');
ylabel('PDF');
title ('Jaw Impact HL-LHC Beam 1 TCSG.B5L7.B1','FontSize',16);
hold off;

