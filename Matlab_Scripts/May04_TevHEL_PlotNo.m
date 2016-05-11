%% Script to merge split data and plot no_particles for TevHEL Runs 04May16

%% Import data files
clear all;

turns = 100000;
turns = turns + 1;

%% NH

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_NH/ParticleNo/Halo/');
list = dir('*.txt'); 

NH = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        NH(:,1) = A(:,1);
        NH(:,2) = A(:,2);
    else    
        NH(:,2) = NH(:,2) + A(:,2);
    end
end

npart = NH(1,2);

clear A list;

%% DC

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_DC/ParticleNo/Halo/');
list = dir('*.txt'); 

DC = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        DC(:,1) = A(:,1);
        DC(:,2) = A(:,2);
    else    
        DC(:,2) = DC(:,2) + A(:,2);
    end
end

clear A list;

%% AC

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_AC/ParticleNo/Halo/');
list = dir('*.txt'); 

AC = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        AC(:,1) = A(:,1);
        AC(:,2) = A(:,2);
    else    
        AC(:,2) = AC(:,2) + A(:,2);
    end
end

clear A list;

%% Diff

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_Diff/ParticleNo/Halo/');
list = dir('*.txt'); 

Diff = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        Diff(:,1) = A(:,1);
        Diff(:,2) = A(:,2);
    else    
        Diff(:,2) = Diff(:,2) + A(:,2);
    end
end

clear A list;

%% NHB

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_NHB/ParticleNo/Halo/');
list = dir('*.txt'); 

NHB = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        NHB(:,1) = A(:,1);
        NHB(:,2) = A(:,2);
    else    
        NHB(:,2) = NHB(:,2) + A(:,2);
    end
end

npart = NHB(1,2);

clear A list;

%% DCB

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_DCB/ParticleNo/Halo/');
list = dir('*.txt'); 

DCB = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        DCB(:,1) = A(:,1);
        DCB(:,2) = A(:,2);
    else    
        DCB(:,2) = DCB(:,2) + A(:,2);
    end
end

clear A list;

%% ACB

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_ACB/ParticleNo/Halo/');
list = dir('*.txt'); 

ACB = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        ACB(:,1) = A(:,1);
        ACB(:,2) = A(:,2);
    else    
        ACB(:,2) = ACB(:,2) + A(:,2);
    end
end

clear A list;

%% DiffB

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_DiffB/ParticleNo/Halo/');
list = dir('*.txt'); 

DiffB = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        DiffB(:,1) = A(:,1);
        DiffB(:,2) = A(:,2);
    else    
        DiffB(:,2) = DiffB(:,2) + A(:,2);
    end
end

clear A list;


%% Diff Double Current

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_Diff_DoubleCurrent/ParticleNo/Halo/');
list = dir('*.txt'); 

DiffII = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        DiffII(:,1) = A(:,1);
        DiffII(:,2) = A(:,2);
    else    
        DiffII(:,2) = DiffII(:,2) + A(:,2);
    end
end

clear A list;

%% AC Double Current

cd('/home/HR/Downloads/04May_TevHEL_Runs/04May_AC_DoubleCurrent/ParticleNo/Halo/');
list = dir('*.txt'); 

ACII = zeros(turns, 2);
A = zeros(turns, 2);

for ii = 1:length(list)
    clear A;
    A = importdata(list(ii).name);
    if(ii==1)
        ACII(:,1) = A(:,1);
        ACII(:,2) = A(:,2);
    else    
        ACII(:,2) = ACII(:,2) + A(:,2);
    end
end

clear A list;

%% Custom colours
c_teal = [18 150 155] ./ 255;
c_dodger = [30 144 255] ./ 255;
c_orange = [225 111 0] ./ 255;
c_gray = [112 112 112] ./ 255;

%% Plot ALL
% plot(NHB(:,1), NHB(:,2)/npart, '--', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(NH(:,1), NH(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(DCB(:,1), DCB(:,2)/npart, '--', 'Color', c_teal, 'LineWidth', 3), hold on;
% plot(DC(:,1), DC(:,2)/npart, '-', 'Color', c_teal, 'LineWidth', 3), hold on;
% plot(ACB(:,1), ACB(:,2)/npart, '--', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(AC(:,1), AC(:,2)/npart, '-', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(DiffB(:,1), DiffB(:,2)/npart, '--', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(Diff(:,1), Diff(:,2)/npart, '-', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(DiffII(:,1), DiffII(:,2)/npart, ':', 'Color', 'r', 'LineWidth', 3), hold on;
% plot(ACII(:,1), ACII(:,2)/npart, ':', 'Color', 'k', 'LineWidth', 3), hold on;
% 
% legend('Location', 'southwest','NH_{Black Absorber}', 'NH', 'DC_{Black Absorber}', 'DC', 'AC_{Black Absorber}', 'AC', 'Diff_{Black Absorber}', 'Diff', 'Diff_{Double Current}', 'AC_{Double Current}');

%% Plot Black Absorbers
% plot(NHB(:,1), NHB(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(DCB(:,1), DCB(:,2)/npart, '--', 'Color', c_teal, 'LineWidth', 3), hold on;
% plot(ACB(:,1), ACB(:,2)/npart, ':', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(DiffB(:,1), DiffB(:,2)/npart, '--', 'Color', c_orange, 'LineWidth', 3), hold on;
% 
% legend('Location', 'southwest', 'NH_{Black Absorber}','DC_{Black Absorber}', 'AC_{Black Absorber}',  'Diff_{Black Absorber}');

%% Plot Full Collimation
% plot(NH(:,1), NH(:,2)/npart, '-', 'Color', c_gray, 'LineWidth', 3), hold on;
% plot(DC(:,1), DC(:,2)/npart, '--', 'Color', c_teal, 'LineWidth', 3), hold on;
% plot(AC(:,1), AC(:,2)/npart, ':', 'Color', c_dodger, 'LineWidth', 3), hold on;
% plot(Diff(:,1), Diff(:,2)/npart, '--', 'Color', c_orange, 'LineWidth', 3), hold on;
% 
% legend('Location', 'southwest', 'NH','DC', 'AC',  'Diff');

%% Double Diff Current
% plot(Diff(:,1), Diff(:,2)/npart, '--', 'Color', c_orange, 'LineWidth', 3), hold on;
% plot(DiffII(:,1), DiffII(:,2)/npart, ':', 'Color', 'r', 'LineWidth', 3), hold on;
% 
% legend('Location', 'southwest', 'Diff','Diff_{Double Current}');

%% Double AC Current
plot(AC(:,1), AC(:,2)/npart, ':', 'Color', c_dodger, 'LineWidth', 3), hold on;
plot(ACII(:,1), ACII(:,2)/npart, ':', 'Color', 'k', 'LineWidth', 3), hold on;

legend('Location', 'southwest', 'AC','AC_{Double Current}');
%% Finalise Plot

xlabel('Turn [-]');
ylabel('N/N_0 [-]');
grid on;
axis([0, turns, 0, 1.05]);

hold off


