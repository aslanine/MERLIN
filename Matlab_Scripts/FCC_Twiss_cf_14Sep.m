%% Plot Lattice Functions and Dispersion for MERLIN and MADX FCC

clearvars all;

%% Import TWISS No Crossing
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_NoCrossing_Lattice.tfs';
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

%% Import TWISS Crossing
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_Crossing_Lattice.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
% S_name = dataArray{:, 1};
% S_label = dataArray{:, 2};
C_s = dataArray{:, 3};
% S_L = dataArray{:, 4};
C_betax = dataArray{:, 18};
C_betay = dataArray{:, 19};
C_alphax = dataArray{:, 20};
C_alphay = dataArray{:, 21};
% S_mux = dataArray{:, 22};
% S_muy = dataArray{:, 23};
C_Dx = dataArray{:, 24};
C_Dy = dataArray{:, 25};
% S_Dxp = dataArray{:, 26};
% S_Dyp = dataArray{:, 27};
C_x = dataArray{:, 32};
% S_xp = dataArray{:, 33};
C_y = dataArray{:, 34};
% S_yp = dataArray{:, 35};
% S_ct = dataArray{:, 36};
% S_dp = dataArray{:, 37};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import LatticeFunctionTable No Crossing

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/14_Sep_Crossing/LatticeFunctions/LatticeFunctions_noX.dat';
formatSpec = '%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

% Allocate imported array to column variable names
s = dataArray{:, 1};
x = dataArray{:, 2};
% xp = dataArray{:, 3};
y = dataArray{:, 4};
% yp = dataArray{:, 5};
% mu_x_frac = dataArray{:, 6};
% mu_y_frac = dataArray{:, 7};
betax = dataArray{:, 8};
% Alpha_x = dataArray{:, 9};
betay = dataArray{:, 10};
% Alpha_y = dataArray{:, 11};
% D_x_EF = dataArray{:, 12};      % D_x * Energy scaling factor
% D_xp_EF = dataArray{:, 13};      
% D_y_EF = dataArray{:, 14};      % D_y * Energy scaling factor
% D_yp_EF = dataArray{:, 15};
% EF = dataArray{:, 16};          % Energy scaling factor
% Dx_lf = dataArray{:, 12} / dataArray{:, 16};
% Dy_lf = dataArray{:, 14} / dataArray{:, 16};
% Perform operations

% Dx_lf = D_x_EF / EF;
% Dy_lf = D_y_EF / EF;
% D_xp = D_xp_EF / EF;
% D_yp = D_yp_EF / EF;

% Alpha_x = -1 .* Alpha_x;
% Alpha_y = -1 .* Alpha_y;

clearvars filename formatSpec fileID dataArray ans;

%% Import LatticeFunctionTable Crossing

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/14_Sep_Crossing/LatticeFunctions/LatticeFunctions_noX.dat';
formatSpec = '%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

% Allocate imported array to column variable names
cs = dataArray{:, 1};
cx = dataArray{:, 2};
% xp = dataArray{:, 3};
cy = dataArray{:, 4};
% yp = dataArray{:, 5};
% mu_x_frac = dataArray{:, 6};
% mu_y_frac = dataArray{:, 7};
cbetax = dataArray{:, 8};
% Alpha_x = dataArray{:, 9};
cbetay = dataArray{:, 10};
% Alpha_y = dataArray{:, 11};
% D_x_EF = dataArray{:, 12};      % D_x * Energy scaling factor
% D_xp_EF = dataArray{:, 13};      
% D_y_EF = dataArray{:, 14};      % D_y * Energy scaling factor
% D_yp_EF = dataArray{:, 15};
% EF = dataArray{:, 16};          % Energy scaling factor
% Dx_lf = dataArray{:, 12} / dataArray{:, 16};
% Dy_lf = dataArray{:, 14} / dataArray{:, 16};
% Perform operations

% Dx_lf = D_x_EF / EF;
% Dy_lf = D_y_EF / EF;
% D_xp = D_xp_EF / EF;
% D_yp = D_yp_EF / EF;

% Alpha_x = -1 .* Alpha_x;
% Alpha_y = -1 .* Alpha_y;

clearvars filename formatSpec fileID dataArray ans;

%% Import Dispersion No Crossing

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/14_Sep_Crossing/LatticeFunctions/Dispersion_noX.dat';
formatSpec = '%14f%14f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
S_D = dataArray{:, 1};
Dx = dataArray{:, 2};
Dy = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;


%% Import Dispersion Crossing

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/14_Sep_Crossing/LatticeFunctions/Dispersion_X.dat';
formatSpec = '%14f%14f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
cS_D = dataArray{:, 1};
cDx = dataArray{:, 2};
cDy = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;

%% Multiple Plots

% xlimits full
% xmin = 0;
% xmax = 101000;

% xlimits zoom start
% xmin = 0;
% xmax = 100;

% IPA - IPB
xmin = 0;
xmax = 7000;

