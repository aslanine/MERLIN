%% MaterialTest CF
pmat='IT180';
cmat='IT180';
%% Import Composite M
fn=strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/22_Jun_Comp/hist_',cmat,'_.txt');
filename = fn;
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
CM_bx = dataArray{:, 1};
CM_x = dataArray{:, 2};
CM_bxp = dataArray{:, 3};
CM_xp = dataArray{:, 4};
% CM_by = dataArray{:, 5};
% CM_y = dataArray{:, 6};
% CM_byp = dataArray{:, 7};
% CM_yp = dataArray{:, 8};
CM_bdp = dataArray{:, 9};
CM_dp = dataArray{:, 10};
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Import Composite S
fn=strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/23_Jun_SComp/hist_',cmat,'_.txt');
filename = fn;
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
CS_bx = dataArray{:, 1};
CS_x = dataArray{:, 2};
CS_bxp = dataArray{:, 3};
CS_xp = dataArray{:, 4};
% CS_by = dataArray{:, 5};
% CS_y = dataArray{:, 6};
% CS_byp = dataArray{:, 7};
% CS_yp = dataArray{:, 8};
CS_bdp = dataArray{:, 9};
CS_dp = dataArray{:, 10};
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Import Non-Composite M
fn=strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/22_Jun_NonComp/hist_',pmat,'_.txt');
filename = fn;
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
NM_bx = dataArray{:, 1};
NM_x = dataArray{:, 2};
NM_bxp = dataArray{:, 3};
NM_xp = dataArray{:, 4};
% NM_by = dataArray{:, 5};
% NM_y = dataArray{:, 6};
% NM_byp = dataArray{:, 7};
% NM_yp = dataArray{:, 8};
NM_bdp = dataArray{:, 9};
NM_dp = dataArray{:, 10};
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Import Non-Composite S
fn=strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/23_Jun_SNonComp/hist_',pmat,'_.txt');
filename = fn;
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
NS_bx = dataArray{:, 1};
NS_x = dataArray{:, 2};
NS_bxp = dataArray{:, 3};
NS_xp = dataArray{:, 4};
% NS_by = dataArray{:, 5};
% NS_y = dataArray{:, 6};
% NS_byp = dataArray{:, 7};
% NS_yp = dataArray{:, 8};
NS_bdp = dataArray{:, 9};
NS_dp = dataArray{:, 10};
clearvars filename delimiter formatSpec fileID dataArray ans;


%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot xp
% subplot(3,1,1)        % add first plot in 1 x 3 grid
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

    plot(CM_bx, CM_x, 'color', c_orange,'Linewidth',2); hold on;
    plot(CS_bx, CS_x, 'color', c_dodger,'Linewidth',2); hold on;
    plot(NM_bx, NM_x, 'color', c_gray,'Linewidth',2); hold on;
    plot(NS_bx, NS_x, 'color', c_teal,'Linewidth',2); hold on;

    grid on;
    title (pmat,'FontSize',10);
    ylabel('(dN/dx N_0) [m^{-1}]','FontSize',10);
    xlabel('\Delta x [m]','FontSize',10);
    
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[-1E-4 1E-4],'XTick',[-1E-4 -8E-5 -6E-5 -4E-5 -2E-5 0 2E-5 4E-5 6E-5 8E-5 1E-4],'YLim',[1E-6 1E0],'YTick',[1E-6 1E-5 1E-4 1E-3 1E-2 1E-1 1E0],'PlotBoxAspectRatio',[3 2 2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-4E-6 4E-6], 'YTick',[1E0 1E1 1E2 1E3 1E4 1E5]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2],'PlotBoxAspectRatio',[4 2 2]);
    
%     legend('location', 'northeast', pmat, cmat);  
    legend('location', 'northeast', 'Composite M' , 'Composite S', 'NonComp M', 'NonComp S');    
%     legend('location', 'northeast', pmat, strcat(cmat, ' ST-like Comp'));  
    hold off;

%% Plot dp
% subplot(3,1,2)        % add second plot in 1 x 3 grid
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

    plot(CM_bxp, CM_xp, 'color', c_orange,'Linewidth',2); hold on;
    plot(CS_bxp, CS_xp, 'color', c_dodger,'Linewidth',2); hold on;
    plot(NM_bxp, NM_xp, 'color', c_gray,'Linewidth',2); hold on;
    plot(NS_bxp, NS_xp, 'color', c_teal,'Linewidth',2); hold on;
    
    grid on;
    ylabel('dN/(dxp N_0) [rad^{-1}]','FontSize',10);
    xlabel('\Delta xp [rad]','FontSize',10);
    
     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[-1E-4 1E-4],'XTick',[-1E-4 -8E-5 -6E-5 -4E-5 -2E-5 0 2E-5 4E-5 6E-5 8E-5 1E-4],'YLim',[1E-6 1E-1],'YTick',[1E-6 1E-5 1E-4 1E-3 1E-2 1E-1],'PlotBoxAspectRatio',[3 2 2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0],'YLim',[0 1E4],'PlotBoxAspectRatio',[4 2 2]);
   
%     legend('location', 'northeast', pmat, cmat);       
    legend('location', 'northeast', 'Composite M' , 'Composite S', 'NonComp M', 'NonComp S');    
%     legend('location', 'northeast', pmat, strcat(cmat, ' ST-like Comp'));  
    hold off;

%% Plot theta
% subplot(3,1,3)        % add third plot in 1 x 3 grid
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');
% theta = atan ( sqrt( xp*xp + yp*yp ) );

    plot(CM_bdp, CM_dp, 'color', c_orange,'Linewidth',2); hold on;
    plot(CS_bdp, CS_dp, 'color', c_dodger,'Linewidth',2); hold on;
    plot(NM_bdp, NM_dp, 'color', c_gray,'Linewidth',2); hold on;
    plot(NS_bdp, NS_dp, 'color', c_teal,'Linewidth',2); hold on;
    
    grid on;
    ylabel('dN/(ddp N_0) [m^{-1}]','FontSize',10);
    xlabel('\Delta dp [GeV]','FontSize',10);
    
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XScale','log','XLim',[0 0.2],'YLim',[1E-6 1E0],'YTick',[1E-6 1E-5 1E-4 1E-3 1E-2 1E-1 1E0],'PlotBoxAspectRatio',[3 2 2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 1E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 0.4E-5]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-4],'YLim',[0 5E3],'PlotBoxAspectRatio',[4 2 2]);

%     legend('location', 'northeast', pmat, cmat);    
    legend('location', 'northeast', 'Composite M' , 'Composite S', 'NonComp M', 'NonComp S');    
%     legend('location', 'northeast', pmat, strcat(cmat, ' ST-like Comp'));  
    hold off;
