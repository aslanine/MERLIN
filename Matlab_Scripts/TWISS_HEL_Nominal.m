%% PLOT TWISS FOR HEL IN NOMINAL LHC

%% Import LatticeFunctionTable

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HELSplit/08_Aug_TWISS/LatticeFunctions/LatticeFunctions.dat';
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

%% Import Dispersion

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/HELSplit/08_Aug_TWISS/LatticeFunctions/Dispersion.dat';
formatSpec = '%14f%14f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
S_D = dataArray{:, 1};
Dx = dataArray{:, 2};
Dy = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Multiple Plots

% xlimits full
xmin = 9800;
xmax = 10000;

% xlimits zoom start
% xmin = 0;
% xmax = 100;

% IPA - IPB
% xmin = 0;
% xmax = 7000;

round = 9967.005;
nonround = 9908.405;
oval = 9878.046;

%% Plot beta x
figure;

betmin = 1E2;
betmax = 6E2;

plot(s, betax, ':', s, betay, ':','Linewidth',1.5);

line([round round],[betmin betmax], 'Color', c_orange,'Linewidth',1.5), hold on;
txt1 = '\leftarrow Round';
text(round,4E2,txt1,'FontSize',16);
line([nonround nonround],[betmin betmax], 'Color', c_dodger,'Linewidth',1.5), hold on;
txt2 = '\leftarrow Non-Round';
text(nonround,4E2,txt2,'FontSize',16);
line([oval oval],[betmin betmax], 'Color', c_teal,'Linewidth',1.5), hold on;
txt3 = '\leftarrow Oval';
text(oval,4E2,txt3,'FontSize',16);

% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1.5,'XLim',[xmin xmax]);
% set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1.5,'XLim',[xmin xmax], 'YLim', [1E2 1E3]);
set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1.5,'XLim',[xmin xmax], 'YLim', [betmin betmax]);
title('HL-LHC HEL');
legend('\beta_x','\beta_y');
ylabel('\beta [m]');
xlabel('s [m]');
grid on;

%% Plot Dx
figure;

dmin = -0.8;
dmax = 0.2;

plot(S_D, Dx, ':',S_D, Dy, ':', 'Linewidth',1.5);

line([round round],[dmin dmax], 'Color', c_orange,'Linewidth',1.5), hold on;
txt1 = '\leftarrow Round';
text(round,0,txt1,'FontSize',16);
line([nonround nonround],[dmin dmax], 'Color', c_dodger,'Linewidth',1.5), hold on;
txt2 = '\leftarrow Non-Round';
text(nonround,0,txt2,'FontSize',16);
line([oval oval],[dmin dmax], 'Color', c_teal,'Linewidth',1.5), hold on;
txt3 = '\leftarrow Oval';
text(oval,0,txt3,'FontSize',16);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1.5,'XLim',[xmin xmax], 'YLim', [dmin dmax]);
title('HL-LHC HEL');
% legend('MERLIN Dispersion','MADX','MERLIN LatticeFunctions');
legend('D_x','D_y');
ylabel('D [m]');
xlabel('s [m]');
grid on;

%% Plot x
figure;

ymin = -0.2E-8;
ymax = 0.5E-8;

plot(s, x, '-', s, y, ':','Linewidth',1.5);

line([round round],[ymin ymax], 'Color', c_orange,'Linewidth',1.5), hold on;
txt1 = '\leftarrow Round';
text(round,0,txt1,'FontSize',16);
line([nonround nonround],[ymin ymax], 'Color', c_dodger,'Linewidth',1.5), hold on;
txt2 = '\leftarrow Non-Round';
text(nonround,0,txt2,'FontSize',16);
line([oval oval],[ymin ymax], 'Color', c_teal,'Linewidth',1.5), hold on;
txt3 = '\leftarrow Oval';
text(oval,0,txt3,'FontSize',16);

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1.5,'XLim',[xmin xmax], 'YLim', [ymin ymax]);
title('HL-LHC HEL');
legend('x','y');
ylabel('Closed Orbit [m]');
xlabel('s [m]');
grid on;

hold off;