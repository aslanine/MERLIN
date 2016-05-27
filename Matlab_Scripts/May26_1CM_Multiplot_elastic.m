%% Plot 1cm material multiplot
clear all;
mat='MoGr';
% mat='CuCD';
% scatter='singlediffractive';
scatter='elastic';

%% Import 6T raw data
% fn = strcat( '/home/HR/Downloads/IPAC16/1cm/input6T/1CM/',mat,'_M/SD.dat');
fn = strcat( '/home/HR/Downloads/IPAC16/1cm/input6T/1CM/',mat,'_M/nElast.dat');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
dp_6T = cell2mat(raw(:, 1));
xp_6T = cell2mat(raw(:, 2));
yp_6T = cell2mat(raw(:, 3));
clearvars filename delimiter st fn;

%% Import MERLIN M Composite data
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/M_Comp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/M_Comp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%*s%*s%*s%f%*s%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
M_M_xp = dataArray{:, 1};
M_M_dp = dataArray{:, 2};
M_M_theta = dataArray{:, 3};
M_M_t = dataArray{:, 4};
clearvars filename delimiter startRow formatSpec fileID dataArray ans fn;

fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/M_Comp/',mat,'/HIST_',mat,'_2.txt');
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/M_Comp/',mat,'/HIST_',mat,'_2.txt');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
MM_bxp = dataArray{:, 1};
MM_xp = dataArray{:, 2};
MM_bdp = dataArray{:, 3};
MM_dp = dataArray{:, 4};
MM_btheta = dataArray{:, 5};
MM_theta = dataArray{:, 6};
MM_bt = dataArray{:, 7};
MM_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import MERLIN ST Composite data
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/S_Comp/',mat,'/Mselect_scatter_',mat,'_',scatter,'_.txt');
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/S_Comp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%*s%*s%*s%f%*s%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
S_M_xp = dataArray{:, 1};
S_M_dp = dataArray{:, 2};
S_M_theta = dataArray{:, 3};
S_M_t = dataArray{:, 4};
clearvars filename delimiter startRow formatSpec fileID dataArray ans fn;

fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/S_Comp/',mat,'/MHIST_',mat,'_2.txt');
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/S_Comp/',mat,'/HIST_',mat,'_2.txt');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
SM_bxp = dataArray{:, 1};
SM_xp = dataArray{:, 2};
SM_bdp = dataArray{:, 3};
SM_dp = dataArray{:, 4};
SM_btheta = dataArray{:, 5};
SM_theta = dataArray{:, 6};
SM_bt = dataArray{:, 7};
SM_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import MERLIN M NonComp data
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/M_NonComp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/M_NonComp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%*s%*s%*s%f%*s%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
M_S_xp = dataArray{:, 1};
M_S_dp = dataArray{:, 2};
M_S_theta = dataArray{:, 3};
M_S_t = dataArray{:, 4};
clearvars filename delimiter startRow formatSpec fileID dataArray ans fn;

fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/M_NonComp/',mat,'/HIST_',mat,'_2.txt');
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/M_NonComp/',mat,'/HIST_',mat,'_2.txt');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
MS_bxp = dataArray{:, 1};
MS_xp = dataArray{:, 2};
MS_bdp = dataArray{:, 3};
MS_dp = dataArray{:, 4};
MS_btheta = dataArray{:, 5};
MS_theta = dataArray{:, 6};
MS_bt = dataArray{:, 7};
MS_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import MERLIN ST NonComp data
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/S_NonComp/',mat,'/Sselect_scatter_',mat,'_',scatter,'_.txt');
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/S_NonComp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%*s%*s%*s%f%*s%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
S_S_xp = dataArray{:, 1};
S_S_dp = dataArray{:, 2};
S_S_theta = dataArray{:, 3};
S_S_t = dataArray{:, 4};
clearvars filename delimiter startRow formatSpec fileID dataArray ans fn;

fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/S_NonComp/',mat,'/SHIST_',mat,'_2.txt');
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/S_NonComp/',mat,'/HIST_',mat,'_2.txt');
filename = fn;
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
SS_bxp = dataArray{:, 1};
SS_xp = dataArray{:, 2};
SS_bdp = dataArray{:, 3};
SS_dp = dataArray{:, 4};
SS_btheta = dataArray{:, 5};
SS_theta = dataArray{:, 6};
SS_bt = dataArray{:, 7};
SS_t = dataArray{:, 8};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

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
    [Ns,Xs] = hist(xp_6T, -1E-4:2E-7:1E-4);
    stairs(Xs,Ns,'color','k','Linewidth',1); hold on;
    
    [Nmm,Xmm] = hist(M_M_xp, -1E-4:2E-7:1E-4);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',1); hold on;
    [Nms,Xms] = hist(M_S_xp, -1E-4:2E-7:1E-4);
    stairs(Xms,Nms,'color','r','Linewidth',1); hold on;
    [Nsm,Xsm] = hist(S_M_xp, -1E-4:2E-7:1E-4);
    stairs(Xsm,Nsm,'color',c_dodger,'Linewidth',1); hold on;
    [Nss,Xss] = hist(S_S_xp, -1E-4:2E-7:1E-4);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;    
    
%     plot(MM_bxp, MM_xp,'b','Linewidth',2); hold on;
%     plot(MM_bxp, MM_xp,'color',c_orange,'Linewidth',2); hold on;
%     plot(MS_bxp, MS_xp,'color',c_dodger,'Linewidth',2); hold on;
%     plot(SM_bxp, SM_xp,'color',c_teal,'Linewidth',2); hold on;
%     plot(SS_bxp, SS_xp,'color',c_gray,'Linewidth',2); hold on;

    grid on;
