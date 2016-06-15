%% Script to Plot and compare JawImpact from HL Loss Maps for novel materials 13Jun16

%% Composite TCLD 8
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/13June_HL_JawImpact/jaw_impact_TCLD.8R7.B1_Composite.txt';
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/13June_HL_JawImpact/jaw_impact_TCLD.10R7.B1_Composite.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%*s%f%*s%f%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
P_x = dataArray{:, 1};
P_y = dataArray{:, 2};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% CuCD TCLD 8
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/13June_HL_JawImpact/jaw_impact_TCLD.8R7.B1_CuCD.txt';
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/13June_HL_JawImpact/jaw_impact_TCLD.10R7.B1_CuCD.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%*s%f%*s%f%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
C_x = dataArray{:, 1};
C_y = dataArray{:, 2};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% MoGr TCLD 8
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/13June_HL_JawImpact/jaw_impact_TCLD.8R7.B1_MoGr.txt';
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/PLOTS/13June_HL_JawImpact/jaw_impact_TCLD.10R7.B1_MoGr.txt';
delimiter = {'\t',' '};
startRow = 2;
formatSpec = '%*s%f%*s%f%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
M_x = dataArray{:, 1};
M_y = dataArray{:, 2};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot relevent data

binwidth = 1E-4;
binwidth2 = 1E-4;
ngap = 0.00121; % TCLD 8
% ngap = 0.00146; % TCLD 10

% figure
subplot(2,2,1)        % add first plot in 2 x 2 grid
h3=histogram(P_x), hold on; h3.Normalization = 'pdf'; h3.BinWidth = binwidth; h3.FaceColor = c_gray;
h1=histogram(M_x), hold on; h1.Normalization = 'pdf'; h1.BinWidth = binwidth; h1.FaceColor = c_orange;
h2=histogram(C_x), hold on; h2.Normalization = 'pdf'; h2.BinWidth = binwidth; h2.FaceColor = c_dodger;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([-16E-3, -1E-3, 0, 1E3]);
% axis([-1E-4, 0, 0, 1E5]);
legend('Location', 'northwest', 'Composite', 'CuCD', 'MoGr');

hold off
subplot(2,2,2)        % add second plot in 2 x 2 grid
h3=histogram(P_x), hold on; h3.Normalization = 'pdf'; h3.BinWidth = binwidth2; h3.FaceColor = c_gray;
h1=histogram(M_x), hold on; h1.Normalization = 'pdf'; h1.BinWidth = binwidth2; h1.FaceColor = c_orange;
h2=histogram(C_x), hold on; h2.Normalization = 'pdf'; h2.BinWidth = binwidth2; h2.FaceColor = c_dodger;
xlabel('x [m]');
ylabel('PDF');
grid on;
axis([1E-3, 5E-3, 0, 0.2E3]);

hold off

subplot(2,2,3)    % add third plot to span positions 3 and 4
scatter(P_x, P_y, 2, c_gray), hold on;
scatter(M_x, M_y, 2, c_orange), hold on;
scatter(C_x, C_y, 2, c_dodger), hold on;
line([-ngap -ngap],[-1 1]), hold on
xlabel('x [m]');
ylabel('y [m]');
grid on;
axis([-16E-3, -1E-3, -3E-3, 3E-3]);
% axis([-1E-4, 0, -5E-5, 5E-5]);

subplot(2,2,4)    % add third plot to span positions 3 and 4
scatter(P_x, P_y, 2, c_gray), hold on;
scatter(M_x, M_y, 2, c_orange), hold on;
scatter(C_x, C_y, 2, c_dodger), hold on;
line([ngap ngap],[-1 1]), hold on
xlabel('x [m]');
ylabel('y [m]');
grid on;
axis([1E-3, 5E-3, -3E-3, 3E-3]);



%% Finalise Plot

% xlabel('x [m]');
% ylabel('y [m]');
% grid on;
% axis([-2E-3, 2E-3, -1E-3, 1E-3]);

hold off