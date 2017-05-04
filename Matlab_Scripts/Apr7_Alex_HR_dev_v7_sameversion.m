% Compare v7_dev with Alex's (crossing on)

%% Import TWISS
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Lattice_dev_Alex_0300_Crossing_IPL.tfs';
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Lattice_dev_Alex_0300_Crossing_IPA.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
s = dataArray{:, 3};
betax = dataArray{:, 18};
betay = dataArray{:, 19};
Dx = dataArray{:, 24};
Dy = dataArray{:, 25};
x = dataArray{:, 32};
y = dataArray{:, 34};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


%% Import TWISS
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Lattice_dev_Alex_0300_Crossing_IPA.tfs';
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/fcc_lattice_dev_0300_crossing.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
M_s = dataArray{:, 3};
M_betax = dataArray{:, 19};
M_betay = dataArray{:, 20};
M_Dx = dataArray{:, 25};
M_Dy = dataArray{:, 26};
M_x = dataArray{:, 33};
M_y = dataArray{:, 35};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


%% Multiple Plots

% xlimits full
xmin = 0;
xmax = 97387.4336310000;

% xlimits zoom start
% xmin = 0;
% xmax = 100;

% IPA - IPB
% xmin = 0;
% xmax = 7000;

%% Plot beta x
figure;
subplot(2,1,1);

