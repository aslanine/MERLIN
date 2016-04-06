%% Script to merge split data and plot no_particles for HEL cleaning

%% Import data files
clear all;

turns = 100000;
turns = turns + 1;

%% Round beam

cd('/home/HR/Downloads/HEL_Runs/R/');
list = dir('*.txt'); 

R = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        R(:,1) = A(:,1);
        R(:,2) = A(:,2);
    else    
        R(:,2) = R(:,2) + A(:,2);
    end
end

npart = R(1,2)

clear A list;

%% Non-Round beam

cd('/home/HR/Downloads/HEL_Runs/NR/');
list = dir('*.txt'); 

NR = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        NR(:,1) = A(:,1);
        NR(:,2) = A(:,2);
    else    
        NR(:,2) = NR(:,2) + A(:,2);
    end
end

clear A list;

%% Non-Round beam Elliptical scaled

cd('/home/HR/Downloads/HEL_Runs/NR_EL/');
list = dir('*.txt'); 

NREl = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        NREl(:,1) = A(:,1);
        NREl(:,2) = A(:,2);
    else    
        NREl(:,2) = NREl(:,2) + A(:,2);
    end
end

clear A list;

%% Non-Round beam Elliptical nonscaled

cd('/home/HR/Downloads/HEL_Runs/NR_El2/');
list = dir('*.txt'); 

NREl2 = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        NREl2(:,1) = A(:,1);
        NREl2(:,2) = A(:,2);
    else    
        NREl2(:,2) = NREl2(:,2) + A(:,2);
    end
end

clear A list;
%% Non-Round beam Elliptical nonscaled

cd('/home/HR/Downloads/HEL_Runs/Hula/');
list = dir('*.txt'); 

Hula = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        Hula(:,1) = A(:,1);
        Hula(:,2) = A(:,2);
    else    
        Hula(:,2) = Hula(:,2) + A(:,2);
    end
end

clear A list;

%% Plot

figure;

plot(R(:,1), R(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 4), hold on
plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'c', 'LineWidth', 4), hold on
plot(NREl(:,1), NREl(:,2)/npart, '-', 'Color', 'm', 'LineWidth', 4), hold on
plot(NREl2(:,1), NREl2(:,2)/npart, '--', 'Color', 'g', 'LineWidth', 4), hold on
plot(Hula(:,1), Hula(:,2)/npart, '-.', 'Color', 'r', 'LineWidth', 4), hold on
legend('Round', 'Non-Round', 'Non-Round Elliptical', 'Non-Round Elliptical Unscaled', 'Non-Round Hula')

% title('HL-LHC Diffusive HEL for Round (blue), Non-Round (red), NR Elliptical (yellow), NR Elliptical2 (green)')
xlabel('Turn [-]')
ylabel('N/N_0 [-]')

hold off
