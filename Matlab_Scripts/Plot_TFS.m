%% Plot TFS tables to compare two TWISS files


%% Read TWISS file for MERLIN

filename = '/home/HR/Downloads/SixTrack_Twiss/HEL_THIN.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
% S_name = dataArray{:, 1};
% S_label = dataArray{:, 2};
M_s = dataArray{:, 3};
% S_L = dataArray{:, 4};
M_betax = dataArray{:, 18};
M_betay = dataArray{:, 19};
M_alphax = dataArray{:, 20};
M_alphay = dataArray{:, 21};
% S_mux = dataArray{:, 22};
% S_muy = dataArray{:, 23};
M_Dx = dataArray{:, 24};
M_Dy = dataArray{:, 25};
% S_Dxp = dataArray{:, 26};
% S_Dyp = dataArray{:, 27};
M_x = dataArray{:, 32};
% S_xp = dataArray{:, 33};
M_y = dataArray{:, 34};
% S_yp = dataArray{:, 35};
% S_ct = dataArray{:, 36};
% S_dp = dataArray{:, 37};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Read TWISS file for SixTrack?

filename = '/home/HR/Downloads/SixTrack_Twiss/twiss.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
% S_name = dataArray{:, 1};
% S_label = dataArray{:, 2};
S_s = dataArray{:, 3};
% S_L = dataArray{:, 4};
S_betax = dataArray{:, 18};
S_betay = dataArray{:, 19};
S_alphax = dataArray{:, 20};
S_alphay = dataArray{:, 21};
% S_mux = dataArray{:, 22};
% S_muy = dataArray{:, 23};
S_Dx = dataArray{:, 24};
S_Dy = dataArray{:, 25};
% S_Dxp = dataArray{:, 26};
% S_Dyp = dataArray{:, 27};
S_x = dataArray{:, 32};
% S_xp = dataArray{:, 33};
S_y = dataArray{:, 34};
% S_yp = dataArray{:, 35};
% S_ct = dataArray{:, 36};
% S_dp = dataArray{:, 37};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% SUBPLOTS
figure;

% Whole LHC
% xmin = 0;
% xmax = 26659;
xmin = 13200;
xmax = 13500;
betamin = 0;
betamax =  6000;

% dmin = -4;
% dmax = 4;
% comin = -0.02;
% comax = 0.02;

dmin = 0;
dmax = 6000;
comin = -200;
comax = 200;

% HEL Zoom
% xmin = 9900;
% xmax = 10000;
% betamin = 150;
% betamax = 400;
% dmin = -0.5;
% dmax = 0.5;
% comin = -1E-2;
% comax = 1E-2;


%% Beta_x plot
subplot(3,1,1);
title('Beta Functions');

%% Plot Betas
beta_plots = plot(S_s, S_betax,'-', M_s, M_betax, '-');
hold on;
beta_legend = legend(beta_plots(),'Twiss Beta_x', 'MERLIN Twiss Beta_x');
hold on;
set(beta_legend,'color','none');
% axis([xmin,xmax,betamin,betamax]);
xlabel('s [m]');
ylabel('Beta [m]');

% Lines for HELs and IP4
% line([9908.405 9908.405],[-1E5 1E5], 'color', 'k'); hold on;
% line([9967.005 9967.005],[-1E5 1E5], 'color', 'k'); hold on;
% line([9997.005 9997.005],[-1E5 1E5], 'color', 'k'); hold on;

hold off;

%% Dispersion_x Plot
subplot(3,1,2);
title('Dispersion');

%% Plot Dispersion
% Disp_plots = plot(S_s, S_Dx, '-', M_s, M_Dx, ':');
% hold on;
% disp_legend = legend(Disp_plots(),'Twiss D_x','MERLIN Twiss D_x');

Disp_plots = plot(S_s, S_betay, '-', M_s, M_betay, '-');
hold on;
disp_legend = legend(Disp_plots(),'Twiss Beta_y','MERLIN Twiss Beta_y');

hold on;
set(disp_legend,'color','none');
% axis([xmin, xmax, dmin, dmax]);
xlabel('s [m]');
% ylabel('D [m]');
ylabel('Beta [m]');

% Lines for HELs and IP4
% line([9908.405 9908.405],[-1E5 1E5], 'color', 'k');
% line([9967.005 9967.005],[-1E5 1E5], 'color', 'k');
% line([9997.005 9997.005],[-1E5 1E5], 'color', 'k');

hold off;

%% Closed Orbit Plot
subplot(3,1,3);
title('Closed Orbit x');

%% Plot Closed Orbit
% co_plots = plot(S_s, S_x, '-', M_s, M_x, ':');
% hold on;
% co_legend = legend(co_plots(),'Twiss x','MERLIN Twiss x');

co_plots = plot(S_s, S_alphax, '-', M_s, M_alphax, '-');
hold on;
co_legend = legend(co_plots(),'Twiss Alpha_x','MERLIN Alpha_x');

hold on;
set(co_legend,'color','none');
% axis([xmin, xmax, comin, comax]);
xlabel('s [m]');
% ylabel('diplacement [m]');
ylabel('Alpha [-]');

% Lines for HELs and IP4
% line([9908.405 9908.405],[-1E5 1E5], 'color', 'k');
% line([9967.005 9967.005],[-1E5 1E5], 'color', 'k');
% line([9997.005 9997.005],[-1E5 1E5], 'color', 'k');

hold off;

%% Clean up
clear all;
