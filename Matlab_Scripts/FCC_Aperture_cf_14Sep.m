%% Script to plot ApertureTest
clearvars all;

%% Import No Crossing Aperture File

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_NoCrossing_Aperture.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%*q%*q%*q%f%f%f%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
cS = dataArray{:, 1};
cL = dataArray{:, 2};
cAp = dataArray{:, 3};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

caperture = [cS cAp];


%% Import Crossing Aperture File

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_Crossing_Aperture.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%*q%*q%*q%f%f%f%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
S = dataArray{:, 1};
L = dataArray{:, 2};
Ap = dataArray{:, 3};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

aperture = [S Ap];

%% Import ApertureSurvey No Crossing
apdirname = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/14_Sep_Crossing/';
% original
apfile = 'Aperture_noX.txt';
apfilename = strcat(apdirname,apfile);
delimiter = '\t';
startRow = 2;
formatSpec = '%s%s%f%f%f%f%f%f%[^\n\r]';
apfileID = fopen(apfilename,'r');
dataArray = textscan(apfileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(apfileID);
% ap_name = dataArray{:, 1};
% ap_type = dataArray{:, 2};
ap_s = dataArray{:, 3};
% ap_length1 = dataArray{:, 4};
ap_px = dataArray{:, 5};
ap_mx = dataArray{:, 6};
ap_py = dataArray{:, 7};
ap_my = dataArray{:, 8};
clearvars apfilename delimiter startRow formatSpec apfileID dataArray ans apdirname apfile;

%% Import ApertureSurvey Crossing
apdirname = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/14_Sep_Crossing/';
% original
apfile = 'Aperture_X.txt';
apfilename = strcat(apdirname,apfile);
delimiter = '\t';
startRow = 2;
formatSpec = '%s%s%f%f%f%f%f%f%[^\n\r]';
apfileID = fopen(apfilename,'r');
dataArray = textscan(apfileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(apfileID);
% cap_name = dataArray{:, 1};
% cap_type = dataArray{:, 2};
cap_s = dataArray{:, 3};
% cap_length1 = dataArray{:, 4};
cap_px = dataArray{:, 5};
cap_mx = dataArray{:, 6};
cap_py = dataArray{:, 7};
cap_my = dataArray{:, 8};
clearvars apfilename delimiter startRow formatSpec apfileID dataArray ans apdirname apfile;

%% Remove 0 values from aperture file

index = find(Ap);
total = horzcat(S, Ap);
total = total(index,:);

cindex = find(cAp);
ctotal = horzcat(cS, cAp);
ctotal = ctotal(cindex,:);

%% Plotting axes

% IPA
%minx = 0;
% maxx = 600;

% Full
minx = 0;
maxx = 100000;

% IPA left
%minx = 99570;
%maxx = 100170;

%% Plot No Crossing

% Plot Aperture File
figure;
% circle top
plot(total(:,1),-total(:,2), 'Color', 'red'), hold on
% circle bottom
plot(total(:,1),total(:,2), 'Color', 'blue'), hold on

% Plot Aperture Survey

% Horizontal Aperture
plot(ap_s, ap_px, '--', 'Color', 'black'), hold on
plot(ap_s, -ap_mx, '--' ,'Color', 'green'), hold on

% Vertical Aperture
%plot(ap_s, ap_py, '--' , 'Color', 'black'), hold on
%plot(ap_s, -ap_my, '--' ,'Color', 'green'), hold on

axis([minx,maxx,-0.1,0.1])
% legend({'MERLIN noX','MERLIN noX','MERLIN X','MERLIN X'}, 'location', 'northwest');
legend({'MERLIN noX','MERLIN noX','MERLIN X','MERLIN X'}, 'location', 'southeast');
ylabel('x [m]');
xlabel('s [m]');
grid on;

hold off

%% Plot Crossing

% Plot Aperture File
figure;
% circle top
plot(ctotal(:,1),-ctotal(:,2), 'Color', 'red'), hold on
% circle bottom
plot(ctotal(:,1),ctotal(:,2), 'Color', 'blue'), hold on

% Plot Aperture Survey

% Horizontal Aperture
plot(cap_s, cap_px, '--', 'Color', 'black'), hold on
plot(cap_s, -cap_mx, '--' ,'Color', 'green'), hold on

% Vertical Aperture
%plot(cap_s, cap_py, '--' , 'Color', 'black'), hold on
%plot(cap_s, -cap_my, '--' ,'Color', 'green'), hold on

axis([minx,maxx,-0.1,0.1])
% legend({'MERLIN noX','MERLIN noX','MERLIN X','MERLIN X'}, 'location', 'northwest');
legend({'MERLIN noX','MERLIN noX','MERLIN X','MERLIN X'}, 'location', 'southeast');
ylabel('x [m]');
xlabel('s [m]');
grid on;

hold off


%% Plot Crossing vs No Crossing MADX

% Plot Aperture File
figure;
% circle top
plot(ctotal(:,1),-ctotal(:,2), 'Color', 'black'), hold on
% circle bottom
plot(ctotal(:,1),ctotal(:,2), 'Color', 'black'), hold on

% circle top
plot(total(:,1),-total(:,2), ':', 'Color', 'red'), hold on
% circle bottom
plot(total(:,1),total(:,2), ':',  'Color', 'red'), hold on

axis([minx,maxx,-0.1,0.1])
% legend({'MERLIN noX','MERLIN noX','MERLIN X','MERLIN X'}, 'location', 'northwest');
legend({'MERLIN noX','MERLIN noX','MERLIN X','MERLIN X'}, 'location', 'southeast');
ylabel('x [m]');
xlabel('s [m]');
grid on;

hold off


%% Plot Crossing vs No Crossing MERLIN

% Plot Aperture File
figure;

% Horizontal Aperture
plot(cap_s, cap_px, '-', 'Color', 'black'), hold on
plot(cap_s, -cap_mx, '-' ,'Color', 'black'), hold on

plot(ap_s, ap_px, ':', 'Color', 'red'), hold on
plot(ap_s, -ap_mx, ':' ,'Color', 'red'), hold on

% Vertical Aperture
%plot(cap_s, cap_py, '--' , 'Color', 'black'), hold on
%plot(cap_s, -cap_my, '--' ,'Color', 'green'), hold on

axis([minx,maxx,-0.1,0.1])
% legend({'MERLIN noX','MERLIN noX','MERLIN X','MERLIN X'}, 'location', 'northwest');
legend({'MERLIN noX','MERLIN noX','MERLIN X','MERLIN X'}, 'location', 'southeast');
ylabel('x [m]');
xlabel('s [m]');
grid on;

hold off