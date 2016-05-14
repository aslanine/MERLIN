%% Plot Aperture Survey using different methods of setting the half gap

%% Coll_Survey no matching
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/7TeV_nominal_B1/10May_AperturePlots/coll_no.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

Ns = dataArray{:, 1};
N_px = dataArray{:, 2};
N_mx = dataArray{:, 3};
N_py = dataArray{:, 4};
N_my = dataArray{:, 5};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Coll_Survey matching
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/7TeV_nominal_B1/10May_AperturePlots/coll_match.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

Ms = dataArray{:, 1};
M_px = dataArray{:, 2};
M_mx = dataArray{:, 3};
M_py = dataArray{:, 4};
M_my = dataArray{:, 5};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;
%% Coll_Survey MidJaw
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/7TeV_nominal_B1/10May_AperturePlots/coll_mid.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%*s%*s%*s%*s%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

Js = dataArray{:, 1};
J_px = dataArray{:, 2};
J_mx = dataArray{:, 3};
J_py = dataArray{:, 4};
J_my = dataArray{:, 5};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Matched no MidJaw
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/7TeV_nominal_B1/10May_AperturePlots/Ap_Beam.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*q%*q%f%*q%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

Mat_s = dataArray{:, 1};
Mat_ap_px = dataArray{:, 2};
Mat_ap_mx = dataArray{:, 3};
Mat_ap_py = dataArray{:, 4};
Mat_ap_my = dataArray{:, 5};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Matched with MidJaw
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/7TeV_nominal_B1/10May_AperturePlots/Ap_Beam_Mid.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*q%*q%f%*q%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

Mid_s = dataArray{:, 1};
Mid_ap_px = dataArray{:, 2};
Mid_ap_mx = dataArray{:, 3};
Mid_ap_py = dataArray{:, 4};
Mid_ap_my = dataArray{:, 5};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Not matched, no MidJaw
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/7TeV_nominal_B1/10May_AperturePlots/Ap_NoBeam.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%*q%*q%f%*q%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

N_s = dataArray{:, 1};
N_ap_px = dataArray{:, 2};
N_ap_mx = dataArray{:, 3};
N_ap_py = dataArray{:, 4};
N_ap_my = dataArray{:, 5};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot

% Horizontal unmatched
% plot(Ns, N_px, 'Color', 'black'), hold on;                       % Coll_Survey
% plot(N_s, N_ap_px, 'Color', 'black'), hold on;                
% plot(N_s, -N_ap_mx, 'Color', 'black'), hold on;

% Horizontal Matched
% plot(Ms, M_px, '--', 'Color', c_dodger), hold on;               % Coll_Survey
% plot(Mat_s, Mat_ap_px, '--', 'Color', c_dodger), hold on;
% plot(Mat_s, -Mat_ap_mx, '--', 'Color', c_dodger), hold on;

% Horizontal Matched + MidJaw
% plot(Js, J_px, ':', 'Color', c_orange), hold on;               % Coll_Survey
plot(Mid_s, Mid_ap_px, '-', 'Color', c_orange), hold on;
% plot(Mid_s, -Mid_ap_mx, '-', 'Color', c_orange), hold on;
% plot(Mid_s, Mid_ap_px, '-', 'Color', c_orange), hold on;
% plot(Mid_s, -Mid_ap_mx, '-', 'Color', c_orange), hold on;
plot(Mid_s, Mid_ap_py, '-', 'Color', c_dodger), hold on;
% plot(Mid_s, -Mid_ap_my, '-', 'Color', c_dodger), hold on;

% legend('location', 'north', 'UnMatched', 'Matched', 'Matched+MidJaw')
% legend('location', 'north', 'UnMatched +ve', 'UnMatched -ve', 'Matched +ve', 'Matched -ve', 'Matched+MidJaw +ve', 'Matched+MidJaw -ve')
% legend('location', 'north', 'MidJaw +ve x', 'MidJaw -ve x', 'MidJaw +ve y', 'MidJaw -ve y');
legend('location', 'north', 'MidJaw +ve x', 'MidJaw +ve y');

% Set plot axis limits
%axis([0,26659,0,0.05])
% axis([19780,26659,-0.05,0.05])
% axis([19700,20300,-0.05,0.05])
% axis([19780,19800,-0.01,0.01])
% axis([23580,23590,-0.05,0.05])

%% Zoom to positive TCP.C6L7.B1
% axis([19790.8,19791.6,1.585E-3,1.61E-3])
% axis([19790.6,19791.8,-0.05,0.05]) % TCP
axis([19785,19800,0,0.02]) % TCP pos
% axis([6390,6950,-0.05,0.05]) % IR3
% axis([6450,6950,0,0.02]) % IR3 pos

xlabel('s [m]');
ylabel('x,y [m]');
grid on;

hold off;
