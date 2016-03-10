%% Script to plot apertures only

%% Import ApertureSurvey
apdirname = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/AV/10Mar16_Ap_test/';
apfile = 'Aperture_Survey_0.01_steps_OR_0_points.txt';
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

%% Plot settings

plot(ap_s, ap_px, 'Color', 'black'), hold on
plot(ap_s, -ap_mx,'Color', 'black' ), hold on

axis([0,30,-0.05,0.05])

hold off