%% General TWISS and LatticeFunction Comparison Algorithms

%% Import OLD MERLIN TFS
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_Full_Ring_NoCrossing_Lattice.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
% S_name = dataArray{:, 1};
% S_label = dataArray{:, 2};
M_s = dataArray{:, 3};
% S_L = dataArray{:, 4};
M_betax = dataArray{:, 18};
M_betay = dataArray{:, 19};
M_alphax = dataArray{:, 20};
M_alphay = dataArray{:, 21};
% S_mux = dataArray{:, 22};
% S_muy = dataArray{:, 23};
M_Dx = dataArray{:, 24};
M_Dy = dataArray{:, 25};
% S_Dxp = dataArray{:, 26};
% S_Dyp = dataArray{:, 27};
M_x = dataArray{:, 32};
% S_xp = dataArray{:, 33};
M_y = dataArray{:, 34};
% S_yp = dataArray{:, 35};
% S_ct = dataArray{:, 36};
% S_dp = dataArray{:, 37};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import NEW MERLIN TFS

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/fcc_lattice_dev_0300_crossing_ipl.tfs';
delimiter = ' ';
startRow = 48;
formatSpec = '%q%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
M_s = dataArray{:, 3};
M_betax = dataArray{:, 19};
M_betay = dataArray{:, 20};
M_alphax = dataArray{:, 21};
M_alphay = dataArray{:, 22};
M_Dx = dataArray{:, 25};
M_Dy = dataArray{:, 26};
M_x = dataArray{:, 33};
M_y = dataArray{:, 35};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Import LatticeFunctions

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/FCC_v7_dev/10_APR_format/LatticeFunctions/LatticeFunctions.dat';
formatSpec = '%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%30f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

% Allocate imported array to column variable names
s = dataArray{:, 1};
x = dataArray{:, 2};
% xp = dataArray{:, 3};
y = dataArray{:, 4};
% yp = dataArray{:, 5};
% mu_x_frac = dataArray{:, 6};
% mu_y_frac = dataArray{:, 7};
betax = dataArray{:, 8};
Alpha_x = dataArray{:, 9};
betay = dataArray{:, 10};
Alpha_y = dataArray{:, 11};
D_x_EF = dataArray{:, 12};      % D_x * Energy scaling factor
D_xp_EF = dataArray{:, 13};      
D_y_EF = dataArray{:, 14};      % D_y * Energy scaling factor
D_yp_EF = dataArray{:, 15};
EF = dataArray{:, 16};          % Energy scaling factor


%% Calculate Dispersion from Latticefunctions using right array division

Dx_lf = D_x_EF ./ EF;
Dy_lf = D_y_EF ./ EF;
D_xp = D_xp_EF ./ EF;
D_yp = D_yp_EF ./ EF;

Alpha_x = -1 .* Alpha_x;
Alpha_y = -1 .* Alpha_y;

clearvars filename formatSpec fileID dataArray ans;

%% Import Dispersion
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/FCC/outputs/FCC_v7_dev/10_APR_format/LatticeFunctions/Dispersion.dat';
formatSpec = '%14f%14f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
S_D = dataArray{:, 1};
Dx = dataArray{:, 2};
Dy = dataArray{:, 3};
clearvars filename formatSpec fileID dataArray ans;

%% Interpolate and calculate difference between MADX and MERLIN

xmin = 0; 
xmax = 97749.3853528378;

% interpolation steps
interval = 1E-3;
s_int = 0:interval:xmax;

% create 2D array of data
array_in = horzcat(s, betax);
array_inm = horzcat(M_s, M_betax);

% indices of unique s positions
[~, ind] = unique(array_in(:,1), 'rows', 'first');
[~, indm] = unique(array_inm(:,1), 'rows', 'first');

% arrays of unique s points
test1 = array_in(ind,:);
test2 = array_inm(indm,:);

% interpolate MERLIN and MADX
merlin_int = interp1(test1(:,1), test1(:,2), s_int, 'linear','extrap');
mad_int = interp1(test2(:,1), test2(:,2), s_int, 'linear','extrap');

% plot
plot(s_int, (merlin_int - mad_int) );

%% Interpolate and calculate difference/MADX


xmin = 0; 
xmax = 97749.3853528378;

% interpolation steps
interval = 1E-3;
s_int = 0:interval:xmax;

% create 2D array of data
array_in = horzcat(s, betax);
array_inm = horzcat(M_s, M_betax);

% indices of unique s positions
[~, ind] = unique(array_in(:,1), 'rows', 'first');
[~, indm] = unique(array_inm(:,1), 'rows', 'first');

% arrays of unique s points
test1 = array_in(ind,:);
test2 = array_inm(indm,:);

% interpolate MERLIN and MADX
merlin_int = interp1(test1(:,1), test1(:,2), s_int, 'linear','extrap');
mad_int = interp1(test2(:,1), test2(:,2), s_int, 'linear','extrap');

% test3 = difference
test3 = double.empty;
test3 = merlin_int - mad_int;

% test4 = difference/MADX
test4 = (test3./mad_int)*100;

% plot
plot(s_int, test4);
