%% Script to merge split data and plot no_particles for HEL cleaning

%% Import data files
clear all;

turns = 100000;
longturns = 200000;
turns = turns + 1;
longturns = longturns + 1;

%% Round beam

cd('/home/HR/Downloads/HEL_Runs/Initial/R/');
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

npart = R(1,2);

clear A list;

%% Round beam long

cd('/home/HR/Downloads/HEL_Runs/Long/R/');
list = dir('*.txt'); 

RL = zeros(longturns, 2);
A = zeros(longturns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        RL(:,1) = A(:,1);
        RL(:,2) = A(:,2);
    else    
        RL(:,2) = RL(:,2) + A(:,2);
    end
end

clear A list;

%% Non-Round beam

cd('/home/HR/Downloads/HEL_Runs/Initial/NR/');
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

%% Oval beam

cd('/home/HR/Downloads/HEL_Runs/119/119/');
list = dir('*.txt'); 

O = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        O(:,1) = A(:,1);
        O(:,2) = A(:,2);
    else    
        O(:,2) = O(:,2) + A(:,2);
    end
end

clear A list;

%% Oval Elliptical beam

cd('/home/HR/Downloads/HEL_Runs/119/119_El/');
list = dir('*.txt'); 

OEl = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        OEl(:,1) = A(:,1);
        OEl(:,2) = A(:,2);
    else    
        OEl(:,2) = OEl(:,2) + A(:,2);
    end
end

clear A list;

%% Oval Hula beam

cd('/home/HR/Downloads/HEL_Runs/119/119_Hula/');
list = dir('*.txt'); 

OHula = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        OHula(:,1) = A(:,1);
        OHula(:,2) = A(:,2);
    else    
        OHula(:,2) = OHula(:,2) + A(:,2);
    end
end

clear A list;

%% Oval Hula beam redo

cd('/home/HR/Downloads/HEL_Runs/119/119_Hula/');
list = dir('*.txt'); 

OHula2 = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        OHula2(:,1) = A(:,1);
        OHula2(:,2) = A(:,2);
    else    
        OHula2(:,2) = OHula2(:,2) + A(:,2);
    end
end

clear A list;
%% Non-Round beam Elliptical scaled

cd('/home/HR/Downloads/HEL_Runs/Initial/NR_EL/');
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

cd('/home/HR/Downloads/HEL_Runs/Initial/NR_El2/');
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
%% Non-Round beam Hula

cd('/home/HR/Downloads/HEL_Runs/Initial/NR_Hula/');
list = dir('*.txt'); 

NRHula = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        NRHula(:,1) = A(:,1);
        NRHula(:,2) = A(:,2);
    else    
        NRHula(:,2) = NRHula(:,2) + A(:,2);
    end
end

clear A list;

%% Non-Round beam Hula long

cd('/home/HR/Downloads/HEL_Runs/Long/NR_Hula/');
list = dir('*.txt'); 

NRHulaL = zeros(longturns, 2);
A = zeros(longturns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        NRHulaL(:,1) = A(:,1);
        NRHulaL(:,2) = A(:,2);
    else    
        NRHulaL(:,2) = NRHulaL(:,2) + A(:,2);
    end
end

clear A list;

%% Non Round beam Pogo

cd('/home/HR/Downloads/HEL_Runs/119/88_Pogo/');
list = dir('*.txt'); 

NRPogo = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        NRPogo(:,1) = A(:,1);
        NRPogo(:,2) = A(:,2);
    else    
        NRPogo(:,2) = NRPogo(:,2) + A(:,2);
    end
end

clear A list;
%% Oval beam Pogo

cd('/home/HR/Downloads/HEL_Runs/119/119_Pogo/');
list = dir('*.txt'); 

OPogo = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        OPogo(:,1) = A(:,1);
        OPogo(:,2) = A(:,2);
    else    
        OPogo(:,2) = OPogo(:,2) + A(:,2);
    end
end

clear A list;
%% Plot

figure;

%% List of all data

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% IP4 - 30m Round beam diffusive
% R - grey solid
% plot(R(:,1), R(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on

% R long
% plot(RL(:,1), RL(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on


%% IP4 - 88.6m Non-round beam diffusive
% NR - black solid
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 3), hold on

% NREl - dashed        Elliptical
% plot(NREl(:,1), NREl(:,2)/npart, '--', 'Color', c_orange, 'LineWidth', 3), hold on

% NREl2 - dash-dot      Elliptical unscaled
% plot(NREl2(:,1), NREl2(:,2)/npart, '--', 'Color', c_orange, 'LineWidth', 3), hold on

% NRHula - dotted     Hula
% plot(NRHula(:,1), NRHula(:,2)/npart, '-.', 'Color', c_orange, 'LineWidth', 3), hold on

% NRPogo - dash-dot      Pogo
% plot(NRPogo(:,1), NRPogo(:,2)/npart, ':', 'Color', c_orange, 'LineWidth', 3), hold on

% NRCloseHula Close hula (TODO)

%% IP4 - 119m Oval beam diffusive

%O 
% plot(O(:,1), O(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on

% OEl         Elliptical
% plot(OEl(:,1), OEl(:,2)/npart, '--', 'Color', c_dodger, 'LineWidth', 3), hold on

% OHula       Hula
% plot(OHula(:,1), OHula(:,2)/npart, '-.', 'Color', 'r', 'LineWidth', 3), hold on

% OHula2      Hula redo
% plot(OHula2(:,1), OHula2(:,2)/npart, '-.', 'Color', c_dodger, 'LineWidth', 3), hold on

% OPogo       Pogo
% plot(OPogo(:,1), OPogo(:,2)/npart, ':', 'Color', c_dodger, 'LineWidth', 3), hold on

% OCloseHula  Close hula (TODO)

%% Plots

%% Check O Hula vs O Hula2

% plot(R(:,1), R(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'Black', 'LineWidth', 3), hold on;
% plot(O(:,1), O(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(OHula2(:,1), OHula2(:,2)/npart, '-.', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(OEl(:,1), OEl(:,2)/npart, '--', 'Color', c_dodger, 'LineWidth', 3), hold on
% plot(OPogo(:,1), OPogo(:,2)/npart, ':', 'Color', c_dodger, 'LineWidth', 3), hold on;
% 
% legend('Round', 'Non-Round', 'Oval', 'O Hula', 'O Elliptical', 'O Pogo');

%% Basic O NR R

% plot(R(:,1), R(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'Black', 'LineWidth', 3), hold on;
% plot(O(:,1), O(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;
% 
% legend('Round', 'Non-Round', 'Oval');

%% Elliptical O NR R
% plot(R(:,1), R(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'Black', 'LineWidth', 3), hold on;
% plot(O(:,1), O(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(NREl(:,1), NREl(:,2)/npart, '--', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(OEl(:,1), OEl(:,2)/npart, '--', 'Color', c_dodger, 'LineWidth', 3), hold on;
% 
% legend('Round', 'Non-Round', 'Oval', 'NR Elliptical', 'O Elliptical');

%% Hula O NR R
% plot(R(:,1), R(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'Black', 'LineWidth', 3), hold on;
% plot(O(:,1), O(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(NRHula(:,1), NRHula(:,2)/npart, '-.', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(OHula2(:,1), OHula2(:,2)/npart, '-.', 'Color', c_dodger, 'LineWidth', 3), hold on;
% 
% legend('Round', 'Non-Round', 'Oval', 'NR Hula', 'O Hula');

%% Pogo O NR R
% plot(R(:,1), R(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'Black', 'LineWidth', 3), hold on;
% plot(O(:,1), O(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(NRPogo(:,1), NRPogo(:,2)/npart, ':', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(OPogo(:,1), OPogo(:,2)/npart, ':', 'Color', c_dodger, 'LineWidth', 3), hold on;
% 
% legend('Round', 'Non-Round', 'Oval', 'NR Pogo', 'O Pogo');

%% Close Hula O NR R
% plot(R(:,1), R(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'Black', 'LineWidth', 3), hold on;
% plot(O(:,1), O(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;
% 
% legend('Round', 'Non-Round', 'Oval');



%% Old Plots

%% All NR - CloseHula
% plot(R(:,1), R(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'Black', 'LineWidth', 3), hold on;
% plot(NREl(:,1), NREl(:,2)/npart, '--', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(NRHula(:,1), NRHula(:,2)/npart, '-.', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(NRPogo(:,1), NRPogo(:,2)/npart, ':', 'Color', c_orange, 'LineWidth', 3), hold on;
% 
% legend('Round', 'Non-Round', 'NR Elliptical', 'NR Hula', 'NR Pogo');

%% Old initial
% plot(R(:,1), R(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 4), hold on
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'c', 'LineWidth', 4), hold on
% plot(NREl(:,1), NREl(:,2)/npart, '-', 'Color', 'm', 'LineWidth', 4), hold on
% plot(NREl2(:,1), NREl2(:,2)/npart, '--', 'Color', 'g', 'LineWidth', 4), hold on
% plot(NRHula(:,1), Hula(:,2)/npart, '-.', 'Color', 'r', 'LineWidth', 4), hold on
% legend('Round', 'Non-Round', 'Non-Round Elliptical', 'Non-Round Elliptical Unscaled', 'Non-Round Hula')

%% NR plots
% plot(R(:,1), R(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 4), hold on
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'c', 'LineWidth', 4), hold on
% plot(NREl(:,1), NREl(:,2)/npart, '-', 'Color', 'm', 'LineWidth', 4), hold on
% plot(NRHula(:,1), NRHula(:,2)/npart, '-.', 'Color', 'r', 'LineWidth', 4), hold on
% legend('Round', 'Non-Round', 'Non-Round Elliptical', 'Non-Round Hula')

%% R NR O
% plot(R(:,1), R(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 4), hold on
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'c', 'LineWidth', 4), hold on
% plot(O(:,1), O(:,2)/npart, '-', 'Color', 'm', 'LineWidth', 4), hold on
% legend('Round', 'Non-Round', 'Oval')

%% O plots
% plot(R(:,1), R(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 4), hold on
% plot(O(:,1), O(:,2)/npart, '-', 'Color', 'm', 'LineWidth', 4), hold on
% plot(OEl(:,1), OEl(:,2)/npart, '-', 'Color', 'c', 'LineWidth', 4), hold on
% plot(OHula(:,1), OHula(:,2)/npart, '-.', 'Color', 'r', 'LineWidth', 4), hold on
% legend('Round', 'Oval', 'Oval Elliptical', 'Oval Hula')

%% R NR_hula O long
% plot(RL(:,1), RL(:,2)/npart, '--', 'Color', 'k', 'LineWidth', 4), hold on
% plot(R(:,1), R(:,2)/npart, '-', 'Color', 'k', 'LineWidth', 4), hold on
% plot(NRHulaL(:,1), NRHulaL(:,2)/npart, '--', 'Color', 'c', 'LineWidth', 4), hold on
% plot(NRHula(:,1), NRHula(:,2)/npart, '-', 'Color', 'c', 'LineWidth', 4), hold on
% plot(O(:,1), O(:,2)/npart, '-', 'Color', 'm', 'LineWidth', 4), hold on
% plot(NR(:,1), NR(:,2)/npart, '-', 'Color', 'y', 'LineWidth', 4), hold on
% legend('Round Long', 'Round', 'Non-Round Hula', 'Non-Round Hula Long', 'Oval', 'Non-Round')

% title('HL-LHC Diffusive HEL for Round (blue), Non-Round (red), NR Elliptical (yellow), NR Elliptical2 (green)')
xlabel('Turn [-]')
ylabel('N/N_0 [-]')

hold off
