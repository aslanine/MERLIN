%% Plot TFS vs MADX Aperture

%% Import Aperture File

clear all;
mydata= importdata('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Thesis/data/AV/Aperture_6p5TeV_beam2.tfs') ;
aperture=[mydata.data(:,3) mydata.data(:,4) mydata.data(:,5) mydata.data(:,6)];

figure;

%% Import ApertureSurvey
apdirname = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/6p5TeV/22_May_Aperture/';
% original
apfile = 'Aperture_Survey_0.01_steps_OR_0_points.txt';
% apfile = 'Aperture_Survey_0.05_steps_OR_0_points.txt';
% fixed rectellipse
% apfile = 'Aperture_Survey_0.01_steps_OR_0_points_rectfix.txt';
apfilename = strcat(apdirname,apfile);
delimiter = '\t';
startRow = 2;
formatSpec = '%s%s%f%f%f%f%f%f%[^\n\r]';
apfileID = fopen(apfilename,'r');
dataArray = textscan(apfileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(apfileID);
ap_name = dataArray{:, 1};
ap_type = dataArray{:, 2};
ap_s = dataArray{:, 3};
ap_length1 = dataArray{:, 4};
ap_px = dataArray{:, 5};
ap_mx = dataArray{:, 6};
ap_py = dataArray{:, 7};
ap_my = dataArray{:, 8};
clearvars apfilename delimiter startRow formatSpec apfileID dataArray ans apdirname apfile;


%% Remove 0 values from aperture file
index=find(~any( aperture, 2 )==0);
total=horzcat(mydata.data(:,1) ,aperture);
total=total(index,:);

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot Aperture File
% Rectangle Half Height (vertical ap)
% plot(total(:,1),total(:,3), 'Color', 'red'), hold on
% plot(total(:,1),-total(:,3), 'Color', 'red'), hold on

% Rectangle Half Width (horizontal ap)
plot(total(:,1),total(:,2), 'Color', c_dodger), hold on
plot(total(:,1),-total(:,2), 'Color', c_dodger), hold on

%% Plot Aperture Survey

% Horizontal Aperture
plot(ap_s, ap_px, 'Color', c_orange), hold on
plot(ap_s, -ap_mx, 'Color', c_orange), hold on

% Vertical Aperture
%plot(ap_s, ap_py, '--' , 'Color', 'green'), hold on
% plot(ap_s, -ap_my,'Color', 'black'), hold on

%axis([0,100,-0.1,0.1])

%full
% xmin = 0;
% xmax = 26659;
%IR3
% xmin = 6400;
% xmax = 7000;
%IR7
% xmin = 19780;
% xmax = 20280;
%IR5
xmin = 13000;
xmax = 13600;


ymin = -0.05;
ymax = 0.05;

legend('location','east','MADX','','MERLIN','');
ylabel('x [m]');
xlabel('s [m]');
grid on;

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[xmin xmax],'YLim',[ymin ymax]);

hold off