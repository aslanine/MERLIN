%% Script to plot apertures and particle tracks

%% Import Transport Tracking data
tdir = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/SymplecticLossMap/AlessiaTest/';
tfile = 'Tracking_output_file100000_1.txt';
tfilename = strcat(tdir,tfile);
delimiter = ' ';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%f%[^\n\r]';
tfileID = fopen(tfilename,'r');
dataArray = textscan(tfileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(tfileID);
t_id = dataArray{:, 1};
t_turn = dataArray{:, 2};
t_s = dataArray{:, 3};
t_x = dataArray{:, 4};
t_xp = dataArray{:, 5};
t_y = dataArray{:, 6};
t_yp = dataArray{:, 7};
t_dp = dataArray{:, 8};
t_type = dataArray{:, 9};
clearvars tfilename delimiter startRow formatSpec tfileID tfile tdir dataArray ans;

%% Import ApertureSurvey
apdirname = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/SymplecticLossMap/AlessiaTest/';
apfile = 'Aperture_Survey_0.1_steps_OR_0_points.txt';
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

%% SUBPLOTS
figure
subplot(2,1,1)

%% PLOT HORIZONTAL
%% Plot apertures
% plot positive and negative apertures (assuming symmetric)
plot(ap_s, ap_px, 'Color', 'black'), hold on
plot(ap_s, -ap_mx,'Color', 'black' ), hold on

%{
%% sort and plot transport tracking data
% % find first turn only
%turn1=find(t_turn==1);

% create array to hold all data for turn 1
%All=[t_id(turn1),t_x(turn1)*1E-3,t_y(turn1)*1E-3,t_s(turn1),t_turn(turn1)];
All=[t_id,t_x*1E-3,t_y*1E-3,t_s,t_turn];

% sort the array
All_sorted=sortrows(All,1);

% remove non scattered
fff=[0;find(diff(All_sorted(:,1))~=0)];
fff=[0;fff];

zz=All_sorted(:,4);
cc=All_sorted(:,2);

% jet is a colour toolkit
%c=jet(length(All_sorted));

%for i=1:length(All_sorted)-1
%   plot( zz(All_sorted(i)+1:All_sorted(i+1)), cc(All_sorted(i)+1:All_sorted(i+1)), 'Color',c(i,:));
for i=1:length(fff)-1
   plot(zz(fff(i)+1:fff(i+1)),cc(fff(i)+1:fff(i+1)),'Color','Green');
   %ylim([0.0015 0.001535])
   hold on;
   %legendInfo{i} = ['X = ' num2str(All_sorted(f(i+1)))];
end
%}

%% Plot using Alessia's fancy stuff

t_x=t_x/1000;

tracked_table=[t_id,t_s,t_x,t_type,t_turn];
tracked_table_sorted=sortrows(tracked_table,1);

changeindex=(diff(tracked_table_sorted(:,1))~=0);

f=find(changeindex==1);
f=[0;f];

for i=1:length(f)-1
     if tracked_table_sorted(f(i)+1:f(i+1),4)==1
plot(tracked_table_sorted(f(i)+1:f(i+1),2),tracked_table_sorted(f(i)+1:f(i+1),3),'LineWidth',0.5,'color','r');
         hold on
     elseif tracked_table_sorted(f(i)+1:f(i+1),4)==2
plot(tracked_table_sorted(f(i)+1:f(i+1),2),tracked_table_sorted(f(i)+1:f(i+1),3),'LineWidth',0.5,'color','g');
         hold on
     elseif tracked_table_sorted(f(i)+1:f(i+1),4)==3
plot(tracked_table_sorted(f(i)+1:f(i+1),2),tracked_table_sorted(f(i)+1:f(i+1),3),'LineWidth',1.5,'color','b');
         hold on
     elseif tracked_table_sorted(f(i)+1:f(i+1),4)==4
plot(tracked_table_sorted(f(i)+1:f(i+1),2),tracked_table_sorted(f(i)+1:f(i+1),3),'LineWidth',1.5,'color','m')
         hold on;
     elseif tracked_table_sorted(f(i)+1:f(i+1),4)==6
plot(tracked_table_sorted(f(i)+1:f(i+1),2),tracked_table_sorted(f(i)+1:f(i+1),3),'LineWidth',0.5,'color','k');
         hold on
         i=i+1;
     end
end


%% plot particle tracks (crude single line)
%plot(S, x/1E3), hold on

%intid = int64(id);

% try and sort through each particle id and plot
%for i = 1:length(x)
%    for j = 1:99
%        if (intid(j) == i)
%           plot(S,x(i)), hold on
%        end
%    end
%end

%% HORIZONTAL plot settings

%fig1=figure('units','normalized','outerposition', [1,1,0,0]);

% Set plot axis limits
%axis([0,26659,0,0.05])
axis([19780,20400,-0.02,0.02])
%axis([23580,23590,-0.05,0.05])
yt=0.75;
xt=0.8;
annotation('textbox', 'Position', [xt yt+0.02 .10 .10],'EdgeColor','none','Fontsize',8, 'String', 'Elastic pN','Color', 'g' );
annotation('textbox', 'Position', [xt yt+0.04 .10 .10],'EdgeColor','none','Fontsize',8, 'String', 'Elastic pn', 'Color', 'b');
annotation('textbox', 'Position', [xt yt+0.06 .10 .10],'EdgeColor','none', 'Fontsize',8,'String', 'Single Diffractive','Color', 'm');

title('HORIZONTAL')
xlabel('s [m]')
ylabel('y [m]')
hold off
%% PLOT VERTICAL
%fig2=figure();
subplot(2,1,2)
%% Plot apertures
% plot positive and negative apertures (assuming symmetric)
plot(ap_s, ap_py, 'Color', 'black'), hold on
plot(ap_s, -ap_my,'Color', 'black' ), hold on

%% Plot using Alessia's fancy stuff

t_y=t_y/1000;

ytracked_table=[t_id,t_s,t_y,t_type,t_turn];
ytracked_table_sorted=sortrows(ytracked_table,1);

ychangeindex=(diff(ytracked_table_sorted(:,1))~=0);

yf=find(ychangeindex==1);
yf=[0;f];

for i=1:length(yf)-1
     if ytracked_table_sorted(yf(i)+1:yf(i+1),4)==1
plot(ytracked_table_sorted(yf(i)+1:yf(i+1),2),ytracked_table_sorted(yf(i)+1:yf(i+1),3),'LineWidth',0.5,'color','r');
         hold on
     elseif ytracked_table_sorted(yf(i)+1:yf(i+1),4)==2
plot(ytracked_table_sorted(yf(i)+1:yf(i+1),2),ytracked_table_sorted(yf(i)+1:yf(i+1),3),'LineWidth',0.5,'color','g');
         hold on
     elseif ytracked_table_sorted(yf(i)+1:yf(i+1),4)==3
plot(ytracked_table_sorted(yf(i)+1:yf(i+1),2),ytracked_table_sorted(yf(i)+1:yf(i+1),3),'LineWidth',1.5,'color','b');
         hold on
     elseif ytracked_table_sorted(yf(i)+1:yf(i+1),4)==4
plot(ytracked_table_sorted(yf(i)+1:yf(i+1),2),ytracked_table_sorted(yf(i)+1:yf(i+1),3),'LineWidth',1.5,'color','m')
         hold on;
     elseif ytracked_table_sorted(yf(i)+1:yf(i+1),4)==6
plot(ytracked_table_sorted(yf(i)+1:yf(i+1),2),ytracked_table_sorted(yf(i)+1:yf(i+1),3),'LineWidth',0.5,'color','k');
         hold on
         i=i+1;
     end
end

%% VERTICAL Plot settings
title('VERTICAL')
axis([19780,20400,-0.01,0.01])
xlabel('s [m]')
ylabel('y [m]')
hold off
clear all;