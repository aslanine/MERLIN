%% Script to plot Aperture file

clearvars all;
%% Import Aperture File

% filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_v7_DS_0300_Aperture.tfs';
% delimiter = {'\t',' '};
% formatSpec = '%*q%*q%*q%f%f%f%*s%*s%*s%*s%[^\n\r]';
% fileID = fopen(filename,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
% fclose(fileID);
% S = dataArray{:, 1};
% L = dataArray{:, 2};
% Ap = dataArray{:, 3};
% clearvars filename delimiter formatSpec fileID dataArray ans;


filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/FCC/Input/FCC_v7_DS_0300_Aperture.tfs';
delimiter = ' ';
formatSpec = '%*q%*q%f%f%f%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
S = dataArray{:, 1};
L = dataArray{:, 2};
Ap = dataArray{:, 3};
clearvars filename delimiter formatSpec fileID dataArray ans;

aperture = [S Ap];


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

axis([0,98000,-0.12,0.12])
legend({'MADX','MADX','MERLIN','MERLIN'}, 'location', 'northwest');
ylabel('x [m]');
xlabel('s [m]');
grid on;

hold off