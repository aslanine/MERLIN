%% Script to plot material scattered final distribution histogram etc
%% Incomplete - histogram not playing nicely for normalisation
clear all;
% matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual');
set(groot,'defaultFigurePaperPositionMode','manual');
%% Iterate through all files in a directory
cd('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/26Mar16_multi_mat/Bunch_Distn/');

% creates a list of all final_bunch files
final_list = dir('final_bunch*'); 

% we must cut the element names from the file names and make a list of them
materials = cell((length(final_list)), 1);
% also make a cell to hold the data arrays
element_data = cell(length(final_list),1);
% another for output filenames
output_file = cell(length(final_list),1);

for ii = 1:length(final_list)
%     names = cell(10,1);
%     for i=1:10
%         names{i} = ['Sample Text ' num2str(i)];
%     end 
    % create a string of the filename
    str = final_list(ii).name;
    % split the string by the delimiter '_' into cell array split_final_name
    split_final_name = strsplit(str,'_');
    % current element
    element = split_final_name(3);
    
    materials{ii} = [element];    
    
% end

%% Import final distribution
directory = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/26Mar16_multi_mat/Bunch_Distn/';
filename = strcat(directory, final_list(1).name);
formatSpec = '%35f%35f%35f%35f%35f%35f%35f%35f%35f%35f%35f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
fclose(fileID);
% S = dataArray{:, 1};
% E = dataArray{:, 2};
% x = dataArray{:, 3};
% xp = dataArray{:, 4};
% y = dataArray{:, 5};
% yp = dataArray{:, 6};
% ct = dataArray{:, 7};
% dp = dataArray{:, 8};
% type = dataArray{:, 9};
% location = dataArray{:, 10};
% id = dataArray{:, 11};
% sd = dataArray{:, 12};

% element data [ x, xp, y, yp, dp, type]
element_data{ii}=[dataArray(:,3) dataArray(:,4) dataArray(:,5) dataArray(:,6) dataArray{:, 8} dataArray(:,9)];
% end

%% Open Figure
f_x = 'Material_x_';
f_xp = 'Material_xp_';
f_dp = 'Material_dp_';
file_end = '.png';
% output_file{ii} = strcat(file_start,element,file_end); 
% of = strcat(file_start,element,file_end);
%% Plot x
% figure('Position', [100, 100, 800, 2400]);
figure('units','pixels','Position',[100 100 800 2400]);

npart = length(element_data{ii}{1});
nbins = 100;
% returns the histogram for the first element, first column
% h = histogram( element_data{ii}{1}, nbins), hold on;
[n, xout] = hist( element_data{ii}{1}, nbins), hold on;
bar(xout, n/npart, 'barwidth', 1, 'basevalue', 1), hold on;
set(gca,'YScale','log');

% title('HL-LHC Diffusive HEL for Round (blue), Non-Round (red), NR Elliptical (yellow), NR Elliptical2 (green)')
xlabel('x [m]');
ylabel('N');
xlim([-100E-6 100E-6]);

% ofx = char(strcat(f_x,element,file_end));
print(gcf, '-dpng', char(strcat(f_x,element,file_end))), hold on;

%% Plot xp
clear figure;
figure('units','pixels','Position',[100 100 800 2400]);

% returns the histogram for the first element, first column
% h = histogram( element_data{ii}{3}, nbins), hold on;
[n, xout] = hist( element_data{ii}{3}, nbins), hold on;
bar(xout, n, 'barwidth', 1, 'basevalue', 1), hold on;
set(gca,'YScale','log');

% title('HL-LHC Diffusive HEL for Round (blue), Non-Round (red), NR Elliptical (yellow), NR Elliptical2 (green)')
xlabel('xp [rad]');
ylabel('N');
xlim([-100E-6 100E-6]);

% ofxp = char(strcat(f_x,element,file_end));
print(gcf, '-dpng',char(strcat(f_xp,element,file_end))), hold on;

%% Plot dp
clear figure;
figure('units','pixels','Position',[100 100 800 2400]);

% returns the histogram for the first element, first column
% h = histogram( element_data{ii}{5}, nbins), hold on;
[n, xout] = hist( element_data{ii}{5}, nbins), hold on;
bar(xout, n, 'barwidth', 1, 'basevalue', 1), hold on;
set(gca,'YScale','log');
set(gca,'XScale','log');

xlabel('dp [-]');
ylabel('N');

print(gcf, '-dpng',char(strcat(f_dp,element,file_end))), hold on;

% hold off;
% saveas(figure, 'test.png');
% print('test.png');

% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 9])
% set(gcf, 'Units', 'Inches', 'Position', [0, 0, 10, 30], 'PaperUnits', 'Inches', 'PaperSize', [3, 9])
% print(gcf, '-dpng','test.png')
hold off;
clearvars filename formatSpec fileID dataArray ans file_start file_end element split_final_name str h figure subplot;
end
