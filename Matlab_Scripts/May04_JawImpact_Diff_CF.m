%% Script to Plot JawImpact from TevHEL runs 04May16

%% Import Diff

filename = '/home/HR/Downloads/04May_TevHEL_Runs/04May_Diff/jaw_impact.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
particle_id = dataArray{:, 1};
x = dataArray{:, 2};
xp = dataArray{:, 3};
y = dataArray{:, 4};
yp = dataArray{:, 5};
ct = dataArray{:, 6};
dp = dataArray{:, 7};
turn = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import Diff Double Current

filename = '/home/HR/Downloads/04May_TevHEL_Runs/04May_Diff_DoubleCurrent/jaw_impact.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
C_particle_id = dataArray{:, 1};
C_x = dataArray{:, 2};
C_xp = dataArray{:, 3};
C_y = dataArray{:, 4};
C_yp = dataArray{:, 5};
C_ct = dataArray{:, 6};
C_dp = dataArray{:, 7};
C_turn = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot relevent data

binwidth = 1E-6;

% figure
subplot(2,2,1)        % add first plot in 2 x 2 grid
h1=histogram(C_x), hold on;
h1.Normalization = 'pdf';
h1.BinWidth = binwidth;
h2=histogram(x), hold on;
h2.Normalization = 'pdf';
h2.BinWidth = binwidth;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([-1.65E-3,-1.59E-3, 0, 2E4]);
legend('Location', 'northwest', 'Diff_{Double Current}', 'Diff');

hold off
subplot(2,2,2)        % add second plot in 2 x 2 grid
h1=histogram(C_x), hold on;
h1.Normalization = 'pdf';
h1.BinWidth = binwidth;
h2=histogram(x), hold on;
h2.Normalization = 'pdf';
h2.BinWidth = binwidth;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([1.59E-3, 1.65E-3, 0, 2E5]);

hold off

subplot(2,2,3)    % add third plot to span positions 3 and 4
scatter(C_x, C_y, 2, c_dodger), hold on;
scatter(x, y, 2, c_orange), hold on;
xlabel('x [m]');
ylabel('y [m]');
grid on;
axis([-1.65E-3, -1.59E-3, -1E-3, 1E-3]);

subplot(2,2,4)    % add third plot to span positions 3 and 4
scatter(C_x, C_y, 2, c_dodger), hold on;
scatter(x, y, 2, c_orange), hold on;
xlabel('x [m]');
ylabel('y [m]');
grid on;
axis([1.59E-3, 1.65E-3, -1E-3, 1E-3]);



%% Finalise Plot

% xlabel('x [m]');
% ylabel('y [m]');
% grid on;
% axis([-2E-3, 2E-3, -1E-3, 1E-3]);

hold off

