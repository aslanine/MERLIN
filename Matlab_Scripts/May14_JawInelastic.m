%% Plot a histogram of JawInelastic 7TeV B1

%% Import data

%% Composite
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/14May_7TeV_NOM_B1/JawInelastic/JI_TCSG.B5L7.B1_Composite.csv';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
Composite = dataArray{:, 1};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Pure
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/14May_7TeV_NOM_B1/JawInelastic/JI_TCSG.B5L7.B1_Pure.csv';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
Pure = dataArray{:, 1};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% MoGr
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/14May_7TeV_NOM_B1/JawInelastic/JI_TCSG.B5L7.B1_MoGr_2e.csv';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
MoGr = dataArray{:, 1};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


%% CuCD
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/14May_7TeV_NOM_B1/JawInelastic/JI_TCSG.B5L7.B1_CuCD_2e.csv';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
CuCD = dataArray{:, 1};

%% Plot

binwidth = 1E-2;
hh=300;

% Range for plot 
% range_4=min(CuCD):(max(CuCD)-min(CuCD))/hh:max(CuCD);
% [N4,X4] = hist(CuCD,range_4);
% stairs(X4,N4/sum(N4)/ (max(CuCD)-min(CuCD)/hh ),'Linewidth',1);
% hold on;
% 
% range_3=min(MoGr):(max(MoGr)-min(MoGr))/hh:max(MoGr);
% [N3,X3] = hist(MoGr,range_3);
% stairs(X3,N3/sum(N3)/ (max(MoGr)-min(MoGr)/hh ),'Linewidth',1);
% hold on;

range_2=min(Pure):(max(Pure)-min(Pure))/hh:max(Pure);
[N2,X2] = hist(Pure,range_2);
stairs(X2,N2/sum(N2)/ (max(Pure)-min(Pure)/hh ),'Linewidth',1);
hold on;

range_1=min(Composite):(max(Composite)-min(Composite))/hh:max(Composite);
[N1,X1] = hist(Composite,range_1);
stairs(X1,N1/sum(N1)/ (max(Composite)-min(Composite)/hh ),'Linewidth',1);
hold on;

grid on;
set(gca,'yscale','log','FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% legend({'CuCD','MoGr','C', 'AC150K'},'FontSize',16);
% legend({'CuCD','MoGr'},'FontSize',16);
legend({'C', 'AC150K'},'FontSize',16);
xlabel('s [m]');
ylabel('PDF');

hold off;

%% Old method

% h4=histogram((CuCD)), hold on;
% h4=histogram((CuCD)), hold on;
% h4.Normalization = 'pdf';
% h4.BinWidth = binwidth;
% 
% h3=histogram((MoGr)), hold on;
% h3=histogram((MoGr)), hold on;
% h3.Normalization = 'pdf';
% h3.BinWidth = binwidth;

% h2=histogram((Pure)), hold on;
% h2=histogram((Pure)), hold on;
% h2.Normalization = 'pdf';
% h2.BinWidth = binwidth;

% h1=histogram((Composite)), hold on;
% h1=histogram((Composite)), hold on;
% h1.Normalization = 'pdf';
% h1.BinWidth = binwidth;


% xlabel('s [m]');
% ylabel('Loss');
% grid on;
% legend('Location', 'northeast', 'CuCD', 'MoGr', 'C', 'AC150K');
% legend('Location', 'northeast', 'C', 'AC150K');
% legend('Location', 'northeast', 'CuCD', 'MoGr');
% grid on;

% set(gca,'yscale','log');

% hold off;

%% AV for reference

% range_MM=min(data_MM{i,1}.data(:,k)):(max(data_MM{i,1}.data(:,k))-min(data_MM{i,1}.data(:,k)))/hh:max(data_MM{i,1}.data(:,k));
% [N_MM,X_MM] = hist(data_MM{i,1}.data(:,k),range_MM);
% range_AC=min(data_AC{i,1}.data(:,k)):(max(data_AC{i,1}.data(:,k))-min(data_AC{i,1}.data(:,k)))/hh:max(data_AC{i,1}.data(:,k));
% [N_AC,X_AC] = hist(data_AC{i,1}.data(:,k),range_AC);
% range_Mo=min(data_Mo{i,1}.data(:,k)):(max(data_Mo{i,1}.data(:,k))-min(data_Mo{i,1}.data(:,k)))/hh:max(data_Mo{i,1}.data(:,k));
% [N_Mo,X_Mo] = hist(data_Mo{i,1}.data(:,k),range_Mo);
% 
% 
% 
% fig1=figure('units','normalized','outerposition',[0 0 1 1]);
% set(gcf,'color','w');
% stairs(X_MM,N_MM/sum(N_MM)/ (max(data_MM{i,1}.data(:,k))-min(data_MM{i,1}.data(:,k))/hh ),'b','Linewidth',3);
% hold on;
% stairs(X_AC,N_AC/sum(N_AC)/ (max(data_AC{i,1}.data(:,k))-min(data_AC{i,1}.data(:,k))/hh ),'r','Linewidth',3);
% hold on;
% stairs(X_Mo,N_Mo/sum(N_Mo)/ (max(data_Mo{i,1}.data(:,k))-min(data_Mo{i,1}.data(:,k))/hh ),'g','Linewidth',3);
% hold on;
% grid on;
% set(gca,'yscale','log','FontSize',24,'PlotBoxAspectratio',[2 2 2],'Linewidth',2,'FontWeight','bold','XLim',[-0.12 0]);
% legend({'CuCD','CFC','MoGr'},'FontSize',26,'FontWeight','bold');
% xlabel('\theta [mrad]');
% ylabel('pdf');