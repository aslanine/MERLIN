%% Script to plot JawImpact, jaw half gaps from collimator_survey, and initial distn
%% Import JawImpact
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/AV/10Mar16_Ap_test/jaw_impact_TCP.C6R7.B2_0.txt';
delimiter = ' ';
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
startRow = 2;
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);


ji_id = dataArray{:, 1};
ji_x = dataArray{:, 2};
ji_px = dataArray{:, 3};
ji_y = dataArray{:, 4};
ji_yp = dataArray{:, 5};
ji_ct = dataArray{:, 6};
ji_dp = dataArray{:, 7};
ji_turn = dataArray{:, 8};

clearvars filename delimiter formatSpec fileID dataArray ans;

%% Import initial bunch
filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/AV/10Mar16_Ap_test/_0initial_bunch.txt';
formatSpec = '%35f%35f%35f%35f%35f%35f%35f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
b_s = dataArray{:, 1};
b_E = dataArray{:, 2};
b_x = dataArray{:, 3};
b_xp = dataArray{:, 4};
b_y = dataArray{:, 5};
b_yp = dataArray{:, 6};
b_ct = dataArray{:, 7};
b_dp = dataArray{:, 8};
clearvars filename formatSpec fileID dataArray ans;

%% Plot JawImpact
scatter(ji_x, ji_y, 5, 'filled'), hold on


%% Plot tracked back 10cm bunch

% track back a bin
% for ii = 1:length(b_x)
%     b_x(ii) = b_x(ii) - 0.1*b_xp(ii);
%     b_y(ii) = b_y(ii) - 0.1*b_yp(ii);
% end
% track forward a bin
% for ii = 1:length(b_x)
%     b_x(ii) = b_x(ii) + 0.1*b_xp(ii);
%     b_y(ii) = b_y(ii) + 0.1*b_yp(ii);
% end

% scatter((b_x + 0.1*b_xp), (b_y + 0.1*b_yp), 5), hold on

%% Plot initial bunch
scatter(b_x, b_y, 5), hold on

%% Plot jaw half gaps

% positive gap
pgap = 0.00151633;
line([pgap pgap],[-1E-3 1E-3]), hold on
%negative gap
ngap = pgap;
line([-ngap -ngap],[-1E-3 1E-3]), hold on

%% Plot options
minx = 1.5E-3;
maxx = 1.57E-3;
% minx = -1.57E-3;
% maxx = -1.5E-3;

miny = -1E-3; 
maxy = 1E-3;
axis([minx,maxx,miny,maxy])

hold off;
clear all;