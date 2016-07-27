%% Script to plot ApertureTest
clearvars all;
%% Import Aperture File
% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Thesis/data/AV/Aperture_6p5TeV_beam2.tfs';
% delimiter = ' ';
% formatSpec = '%q%q%q%f%f%f%f%f%f%[^\n\r]';
% fileID = fopen(filename,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
% fclose(fileID);
% 
% m_el = dataArray{:, 1};
% m_name = dataArray{:, 2};
% m_type = dataArray{:, 3};
% m_s = dataArray{:, 4};
% m_L = dataArray{:, 5};
% m_ap1 = dataArray{:, 6};
% m_ap2 = dataArray{:, 7};
% m_ap3 = dataArray{:, 8};
% m_ap4 = dataArray{:, 9};
% clearvars filename delimiter formatSpec fileID dataArray ans;

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_Aperture.tfs';
delimiter = {'\t',' '};
formatSpec = '%*q%*q%*q%f%f%f%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
S = dataArray{:, 1};
L = dataArray{:, 2};
Ap = dataArray{:, 3};
clearvars filename delimiter formatSpec fileID dataArray ans;

% clearvars all;
% fd = fopen('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_Aperture.tfs','rt');
% mydata = textscan(fd, '%*q%*q%*q%f%f%f%*s%*s%*s%*s%[^\n\r]', 'Whitespace', ' \t');
% fclose(fd); 

% clearvars all;
% delimiter = {' '};
% delimitertest = {'\t',' '};
% mydata= importdata('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_Aperture.tfs', delimiter) ;
% mydata= textread('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_Aperture.tfs', 'delimiter', delimitertest) ;
% aperture=[mydata.data(:,3) mydata.data(:,4) mydata.data(:,5) mydata.data(:,6)];
aperture = [S Ap];

%% Import ApertureSurvey
apdirname = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/LatticeTest/12JulyTest/';
% original
apfile = 'Aperture_Survey_0.1_steps_OR_0_points.txt';
apfilename = strcat(apdirname,apfile);
delimiter = '\t';
startRow = 2;
formatSpec = '%s%s%f%f%f%f%f%f%[^\n\r]';
apfileID = fopen(apfilename,'r');
dataArray = textscan(apfileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(apfileID);
% ap_name = dataArray{:, 1};
% ap_type = dataArray{:, 2};
ap_s = dataArray{:, 3};
% ap_length1 = dataArray{:, 4};
ap_px = dataArray{:, 5};
ap_mx = dataArray{:, 6};
ap_py = dataArray{:, 7};
ap_my = dataArray{:, 8};
clearvars apfilename delimiter startRow formatSpec apfileID dataArray ans apdirname apfile;

%% Remove 0 values from aperture file
%  for ii = 1:length(m_s)
%      if ((m_ap1(ii) == 0.0) && (m_ap2(ii) == 0.0) && (m_ap3(ii) == 0.0) && (m_ap4(ii) == 0.0))
%          m_ap1(ii) = NaN;
%          m_ap2(ii) = NaN;
%          m_ap3(ii) = NaN;
%          m_ap4(ii) = NaN;
%      end
% end

% m_ap=[m_s; m_ap1 ; m_ap2;  m_ap3; m_ap4];
% m_ap(~any( m_ap, 2 ), : ) = [];

% index = find(~any(aperture, 2)==0);
index = find(Ap);
% total = horzcat(S, aperture);
total = horzcat(S, Ap);
total = total(index,:);

%% Plot Aperture File
figure;
% circle top
plot(total(:,1),-total(:,2), 'Color', 'red'), hold on
% circle bottom
plot(total(:,1),total(:,2), 'Color', 'blue'), hold on

%% Plot Aperture Survey

% Horizontal Aperture
plot(ap_s, ap_px, '--', 'Color', 'black'), hold on
%plot(ap_s, -ap_mx, '--' ,'Color', 'black'), hold on

% Vertical Aperture
%plot(ap_s, ap_py, '--' , 'Color', 'green'), hold on
plot(ap_s, -ap_my, '--' ,'Color', 'green'), hold on

axis([0,600,-0.1,0.1])
legend({'MADX','MADX','MERLIN','MERLIN'}, 'location', 'northwest');
ylabel('x [m]');
xlabel('s [m]');
grid on;

hold off