%     title (strcat(mat,' no MCS or ionisation: Elastic'),'FontSize',10);
    title (strcat(mat,' no MCS or ionisation: pN Elastic'),'FontSize',10);
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\Delta xp [rad]','FontSize',10);
    set(gca,'FontSize',10,'YScale','log','XLim',[-1E-4 1E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot dp
subplot(2,2,2)        % add second plot in 2 x 2 grid

%     [Ns,Xs] = hist(dp_6T, bins);
    [Ns,Xs] = hist(dp_6T, 0:2E-8:2E-5);
    stairs(-Xs,Ns,'color','k','Linewidth',1); hold on;
    
    [Nmm,Xmm] = hist(M_M_dp, bins);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',1); hold on;
    [Nms,Xms] = hist(M_S_dp, bins);
    stairs(Xms,Nms,'color','r','Linewidth',1); hold on;
    [Nsm,Xsm] = hist(S_M_dp, bins);
    stairs(Xsm,Nsm,'color',c_dodger,'Linewidth',1); hold on;
    [Nss,Xss] = hist(S_S_dp, bins);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;

%     plot(-MM_bdp, MM_dp,'b','Linewidth',2); hold on;  
%     plot(-MM_bdp, MM_dp,'color',c_orange,'Linewidth',2); hold on;     
%     plot(-MS_bdp, MS_dp,'color',c_dodger,'Linewidth',2); hold on;
%     plot(-SM_bdp, SM_dp,'color',c_teal,'Linewidth',2); hold on;
%     plot(-SS_bdp, SS_dp,'color',c_gray,'Linewidth',2); hold on;
    
    grid on;
%     title ('MoGr no MCS or Ionisation: pn Elastic','FontSize',10);
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\Delta dp [GeV]','FontSize',10);
%     set(gca,'FontSize',10,'YScale','log');
%     set(gca,'FontSize',10,'YScale','log','XLim',[-1E-3 0]);
    set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0],'YLim',[0 1E4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0],'YLim',[0 1E4],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot theta
subplot(2,2,3)        % add third plot in 2 x 2 grid
% theta = atan ( sqrt( xp*xp + yp*yp ) );

    [Ns,Xs] = hist(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)), 0:1E-7:1E-4);
    stairs(Xs,Ns,'color','k','Linewidth',1); hold on;
    
    [Nmm,Xmm] = hist(M_M_theta, 0:1E-7:1E-4);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',1); hold on;
    [Nms,Xms] = hist(M_S_theta, 0:1E-7:1E-4);
    stairs(Xms,Nms,'color','r','Linewidth',1); hold on;
    [Nsm,Xsm] = hist(S_M_theta, 0:1E-7:1E-4);
    stairs(Xsm,Nsm,'color',c_dodger,'Linewidth',1); hold on;
    [Nss,Xss] = hist(S_S_theta, 0:1E-7:1E-4);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;   
    
%     plot(MM_btheta, MM_theta,'b','Linewidth',2); hold on;
%     plot(MM_btheta, MM_theta,'color',c_orange,'Linewidth',2); hold on;
%     plot(MS_btheta, MS_theta,'color',c_dodger,'Linewidth',2); hold on;
%     plot(SM_btheta, SM_theta,'color',c_teal,'Linewidth',2); hold on;
%     plot(SS_btheta, SS_theta,'color',c_gray,'Linewidth',2); hold on;
    
    grid on;
%     title ('MoGr no MCS or Ionisation: pn Elastic','FontSize',10);
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\theta [rad]','FontSize',10);
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[0 0.5E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-4],'YLim',[0 5E3]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-4],'YLim',[0 5E3],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot t
subplot(2,2,4)        % add fourth plot in 2 x 2 grid

% t = - (4.9E19)*(theta*theta);

    [Ns,Xs] = hist( (-4.9E19).*(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)).*(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)))), -10E12:1E9:0);
    stairs(Xs,Ns,'color','k','Linewidth',1); hold on;
    [Nmm,Xmm] = hist(M_M_t, -10E12:1E9:0);
    
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',1); hold on;
    [Nms,Xms] = hist(M_S_t, -10E12:1E9:0);
    stairs(Xms,Nms,'color','r','Linewidth',1); hold on;
    [Nsm,Xsm] = hist(S_M_t, -10E12:1E9:0);
    stairs(Xsm,Nsm,'color',c_dodger,'Linewidth',1); hold on;
    [Nss,Xss] = hist(S_S_t, -10E12:1E9:0);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;   

%     plot(MM_bt, MM_t,'b','Linewidth',2); hold on;
%     plot(MM_bt, MM_t,'color',c_orange,'Linewidth',2); hold on;
%     plot(MS_bt, MS_t,'color',c_dodger,'Linewidth',2); hold on;
%     plot(SM_bt, SM_t,'color',c_teal,'Linewidth',2); hold on;
%     plot(SS_bt, SS_t,'color',c_gray,'Linewidth',2); hold on;
    
    grid on;
%     title ('MoGr no MCS or Ionisation: pn Elastic','FontSize',10);
    legend('location', 'northwest', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like', 'MERLIN S Composite', 'MERLIN S ST-like');
%     legend('location', 'northwest', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like', 'MERLIN S Composite', 'MERLIN S ST-like', 'MERLIN M Composite pN Elastic');
%     legend('location', 'northwest', 'SixTrack', 'MERLIN M Composite pN Elastic', 'MERLIN M ST-like pN Elastic', 'MERLIN S Composite pN Elastic', 'MERLIN S ST-like pN Elastic');
    ylabel('Frequency [-]','FontSize',10);
    xlabel('t [GeV^2]','FontSize',10);
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[-5e11 0]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-2e11 0]);
    hold off;
    