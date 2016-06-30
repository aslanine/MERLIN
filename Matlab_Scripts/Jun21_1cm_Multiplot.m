%% Plot 1cm material multiplot Scattering Comparison
clear all;

%% Import M scatter hist
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/21JunAll/MScatter/AC150K/HIST_AC150K_5.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
M_xpb = dataArray{:, 1};
M_xp = dataArray{:, 2};
M_dpb = dataArray{:, 3};
M_dp = dataArray{:, 4};
M_thb = dataArray{:, 5};
M_th = dataArray{:, 6};
M_tb = dataArray{:, 7};
M_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import S scatter hist
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/21JunAll/SScatter/AC150K/HIST_AC150K_5.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
S_xpb = dataArray{:, 1};
S_xp = dataArray{:, 2};
S_dpb = dataArray{:, 3};
S_dp = dataArray{:, 4};
S_thb = dataArray{:, 5};
S_th = dataArray{:, 6};
S_tb = dataArray{:, 7};
S_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot Multiplot
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

%% Plot xp
subplot(2,2,1)        % add first plot in 2 x 2 grid

    plot(M_xpb, M_xp, 'color', c_orange,'Linewidth',2); hold on;
    plot(S_xpb, S_xp, 'color', c_dodger,'Linewidth',2); hold on;

    grid on;
    title ('MCS & Ionisation','FontSize',10);
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\Delta xp [rad]','FontSize',10);
    
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[-1E-6 1E-6]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-4E-6 4E-6], 'YTick',[1E0 1E1 1E2 1E3 1E4 1E5]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot dp
subplot(2,2,2)        % add second plot in 2 x 2 grid
    
    plot(M_dpb, M_dp, 'color', c_orange,'Linewidth',2); hold on;
    plot(S_dpb, S_dp, 'color', c_dodger,'Linewidth',2); hold on;
    
    grid on;
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\Delta dp [GeV]','FontSize',10);
    
%      set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[0 5E-6]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-6]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-5E-6 0]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0],'YLim',[0 1E4],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot theta
subplot(2,2,3)        % add third plot in 2 x 2 grid
% theta = atan ( sqrt( xp*xp + yp*yp ) );

    plot(M_thb, M_th, 'color', c_orange,'Linewidth',2); hold on;
    plot(S_thb, S_th, 'color', c_dodger,'Linewidth',2); hold on;
    
    grid on;
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\theta [rad]','FontSize',10);
    
    set(gca,'FontSize',10,'YScale','log');
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 1E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 0.4E-5]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-4],'YLim',[0 5E3],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot t
subplot(2,2,4)        % add fourth plot in 2 x 2 grid

% t = - (4.9E19)*(theta*theta);

    plot(M_tb, M_t, 'color', c_orange,'Linewidth',2); hold on;
    plot(S_tb, S_t, 'color', c_dodger,'Linewidth',2); hold on;
    
    grid on;
    legend('location', 'northwest', 'MERLIN Scattering', 'ST-like Scattering');    
    ylabel('Frequency [-]','FontSize',10);
    xlabel('t [GeV^2]','FontSize',10);
    
    set(gca,'FontSize',10,'YScale','log');
    hold off;