%% Plots with all X and noX

% Plot beta x
figure;

plot(s, betax, '-', cs, cbetax, '-.', M_s, M_betax, '--', C_s, C_betax, ':','Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN X', 'MERLIN noX', 'MADX noX','MADX X');
ylabel('\beta_x [m]');
xlabel('s [m]');
grid on;

% Plot beta y
figure;

plot(s, betay, '-', cs, cbetay, '-.', M_s, M_betay, '--', C_s, C_betay, ':', 'Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN X', 'MERLIN noX', 'MADX noX','MADX X');
ylabel('\beta_y [m]');
xlabel('s [m]');
grid on;

% Plot Dx
figure;

% plot(S_D, Dx, '-', M_s, M_Dx, ':', s, Dx_lf, '--','Linewidth',1.5);
plot(S_D, Dx, '-', cS_D, cDx, '-.', M_s, M_Dx, '--', C_s, C_Dx, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('MERLIN X', 'MERLIN noX', 'MADX noX','MADX X');
ylabel('D_x [m]');
xlabel('s [m]');
grid on;

% Plot Dy
figure;

% plot(S_D, Dy, '-', M_s, M_Dy, ':', s, Dy_lf, '--','Linewidth',1.5);
plot(S_D, Dy, '-', cS_D, cDy, '-.', M_s, M_Dy, '--', C_s, C_Dy, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('MERLIN X', 'MERLIN noX', 'MADX noX','MADX X');
ylabel('D_y [m]');
xlabel('s [m]');
grid on;

% Plot x
figure;

plot(s, x, '-', cs, cx, '-.', M_s, M_x, '--', C_s, C_x, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN X', 'MERLIN noX', 'MADX noX','MADX X');
ylabel('x [m]');
xlabel('s [m]');
grid on;

% Plot y
figure;

plot(s, y, '-', cs, cy, '-.', M_s, M_y, '--', C_s, C_y, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN X', 'MERLIN noX', 'MADX noX','MADX X');
ylabel('y [m]');
xlabel('s [m]');
grid on;

hold off;

%% Crossing only

% Plot beta x
figure;

plot(cs, cbetax, '-',C_s, C_betax, ':','Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN X','MADX X');
ylabel('\beta_x [m]');
xlabel('s [m]');
grid on;

% Plot beta y
figure;

plot(cs, cbetay, '-', C_s, C_betay, ':', 'Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN X','MADX X');
ylabel('\beta_y [m]');
xlabel('s [m]');
grid on;

% Plot Dx
figure;

% plot(S_D, Dx, '-', M_s, M_Dx, ':', s, Dx_lf, '--','Linewidth',1.5);
plot(cS_D, cDx, '-',C_s, C_Dx, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('MERLIN X','MADX X');
ylabel('D_x [m]');
xlabel('s [m]');
grid on;

% Plot Dy
figure;

% plot(S_D, Dy, '-', M_s, M_Dy, ':', s, Dy_lf, '--','Linewidth',1.5);
plot(cS_D, cDy, '-', C_s, C_Dy, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('MERLIN X','MADX X');
ylabel('D_y [m]');
xlabel('s [m]');
grid on;

% Plot x
figure;

plot(cs, cx, '-', C_s, C_x, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN X', 'MADX X');
ylabel('x [m]');
xlabel('s [m]');
grid on;

% Plot y
figure;

plot(cs, cy, '-', C_s, C_y, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN X','MADX X');
ylabel('y [m]');
xlabel('s [m]');
grid on;

hold off;

%% No Crossing only 

% Plot beta x
figure;

plot(s, betax, '-', M_s, M_betax, ':','Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN noX', 'MADX noX');
ylabel('\beta_x [m]');
xlabel('s [m]');
grid on;

% Plot beta y
figure;

plot(s, betay, '-', M_s, M_betay, ':', 'Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN noX', 'MADX noX');
ylabel('\beta_y [m]');
xlabel('s [m]');
grid on;

% Plot Dx
figure;

% plot(S_D, Dx, '-', M_s, M_Dx, ':', s, Dx_lf, '--','Linewidth',1.5);
plot(S_D, Dx, '-', M_s, M_Dx, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('MERLIN noX', 'MADX noX');
ylabel('D_x [m]');
xlabel('s [m]');
grid on;

% Plot Dy
figure;

% plot(S_D, Dy, '-', M_s, M_Dy, ':', s, Dy_lf, '--','Linewidth',1.5);
plot(S_D, Dy, '-',M_s, M_Dy, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('MERLIN noX', 'MADX noX');
ylabel('D_y [m]');
xlabel('s [m]');
grid on;

% Plot x
figure;

plot(s, x, '-', M_s, M_x, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN noX', 'MADX noX');
ylabel('x [m]');
xlabel('s [m]');
grid on;

% Plot y
figure;

plot(s, y, '-', M_s, M_y, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('MERLIN noX', 'MADX noX');
ylabel('y [m]');
xlabel('s [m]');
grid on;

hold off;
