%% Plot 1cm material multiplot
clear all;
mat='MoGr';
scatter='singlediffractive';

%% Import 6T raw data
fn = strcat( '/home/HR/Downloads/IPAC16/1cm/input6T/1CM/',mat,'_M/SD.dat');
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
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/M_Comp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/M_Comp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
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

%% Import MERLIN ST Composite data
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/S_Comp/',mat,'/Mselect_scatter_',mat,'_',scatter,'_.txt');
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/S_Comp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
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

%% Import MERLIN M NonComp data
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/M_NonComp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/M_NonComp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
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

%% Import MERLIN ST NonComp data
% fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/25May_NoMCS/S_NonComp/',mat,'/Sselect_scatter_',mat,'_',scatter,'_.txt');
fn = strcat('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/1cm/26May/S_NonComp/',mat,'/select_scatter_',mat,'_',scatter,'_.txt');
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

    [Ns,Xs] = hist(xp_6T, bins);
    stairs(Xs,Ns,'color','k','Linewidth',1); hold on;
    [Nmm,Xmm] = hist(M_M_xp, bins);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',1); hold on;
    [Nms,Xms] = hist(M_S_xp, bins);
    stairs(Xms,Nms,'color','r','Linewidth',1); hold on;
    [Nsm,Xsm] = hist(S_M_xp, bins);
    stairs(Xsm,Nsm,'color',c_dodger,'Linewidth',1); hold on;
    [Nss,Xss] = hist(S_S_xp, bins);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;

    grid on;
%     title (strcat(mat,' no MCS or ionisation: Single Diffractive'),'FontSize',10);
    title (strcat(mat,': Single Diffractive'),'FontSize',10);
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\Delta xp [rad]','FontSize',10);
    set(gca,'FontSize',10,'YScale','log','XLim',[-1E-4 1E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.5E-4 0.5E-4],'YLim',[3E1 3E2],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot dp
subplot(2,2,2)        % add second plot in 2 x 2 grid

    [Ns,Xs] = hist(dp_6T, bins);
    stairs(Xs,Ns,'color','k','Linewidth',1); hold on;
    [Nmm,Xmm] = hist(M_M_dp, bins);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',1); hold on;
    [Nms,Xms] = hist(M_S_dp, bins);
    stairs(Xms,Nms,'color','r','Linewidth',1); hold on;
    [Nsm,Xsm] = hist(S_M_dp, bins);
    stairs(Xsm,Nsm,'color',c_dodger,'Linewidth',1); hold on;
    [Nss,Xss] = hist(S_S_dp, bins);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;

    grid on;
%     title ('MoGr no MCS or Ionisation: pn Elastic','FontSize',10);
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\Delta dp [GeV]','FontSize',10);
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0],'YLim',[0 1E4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-0.15 0],'YLim',[0 1E4],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot theta
subplot(2,2,3)        % add third plot in 2 x 2 grid
% theta = atan ( sqrt( xp*xp + yp*yp ) );

    [Ns,Xs] = hist(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)), bins);
    stairs(Xs,Ns,'color','k','Linewidth',1); hold on;
    [Nmm,Xmm] = hist(M_M_theta, bins);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',1); hold on;
    [Nms,Xms] = hist(M_S_theta, bins);
    stairs(Xms,Nms,'color','r','Linewidth',1); hold on;
    [Nsm,Xsm] = hist(S_M_theta, bins);
    stairs(Xsm,Nsm,'color',c_dodger,'Linewidth',1); hold on;
    [Nss,Xss] = hist(S_S_theta, bins);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;   
    
    grid on;
%     title ('MoGr no MCS or Ionisation: pn Elastic','FontSize',10);
    ylabel('Frequency [-]','FontSize',10);
    xlabel('\theta [rad]','FontSize',10);
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[0 1.5E-4]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-4],'YLim',[0 5E3]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 2E-4],'YLim',[0 5E3],'PlotBoxAspectRatio',[4 2 2]);
    hold off;

%% Plot t
subplot(2,2,4)        % add fourth plot in 2 x 2 grid

% t = - (4.9E19)*(theta*theta);

    [Ns,Xs] = hist( (-4.9E19).*(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)).*(atan(sqrt(xp_6T.*xp_6T + yp_6T.*yp_6T)))), bins);
    stairs(Xs,Ns,'color','k','Linewidth',1); hold on;
    [Nmm,Xmm] = hist(M_M_t, bins);
    stairs(Xmm,Nmm,'color',c_orange,'Linewidth',1); hold on;
    [Nms,Xms] = hist(M_S_t, bins);
    stairs(Xms,Nms,'color','r','Linewidth',1); hold on;
    [Nsm,Xsm] = hist(S_M_t, bins);
    stairs(Xsm,Nsm,'color',c_dodger,'Linewidth',1); hold on;
    [Nss,Xss] = hist(S_S_t, bins);
    stairs(Xss,Nss,'color',c_gray,'Linewidth',1); hold on;   

    grid on;
%     title ('MoGr no MCS or Ionisation: pn Elastic','FontSize',10);
    legend('location', 'northwest', 'SixTrack', 'MERLIN M Composite', 'MERLIN M ST-like', 'MERLIN S Composite', 'MERLIN S ST-like');
    ylabel('Frequency [-]','FontSize',10);
    xlabel('t [GeV^2]','FontSize',10);
%     set(gca,'FontSize',10,'YScale','log');
    set(gca,'FontSize',10,'YScale','log','XLim',[-1e12 0]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[-2e12 0],'YLim',[0 5E3]);
%     set(gca,'FontSize',10,'YScale','log','XLim',[0 -2e12],'YLim',[0 5E3],'PlotBoxAspectRatio',[4 2 2]);
    hold off;
    