%% Scatter Plot Template
clear all;
%% Import Data from file

filename = '/home/HR/Downloads/MERLIN_HRThesis/MERLIN/Build/Thesis/outputs/ScatterPlot/17May_ScatterPlot/scatter_plot_TestCollimator.txt';
dat = cell(1);
dat = importdata(filename);
%particle_id	z	y	turn

%% Plot

% Max_val is the value of the largest particle ID, which we need to iterate over
[Max_val Max_ID] = max(dat(:,1));

% Sort the array
d = sortrows(dat,1);

% First particle ID
Current_ID = d(1,1);

%% Plot x

% Empty array to store plotting data
x=[];
y=[];
z=[];

figure;
% y jaw
% rectangle('position',[0 1 1 10],'facecolor',[0.9 0.9 0.9]);
% hold on;
% x jaw
rectangle('position',[0 -10 1 100],'facecolor',[0.9 0.9 0.9]);
hold on;

% Iterate over the array once
for i=1:length(d)    
        
    if d(i,1) == Current_ID
        % store the points in an array
        z(end+1) = d(i,2);
        x(end+1) = d(i,3); 
        y(end+1) = d(i,4);    
    else
        % plot and clear arrays
%         plot(z,y);
%         hold on;
        plot(z,x);
        hold on;
        
        x=[];
        y=[];
        z=[];
        
        % store the initial points
        z(end+1) = d(i,2);
        x(end+1) = d(i,3); 
        y(end+1) = d(i,4);        
    end
        
    % Store the particle ID for the next iteration
    Current_ID = d(i,1);
end


% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.05 1.05], 'YLim',[(1-3E-5) (1+3E-5)]);
% ylabel('y [m]');

set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.05 1.05], 'YLim',[-3E-5 3E-5]);
ylabel('x [m]');

xlabel('s [m]');
grid on;
% hold off;


%% Plot y

% Empty array to store plotting data
% x=[];
y=[];
z=[];

figure;
% y jaw
rectangle('position',[0 1 1 10],'facecolor',[0.9 0.9 0.9]);
hold on;
% x jaw
% rectangle('position',[0 -10 1 100],'facecolor',[0.9 0.9 0.9]);
% hold on;

% Iterate over the array once
for i=1:length(d)    
        
    if d(i,1) == Current_ID
        % store the points in an array
        z(end+1) = d(i,2);
%         x(end+1) = d(i,3); 
        y(end+1) = d(i,4);    
    else
        % plot and clear arrays
        plot(z,y);
        hold on;
%         plot(z,x);
%         hold on;
        
%         x=[];
        y=[];
        z=[];
        
        % store the initial points
        z(end+1) = d(i,2);
%         x(end+1) = d(i,3); 
        y(end+1) = d(i,4);        
    end
        
    % Store the particle ID for the next iteration
    Current_ID = d(i,1);
end


set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.05 1.05], 'YLim',[(1-3E-5) (1+3E-5)]);
ylabel('y [m]');

% set(gca,'FontSize',16,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-0.05 1.05], 'YLim',[-3E-5 3E-5]);
% ylabel('x [m]');

xlabel('s [m]');
grid on;
hold off;