%% Plot 1cm material multiplot MCS
clear all;
% mat='MoGr';
mat='CuCD';
% scatter='singlediffractive';
scatter='elastic';

%% Import 6T raw data
fn=strcat('/home/HR/Downloads/IPAC16/1cm/input6T/1CM/',mat,'_M/2MCS.dat');
filename = fn;
delimiter = '\t';
formatSpec = '%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
dp_6T = dataArray{:, 1};
xp_6T = dataArray{:, 2};
yp_6T = dataArray{:, 3};
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Import MERLIN M Composite data hist_MCS_CuCD_
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/27MayMCS/M_Comp/',mat,'/unscattered_final_bunch_',mat,'_.txt');
filename=fn;
formatSpec = '%*105s%35f%*35f%35f%*35f%35f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
fclose(fileID);
xp_MM = dataArray{:, 1};
yp_MM = dataArray{:, 2};
dp_MM = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;

%% Import MERLIN ST Composite data
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/27MayMCS/S_Comp/',mat,'/unscattered_final_bunch_',mat,'_.txt');
filename=fn;
formatSpec = '%*105s%35f%*35f%35f%*35f%35f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
fclose(fileID);
xp_SM = dataArray{:, 1};
yp_SM = dataArray{:, 2};
dp_SM = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;

%% Import MERLIN M NonComp data
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/27MayMCS/M_NonComp/',mat,'/unscattered_final_bunch_',mat,'_.txt');
filename=fn;
formatSpec = '%*105s%35f%*35f%35f%*35f%35f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
fclose(fileID);
xp_MS = dataArray{:, 1};
yp_MS = dataArray{:, 2};
dp_MS = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;

%% Import MERLIN ST NonComp data
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/27MayMCS/S_NonComp/',mat,'/unscattered_final_bunch_',mat,'_.txt');
filename=fn;
formatSpec = '%*105s%35f%*35f%35f%*35f%35f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
fclose(fileID);
xp_SS = dataArray{:, 1};
yp_SS = dataArray{:, 2};
dp_SS = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot Multiplot
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');
bins = 500;

%% Plot xp
subplot(2,2,1)        % add first plot in 2 x 2 grid

%     [Ns,Xs] = hist(xp_6T, bins);
    [Ns,Xs] = hist(xp_6T, -5E-6:1E-8:5E-6);
    stairs(Xs,Ns,'color','k','Linewidth',3); hold on;
    
    [Nmm,Xmm] = hist(xp_MM, -5E-6:1E-8:5E-6);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',2); hold on;
    [Nmm,Xmm] = hist(xp_MS, -5E-6:1E-8:5E-6);
    stairs(Xmm,Nmm,'color',c_dodger,'Linewidth',2); hold on;
    [Nmm,Xmm] = hist(xp_SM, -5E-6:1E-8:5E-6);
    stairs(Xmm,Nmm,'color','g','Linewidth',1); hold on;
    [Nmm,Xmm] = hist(xp_SS, -5E-6:1E-8:5E-6);
    stairs(Xmm,Nmm,'color',c_gray,'Linewidth',1); hold on;
    

    grid on;
    title (strcat(mat,': MCS'),'FontSize',10);
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\Delta xp [rad]','FontSize',10);
    set(gca,'FontSize',10,'YScale','log','XLim',[-4E-6 4E-6], 'YTick',[1E0 1E1 1E2 1E3 1E4 1E5]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot dp
subplot(2,2,2)        % add second plot in 2 x 2 grid

%     [Ns,Xs] = hist(dp_6T, 0:2E-8:2E-5);
%     [Ns,Xs] = hist(-dp_6T, bins);
    [Ns,Xs] = hist(-dp_6T, -1:1E-3:0);
    stairs(-Xs,Ns,'color','k','Linewidth',5); hold on;
    
    [Nmm,Xmm] = hist(dp_MM, bins);
    stairs(-Xmm,Nmm,'color',c_orange,'Linewidth',4); hold on;
    [Nms,Xms] = hist(dp_MS, bins);
    stairs(-Xms,Nms,'color',c_dodger,'Linewidth',3); hold on;
    [Nsm,Xsm] = hist(dp_SM, bins);
    stairs(-Xsm,Nsm,'color','g','Linewidth',2); hold on;
    [Nss,Xss] = hist(dp_SS, bins);
    stairs(-Xss,Nss,'color',c_gray,'Linewidth',1); hold on;

    
    grid on;
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\Delta dp [GeV]','FontSize',10);
    
    set(gca,'FontSize',10,'XLim',[-1E12 0]);
%     set(gca,'FontSize',10,'YScale','log');
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0],'YLim',[0 1E4],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot theta
subplot(2,2,3)        % add third plot in 2 x 2 grid
% theta = atan ( sqrt( xp*xp + yp*yp ) );

