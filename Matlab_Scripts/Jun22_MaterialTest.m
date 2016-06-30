%% MaterialTest CF
pmat='MoGr';
cmat='MoGr';
%% Import Pure
fn=strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/22_Jun_Comp/hist_',pmat,'_.txt');
filename = fn;
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/22_Jun_Comp/hist_C_.txt';
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
pbx = dataArray{:, 1};
px = dataArray{:, 2};
pbxp = dataArray{:, 3};
pxp = dataArray{:, 4};
% pby = dataArray{:, 5};
% py = dataArray{:, 6};
% pbyp = dataArray{:, 7};
% pyp = dataArray{:, 8};
pbdp = dataArray{:, 9};
pdp = dataArray{:, 10};
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Import Composite
% fn=strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/22_Jun_Comp/hist_',cmat,'_.txt');
fn=strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/22_Jun_NonComp/hist_',cmat,'_.txt');
filename = fn;
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/22_Jun_Comp/hist_AC150K_.txt';
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
cbx = dataArray{:, 1};
cx = dataArray{:, 2};
cbxp = dataArray{:, 3};
cxp = dataArray{:, 4};
% cby = dataArray{:, 5};
% cy = dataArray{:, 6};
% cbyp = dataArray{:, 7};
% cyp = dataArray{:, 8};
cbdp = dataArray{:, 9};
cdp = dataArray{:, 10};
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

    plot(pbx, px, 'color', c_orange,'Linewidth',2); hold on;
    plot(cbx, cx, 'color', c_dodger,'Linewidth',2); hold on;

    grid on;
%     title ('MCS & Ionisation','FontSize',10);
    ylabel('(dN/dx N_0) [m^{-1}]','FontSize',10);
    xlabel('\Delta x [m]','FontSize',10);
    
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[-1E-4 1E-4],'XTick',[-1E-4 -8E-5 -6E-5 -4E-5 -2E-5 0 2E-5 4E-5 6E-5 8E-5 1E-4],'YLim',[1E-6 1E0],'YTick',[1E-6 1E-5 1E-4 1E-3 1E-2 1E-1 1E0],'PlotBoxAspectRatio',[3 2 2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-4E-6 4E-6], 'YTick',[1E0 1E1 1E2 1E3 1E4 1E5]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2],'PlotBoxAspectRatio',[4 2 2]);
    
%     legend('location', 'northeast', pmat, cmat);  
    legend('location', 'northeast', pmat, strcat(cmat, ' STl-like Comp'));  
    hold off;

%% Plot dp
% subplot(3,1,2)        % add second plot in 1 x 3 grid
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

    plot(pbxp, pxp, 'color', c_orange,'Linewidth',2); hold on;
    plot(cbxp, cxp, 'color', c_dodger,'Linewidth',2); hold on;
    
    grid on;
    ylabel('dN/(dxp N_0) [rad^{-1}]','FontSize',10);
    xlabel('\Delta xp [rad]','FontSize',10);
    
     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[-1E-4 1E-4],'XTick',[-1E-4 -8E-5 -6E-5 -4E-5 -2E-5 0 2E-5 4E-5 6E-5 8E-5 1E-4],'YLim',[1E-6 1E-1],'YTick',[1E-6 1E-5 1E-4 1E-3 1E-2 1E-1],'PlotBoxAspectRatio',[3 2 2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0],'YLim',[0 1E4],'PlotBoxAspectRatio',[4 2 2]);
   
%     legend('location', 'northeast', pmat, cmat);       
    legend('location', 'northeast', pmat, strcat(cmat, ' STl-like Comp'));  
    hold off;

%% Plot theta
% subplot(3,1,3)        % add third plot in 1 x 3 grid
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');
% theta = atan ( sqrt( xp*xp + yp*yp ) );

    plot(pbdp, pdp, 'color', c_orange,'Linewidth',2); hold on;
    plot(cbdp, cdp, 'color', c_dodger,'Linewidth',2); hold on;
    
    grid on;
    ylabel('dN/(ddp N_0) [m^{-1}]','FontSize',10);
    xlabel('\Delta dp [GeV]','FontSize',10);
    
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XScale','log','XLim',[0 0.2],'YLim',[1E-6 1E0],'YTick',[1E-6 1E-5 1E-4 1E-3 1E-2 1E-1 1E0],'PlotBoxAspectRatio',[3 2 2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 1E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 0.4E-5]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-4],'YLim',[0 5E3],'PlotBoxAspectRatio',[4 2 2]);

%     legend('location', 'northeast', pmat, cmat);    
    legend('location', 'northeast', pmat, strcat(cmat, ' STl-like Comp'));  
    hold off;
