%% Script to plot material scattered final distribution histogram etc
% Plots all materials on a single figure for x, xp, dp
clear all;
% matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual');
set(groot,'defaultFigurePaperPositionMode','manual');

%% Iterate through all files in a directory
direc  = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/28Mar16_NonComposite/Bunch_Distn/Compare/';
% cd('/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/28Mar16_NonComposite/Bunch_Distn/Compare/');
cd(direc);

% creates a list of all final_bunch files
final_list = dir('hist*'); 

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
    element = split_final_name(2);
    
    materials{ii} = [element];    
    Names(ii,:) = element;
    
% end

%% Import final distribution
% directory = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/MaterialTest/28Mar16_NonComposite/Bunch_Distn/Compare/';
directory = direc;
filename = strcat(directory, final_list(ii).name);
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
% x_bw = dataArray{:, 1};
% x = dataArray{:, 2};
% xp_bw = dataArray{:, 3};
% xp = dataArray{:, 4};
% y_bw = dataArray{:, 5};
% y = dataArray{:, 6};
% yp_bw = dataArray{:, 7};
% yp = dataArray{:, 8};
% dp_bw = dataArray{:, 9};
% dp = dataArray{:, 10};

% element data [ bin, x, xp, y, yp, dp]
element_data{ii}=[dataArray(:,1) dataArray(:,2) dataArray(:,3) dataArray(:,4) dataArray{:, 5} dataArray(:,6) dataArray(:,7) dataArray(:,8) dataArray(:,9) dataArray(:,10)];
end

%% Open Figure
f_x = 'Material_comparison_x';
f_xp = 'Material_comparison_xp';
f_dp = 'Material_comparison_dp';
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
% [n, xout] = hist( element_data{ii}{1}, nbins), hold on;
% bar(element_data{ii}{2}, element_data{ii}{1}, 'barwidth', 1, 'basevalue', 1), hold on;
for ii = 1:length(final_list)
    plot(element_data{ii}{1}, element_data{ii}{2}), hold on;
%     legend_info{ii} = [materials{ii}];
    set(gca,'YScale','log');
    xlim([-50E-6 50E-6]);
end

legend(Names);

% title('HL-LHC Diffusive HEL for Round (blue), Non-Round (red), NR Elliptical (yellow), NR Elliptical2 (green)')
xlabel('x [m]');
ylabel('N');

% ofx = char(strcat(f_x,element,file_end));
print(gcf, '-dpng', char(strcat(f_x,file_end))), hold on;

%% Plot xp
clear figure;
figure('units','pixels','Position',[100 100 800 2400]);

% returns the histogram for the first element, first column
% h = histogram( element_data{ii}{3}, nbins), hold on;
% [n, xout] = hist( element_data{ii}{3}, nbins), hold on;
% bar(element_data{ii}{3}, element_data{ii}{1}, 'barwidth', 1, 'basevalue', 1), hold on;
for ii = 1:length(final_list)
    plot(element_data{ii}{3}, element_data{ii}{4}), hold on;
%     legend_info{ii} = [materials{ii}];
    set(gca,'YScale','log');
    xlim([-100E-6 100E-6]);
end

legend(Names);

% title('HL-LHC Diffusive HEL for Round (blue), Non-Round (red), NR Elliptical (yellow), NR Elliptical2 (green)')
xlabel('xp [rad]');
ylabel('N');

% ofxp = char(strcat(f_x,element,file_end));
print(gcf, '-dpng',char(strcat(f_xp,file_end))), hold on;

%% Plot dp
clear figure;
figure('units','pixels','Position',[100 100 800 2400]);

% returns the histogram for the first element, first column
% h = histogram( element_data{ii}{5}, nbins), hold on;
% [n, xout] = hist( element_data{ii}{5}, nbins), hold on;
% bar(element_data{ii}{6}, element_data{ii}{1}, 'barwidth', 1, 'basevalue', 1), hold on;
plot(element_data{ii}{9}, element_data{ii}{10}), hold on;
for ii = 1:length(final_list)
    plot(element_data{ii}{9}, element_data{ii}{10}), hold on;
    set(gca,'YScale','log');
    set(gca,'XScale','log');
%     xlim([0.001 0.1]);
end

legend(Names);

xlabel('dp [-]');
ylabel('N');

print(gcf, '-dpng',char(strcat(f_dp,file_end))), hold on;

% hold off;
% saveas(figure, 'test.png');
% print('test.png');

% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 9])
% set(gcf, 'Units', 'Inches', 'Position', [0, 0, 10, 30], 'PaperUnits', 'Inches', 'PaperSize', [3, 9])
% print(gcf, '-dpng','test.png')
hold off;
clearvars filename formatSpec fileID dataArray ans file_start file_end element split_final_name str h figure subplot;
% end