plot(s, betax, '-', M_s, M_betax, ':','Linewidth',1.5);

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('\beta_x [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference
% figure;
subplot(2,1,2);

% interpolation steps
interval = 1E-3;
s_int = 0:interval:xmax;

% create 2D array of data
array_in = horzcat(s, betax);
array_inm = horzcat(M_s, M_betax);

% indices of unique s positions
[~, ind] = unique(array_in(:,1), 'rows', 'first');
[~, indm] = unique(array_inm(:,1), 'rows', 'first');

% arrays of unique s points
test1 = array_in(ind,:);
test2 = array_inm(indm,:);

% interpolate MERLIN and MADX
merlin_int = interp1(test1(:,1), test1(:,2), s_int, 'linear','extrap');
mad_int = interp1(test2(:,1), test2(:,2), s_int, 'linear','extrap');

plot(s_int, (merlin_int - mad_int) );

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
% title('6.5 TeV Beam 1');
legend('MERLIN-MADX');
ylabel('\Delta\beta_x [m]');
xlabel('s [m]');
grid on;

%% Plot beta y
figure;
subplot(2,1,1);

plot(s, betay, '-', M_s, M_betay, ':','Linewidth',1.5);

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('\beta_y [m]');
xlabel('s [m]');
grid on;

% Plot beta y difference
% figure;
subplot(2,1,2);

% interpolation steps
interval = 1;
s_int = 0:interval:xmax;

% create 2D array of data
array_in = horzcat(s, betay);
array_inm = horzcat(M_s, M_betay);

% indices of unique s positions
[~, ind] = unique(array_in(:,1), 'rows', 'first');
[~, indm] = unique(array_inm(:,1), 'rows', 'first');

% arrays of unique s points
test1 = array_in(ind,:);
test2 = array_inm(indm,:);

% interpolate MERLIN and MADX
merlin_int = interp1(test1(:,1), test1(:,2), s_int, 'linear','extrap');
mad_int = interp1(test2(:,1), test2(:,2), s_int, 'linear','extrap');

plot(s_int, (merlin_int - mad_int) );

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
% title('6.5 TeV Beam 1');
legend('MERLIN-MADX');
ylabel('\Delta\beta_y [m]');
xlabel('s [m]');
grid on;

%% Plot Dx
figure;
subplot(2,1,1);

% plot(S_D, Dx, '-', M_s, M_Dx, ':', s, Dx_lf, '--','Linewidth',1.5);
plot(s, Dx, '-', M_s, M_Dx, ':','Linewidth',1.5);
% plot(s, Dx_lf, '--', S_D, Dx, '-', M_s, M_Dx, ':','Linewidth',1.5);
% plot(s, Dx_lf, '-', S_D, Dx,'Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('MERLIN Dispersion','MADX');
ylabel('D_x [m]');
xlabel('s [m]');
grid on;

% Plot Dx difference
subplot(2,1,2);

% interpolation steps
interval = 10;
s_int = 0:interval:xmax;

% create 2D array of data
array_in = horzcat(s, Dx);
% array_in = horzcat(s, Dx_lf);
array_inm = horzcat(M_s, M_Dx);

% indices of unique s positions
[~, ind] = unique(array_in(:,1), 'rows', 'first');
[~, indm] = unique(array_inm(:,1), 'rows', 'first');

% arrays of unique s points
test1 = array_in(ind,:);
test2 = array_inm(indm,:);

% interpolate MERLIN and MADX
merlin_int = interp1(test1(:,1), test1(:,2), s_int, 'linear','extrap');
mad_int = interp1(test2(:,1), test2(:,2), s_int, 'linear','extrap');

plot(s_int, (merlin_int - mad_int) );

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
% title('6.5 TeV Beam 1');
legend('MERLIN-MADX');
ylabel('\Delta D_x [m]');
xlabel('s [m]');
grid on;

%% Plot Dy
figure;
subplot(2,1,1);

% plot(S_D, Dy, '-', M_s, M_Dy, ':', s, Dy_lf, '--','Linewidth',1.5);
plot(s, Dy, '-', M_s, M_Dy, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('MERLIN Dispersion','MADX');
ylabel('D_y [m]');
xlabel('s [m]');
grid on;

% Plot Dx difference
subplot(2,1,2);

% interpolation steps
interval = 1;
s_int = 0:interval:xmax;

% create 2D array of data
array_in = horzcat(s, Dy);
% array_in = horzcat(s, Dy_lf);
array_inm = horzcat(M_s, M_Dy);

% indices of unique s positions
[~, ind] = unique(array_in(:,1), 'rows', 'first');
[~, indm] = unique(array_inm(:,1), 'rows', 'first');

% arrays of unique s points
test1 = array_in(ind,:);
test2 = array_inm(indm,:);

% interpolate MERLIN and MADX
merlin_int = interp1(test1(:,1), test1(:,2), s_int, 'linear','extrap');
mad_int = interp1(test2(:,1), test2(:,2), s_int, 'linear','extrap');

plot(s_int, (merlin_int - mad_int) );

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
% title('6.5 TeV Beam 1');
legend('MERLIN-MADX');
ylabel('\Delta D_y [m]');
xlabel('s [m]');
grid on;

%% Plot x
figure;
subplot(2,1,1);

plot(s, x, '-', M_s, M_x, ':','Linewidth',1.5);

% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('x [m]');
xlabel('s [m]');
grid on;

% Plot x difference
subplot(2,1,2);

% interpolation steps
interval = 0.01;
s_int = 0:interval:xmax;

% create 2D array of data
array_in = horzcat(s, x);
array_inm = horzcat(M_s, M_x);

% indices of unique s positions
[~, ind] = unique(array_in(:,1), 'rows', 'first');
[~, indm] = unique(array_inm(:,1), 'rows', 'first');

% arrays of unique s points
test1 = array_in(ind,:);
test2 = array_inm(indm,:);

% interpolate MERLIN and MADX
merlin_int = interp1(test1(:,1), test1(:,2), s_int, 'linear','extrap');
mad_int = interp1(test2(:,1), test2(:,2), s_int, 'linear','extrap');

plot(s_int, (merlin_int - mad_int) );

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
% title('6.5 TeV Beam 1');
legend('MERLIN-MADX');
ylabel('\Delta x [m]');
xlabel('s [m]');
grid on;

%% Plot y
figure;
subplot(2,1,1);

plot(s, y, '-', M_s, M_y, ':','Linewidth',1.5);

% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('y [m]');
xlabel('s [m]');
grid on;

hold off;

% Plot y difference
subplot(2,1,2);

% interpolation steps
interval = 0.01;
s_int = 0:interval:xmax;

% create 2D array of data
array_in = horzcat(s, y);
array_inm = horzcat(M_s, M_y);

% indices of unique s positions
[~, ind] = unique(array_in(:,1), 'rows', 'first');
[~, indm] = unique(array_inm(:,1), 'rows', 'first');

% arrays of unique s points
test1 = array_in(ind,:);
test2 = array_inm(indm,:);

% interpolate MERLIN and MADX
merlin_int = interp1(test1(:,1), test1(:,2), s_int, 'linear','extrap');
mad_int = interp1(test2(:,1), test2(:,2), s_int, 'linear','extrap');

plot(s_int, (merlin_int - mad_int) );

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax]);
% set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
% title('6.5 TeV Beam 1');
legend('MERLIN-MADX');
ylabel('\Delta y [m]');
xlabel('s [m]');
grid on;