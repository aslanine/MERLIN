%% Plot MADX vs MERLIN Delta_Value/Value_MADX without interpolation

clearvars all;


%% Import TWISS

% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/fcc_lattice_dev_0300_crossing.tfs';
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/fcc_lattice_dev_0300_nocrossing.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
M_s = dataArray{:, 3};
M_betax = dataArray{:, 19};
M_betay = dataArray{:, 20};
M_alphax = dataArray{:, 21};
M_alphay = dataArray{:, 22};
M_Dx = dataArray{:, 25};
M_Dy = dataArray{:, 26};
M_x = dataArray{:, 33};
M_y = dataArray{:, 35};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import LatticeFunctionTable

% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/FCC_v7_dev/10_APR_format/LatticeFunctions/LatticeFunctions.dat';
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/FCC_v7_dev/10_APR_format_noX/LatticeFunctions/LatticeFunctions.dat';
formatSpec = '%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%f%[^\n\r]';
startRow = 2;
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
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
alphax = dataArray{:, 9};
betay = dataArray{:, 10};
alphay = dataArray{:, 11};
D_x_EF = dataArray{:, 12};      % D_x * Energy scaling factor
D_xp_EF = dataArray{:, 13};      
D_y_EF = dataArray{:, 14};      % D_y * Energy scaling factor
D_yp_EF = dataArray{:, 15};
EF = dataArray{:, 16};          % Energy scaling factor

Dx_lf = D_x_EF ./ EF;
Dy_lf = D_y_EF ./ EF;
D_xp = D_xp_EF ./ EF;
D_yp = D_yp_EF ./ EF;

alphax = -1 .* alphax;
alphay = -1 .* alphay;

clearvars filename formatSpec fileID dataArray ans;

%% Import Dispersion

% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/FCC_v7_dev/10_APR_format/LatticeFunctions/Dispersion.dat';
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/FCC_v7_dev/10_APR_format_noX/LatticeFunctions/Dispersion.dat';
formatSpec = '%14f%14f%f%[^\n\r]';
startRow = 1;
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
S_D = dataArray{:, 1};
Dx = dataArray{:, 2};
Dy = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;

%% Multiple Plots

% xlimits full
xmin = 0; 
% xmax = 97387.4336310000;
xmax = 97749.3853528378;

% xlimits zoom start
% xmin = 0;
% xmax = 100;

% IPA - IPB
% xmin = 0;
% xmax = 7000;

%% Plot beta x

% FIGURE start
figure;
subplot(2,1,1);

plot(s, betax, '-', M_s, M_betax, ':','Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('\beta_x [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_betax - betax);
test3 = (100*test3) ./ M_betay;

plot(s, test3);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('\Delta\beta_x \beta_x [%]');
ylabel('^{\Delta\beta_x}/_{\beta_x} [%]');


xlabel('s [m]');
grid on;

clearvars test3;


%% Plot beta y

% FIGURE start
figure;
subplot(2,1,1);

plot(s, betay, '-', M_s, M_betay, ':','Linewidth',1.5);

set(gca,'yscale','log','FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('\beta_x [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_betay - betay);
test3 = (100*test3) ./ M_betay;

plot(s, test3);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
ylabel('^{\Delta\beta_y}/_{\beta_y} [%]');


xlabel('s [m]');
grid on;

clearvars test3;


%% Plot alpha x

% FIGURE start
figure;
subplot(2,1,1);

plot(s, alphax, '-', M_s, M_alphax, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('\alpha_x [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_alphax - alphax);
% test3 = test3 ./ M_alphax;

plot(s, test3);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('^{\Delta\alpha_x}/_{\alpha_x} [%]');
ylabel('\Delta\alpha_x [m]');


xlabel('s [m]');
grid on;

clearvars test3;


%% Plot alpha y

% FIGURE start
figure;
subplot(2,1,1);

plot(s, alphay, '-', M_s, M_alphay, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('\alpha_x [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_alphay - alphay);
% test3 = test3 ./ M_alphay;

plot(s, test3);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('^{\Delta\alpha_y}/_{\alpha_y} [%]');
ylabel('\Delta\alpha_y [m]');



xlabel('s [m]');
grid on;

clearvars test3;


%% Plot Dx LatticeFunctions

figure;
subplot(2,1,1);

plot(s, Dx_lf, '-', M_s, M_Dx, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN LatticeFunctions','MADX');
ylabel('D_x [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_Dx - Dx_lf);
% test3 = test3 ./ M_Dx;

plot(s, test3);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('^{\Delta D_x}/_{D_x} [%]');
ylabel('\Delta D_x [m]');

xlabel('s [m]');
grid on;

clearvars test1 test2 test3 test4 merlin_int mad_int array_in array_inm;

%% Plot Dx Dispersion

% FIGURE start

figure;
subplot(2,1,1);

plot(S_D, Dx, '-', M_s, M_Dx, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN Dispersion','MADX');
ylabel('D_x [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_Dx - Dx);
% test3 = test3 ./ M_Dx;

plot(s, test3);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('^{\Delta D_x}/_{D_x} [%]');
ylabel('\Delta D_x [m]');

xlabel('s [m]');
grid on;

clearvars test1 test2 test3 test4 merlin_int mad_int array_in array_inm;

%% Plot Dy Dispersion
% FIGURE start

figure;
subplot(2,1,1);

plot(S_D, Dy, '-', M_s, M_Dy, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN Dispersion','MADX');
ylabel('D_y [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_Dy - Dy);
% test3 = test3 ./ M_Dy;

plot(s, test3);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('^{\Delta D_y}/_{D_y} [%]');
ylabel('\Delta D_y [m]');
xlabel('s [m]');
grid on;

clearvars test1 test2 test3 test4 merlin_int mad_int array_in array_inm;

%% Plot Dy LatticeFunctions
% FIGURE start

figure;
subplot(2,1,1);

plot(s, Dy_lf, '-', M_s, M_Dy, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN LatticeFunctions','MADX');
ylabel('D_y [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_Dy - Dy_lf);
% test3 = test3 ./ M_Dy;

plot(s, test3);


set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('^{\Delta D_y}/_{D_y} [%]');
ylabel('\Delta D_y [m]');
xlabel('s [m]');
grid on;

clearvars test1 test2 test3 test4 merlin_int mad_int array_in array_inm;

%% Plot x

% FIGURE start
figure;
subplot(2,1,1);

plot(s, x, '-', M_s, M_x, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('x [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_x - x);
% test3 = test3 ./ M_x;

plot(s, test3);


set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('^{\Delta x}/_{x} [%]');
ylabel('\Delta x [m]');
xlabel('s [m]');
grid on;

clearvars test1 test2 test3 test4 merlin_int mad_int array_in array_inm;



%% Plot y

% FIGURE start
figure;
subplot(2,1,1);

plot(s, y, '-', M_s, M_y, ':','Linewidth',1.5);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
title('FCC-hh v7 Beam 1');
legend('MERLIN','MADX');
ylabel('y [m]');
xlabel('s [m]');
grid on;

% Plot beta x difference / MADX
subplot(2,1,2);

test3 = double.empty;
test3 = abs(M_y - y);
% test3 = test3 ./ M_y;

plot(s, test3);

set(gca,'FontSize',16,'Linewidth',1,'XLim',[xmin xmax]);
legend('MERLIN-MADX');
% ylabel('^{\Delta y}/_{y} [%]');
ylabel('\Delta y [m]');
xlabel('s [m]');
grid on;

clearvars test1 test2 test3 test4 merlin_int mad_int array_in array_inm;