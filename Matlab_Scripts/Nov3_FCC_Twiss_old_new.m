%% Plot Lattice Functions and Dispersion CF new and old L* = 45 [m] FCC-hh lattice

clearvars all;

%% Import TWISS CROSSING
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_NoCrossing_Lattice.tfs';
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_Lattice.tfs';
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


%% Import TWISS No Crossing
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Lattice_0300_NoCrossing.tfs';
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Lattice_0300_Crossing.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
% S_name = dataArray{:, 1};
% S_label = dataArray{:, 2};
N_s_2 = dataArray{:, 3};
N_s = N_s_2 - 1300.3553;
% S_L = dataArray{:, 4};
N_betax = dataArray{:, 18};
N_betay = dataArray{:, 19};
N_alphax = dataArray{:, 20};
N_alphay = dataArray{:, 21};
% S_mux = dataArray{:, 22};
% S_muy = dataArray{:, 23};
N_Dx = dataArray{:, 24};
N_Dy = dataArray{:, 25};
% S_Dxp = dataArray{:, 26};
% S_Dyp = dataArray{:, 27};
N_x = dataArray{:, 32};
% S_xp = dataArray{:, 33};
N_y = dataArray{:, 34};
% S_yp = dataArray{:, 35};
% S_ct = dataArray{:, 36};
% S_dp = dataArray{:, 37};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;



%% Multiple Plots

% xlimits full
% xmin = 0;
% xmax = 101000;

% xlimits zoom start
% xmin = 0;
% xmax = 100;

% IPA - IPB
xmin = 0;
xmax = 5000;

%% Plot beta x
figure;

plot(C_s, C_betax, '-', N_s, N_betax, ':','Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('Old','New');
ylabel('\beta_x [m]');
xlabel('s [m]');
grid on;

%% Plot beta y
figure;

plot(C_s, C_betay, '-', N_s, N_betay, ':','Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('Old','New');
ylabel('\beta_y [m]');
xlabel('s [m]');
grid on;

%% Plot Dx
figure;

% plot(S_D, Dx, '-', M_s, M_Dx, ':', s, Dx_lf, '--','Linewidth',1.5);
plot( C_s, C_Dx, '-', N_s, N_Dx, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('Old','New');
ylabel('D_x [m]');
xlabel('s [m]');
grid on;

%% Plot Dy
figure;

% plot(S_D, Dy, '-', M_s, M_Dy, ':', s, Dy_lf, '--','Linewidth',1.5);
plot( C_s, C_Dy, '-', N_s, N_Dy, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('Old','New');
ylabel('D_y [m]');
xlabel('s [m]');
grid on;

%% Plot x
figure;

plot(C_s, C_x, '-', N_s, N_x, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('Old','New');
ylabel('x [m]');
xlabel('s [m]');
grid on;

%% Plot y
figure;

plot(C_s, C_y, '-', N_s, N_y, ':','Linewidth',1.5);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC Beam 1');
legend('Old','New');
ylabel('y [m]');
xlabel('s [m]');
grid on;

hold off;