%     [Ns,Xs] = hist(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)), 0:1E-7:1E-4);
    [Ns,Xs] = hist(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)), bins);
    stairs(Xs,Ns,'color','k','Linewidth',3); hold on;    
    
%     [Nmm,Xmm] = hist(atan(sqrt(xp_MM.*xp_MM + yp_MM.*yp_MM)), 0:1E-7:1E-4);
    [Nmm,Xmm] = hist(atan(sqrt(xp_MM.*xp_MM + yp_MM.*yp_MM)), bins);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',2); hold on;
%     [Nms,Xms] = hist(atan(sqrt(xp_MS.*xp_MS + yp_MS.*yp_MS)), 0:1E-7:1E-4);
    [Nms,Xms] = hist(atan(sqrt(xp_MS.*xp_MS + yp_MS.*yp_MS)), bins);
    stairs(Xms,Nms,'color',c_dodger,'Linewidth',2); hold on;
%     [Nsm,Xsm] = hist(atan(sqrt(xp_SM.*xp_SM + yp_SM.*yp_SM)), 0:1E-7:1E-4);
    [Nsm,Xsm] = hist(atan(sqrt(xp_SM.*xp_SM + yp_SM.*yp_SM)), bins);
    stairs(Xsm,Nsm,'color','g','Linewidth',1); hold on;
%     [Nss,Xss] = hist(atan(sqrt(xp_SS.*xp_SS + yp_SS.*yp_SS)), 0:1E-7:1E-4);
    [Nss,Xss] = hist(atan(sqrt(xp_SS.*xp_SS + yp_SS.*yp_SS)), bins);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;
    
    grid on;
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\theta [rad]','FontSize',10);
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[0 0.4E-5]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-4],'YLim',[0 5E3],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot t
subplot(2,2,4)        % add fourth plot in 2 x 2 grid

% t = - (4.9E19)*(theta*theta);

%     [Ns,Xs] = hist( (-4.9E19).*(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)).*(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)))), -10E12:1E9:0);
    [Ns,Xs] = hist( (-4.9E19).*(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)).*(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)))), bins);
    stairs(Xs,Ns,'color','k','Linewidth',3); hold on;
    
%     [Nmm,Xmm] = hist( (-4.9E19).*(atan(sqrt(xp_MM.*xp_MM + yp_MM.*yp_MM)).*(atan(sqrt(xp_MM.*xp_MM + yp_MM.*yp_MM)))), -10E12:1E9:0);
    [Nmm,Xmm] = hist( (-4.9E19).*(atan(sqrt(xp_MM.*xp_MM + yp_MM.*yp_MM)).*(atan(sqrt(xp_MM.*xp_MM + yp_MM.*yp_MM)))), bins);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',2); hold on;
%     [Nms,Xms] = hist( (-4.9E19).*(atan(sqrt(xp_MS.*xp_MS + yp_MS.*yp_MS)).*(atan(sqrt(xp_MS.*xp_MS + yp_MS.*yp_MS)))), -10E12:1E9:0);
    [Nms,Xms] = hist( (-4.9E19).*(atan(sqrt(xp_MS.*xp_MS + yp_MS.*yp_MS)).*(atan(sqrt(xp_MS.*xp_MS + yp_MS.*yp_MS)))), bins);
    stairs(Xms,Nms,'color',c_dodger,'Linewidth',2); hold on;
%     [Nsm,Xsm] = hist( (-4.9E19).*(atan(sqrt(xp_SM.*xp_SM + yp_SM.*yp_SM)).*(atan(sqrt(xp_SM.*xp_SM + yp_SM.*yp_SM)))), -10E12:1E9:0);
    [Nsm,Xsm] = hist( (-4.9E19).*(atan(sqrt(xp_SM.*xp_SM + yp_SM.*yp_SM)).*(atan(sqrt(xp_SM.*xp_SM + yp_SM.*yp_SM)))), bins);
    stairs(Xmm,Nmm,'color','g','Linewidth',1); hold on;
%     [Nss,Xss] = hist( (-4.9E19).*(atan(sqrt(xp_SS.*xp_SS + yp_SS.*yp_SS)).*(atan(sqrt(xp_SS.*xp_SS + yp_SS.*yp_SS)))), -10E12:1E9:0);
    [Nss,Xss] = hist( (-4.9E19).*(atan(sqrt(xp_SS.*xp_SS + yp_SS.*yp_SS)).*(atan(sqrt(xp_SS.*xp_SS + yp_SS.*yp_SS)))), bins);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;

    grid on;
%     legend('location', 'northwest', 'MERLIN M Composite', 'MERLIN M ST-like', 'MERLIN S Composite', 'MERLIN S ST-like');
    legend('location', 'northwest', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like', 'MERLIN S Composite', 'MERLIN S ST-like');    ylabel('Frequency [-]','FontSize',10);
    xlabel('t [GeV^2]','FontSize',10);
    set(gca,'FontSize',10,'XLim',[-8e8 0]);
    hold off;