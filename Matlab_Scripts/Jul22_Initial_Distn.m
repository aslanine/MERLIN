%% Plot Initial Distribution

%% Import initial distribution
% filename = '/home/HR/Downloads/Initial_Distn/initial_bunch.txt';
filename = '/home/HR/Downloads/Initial_Distn/7TeV_initial_bunch.txt';
endRow = 6400000;
formatSpec = '%*70s%35f%35f%35f%35f%35f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', '', 'WhiteSpace', '', 'ReturnOnError', false);
fclose(fileID);
x = dataArray{:, 1};
xp = dataArray{:, 2};
y = dataArray{:, 3};
yp = dataArray{:, 4};
ct = dataArray{:, 5};
dp = dataArray{:, 6};
clearvars filename endRow formatSpec fileID dataArray ans;

%% normalise co-ordinates
% 6.5 TeV Beam 2
% alphax = 2.0404978329496588;
% betax = 149.2212486617413560;
% sigmax = 0.000276828;
% alphay = -1.1624450063081255;
% betay = 83.5026028428681002;
% sigmay = 0.000203686;
% sigdp = 1.129E-4;
% sigct = (2.51840894498383E-10 * 299792458);

% 7 TeV Beam 1        
alphax = 2.0406425686541585;
betax = 149.30138933085163;
sigmax = 0.000266828;
alphay = -1.1615616820869055;
betay = 83.457619521745883;
sigmay = 0.000196224;
sigdp = 1.129E-4;
sigct = (2.51840894498383E-10 * 299792458);

nx = x/sigmax;
nxp = ((x*alphax)+(xp*betax))/sigmax;
ny = y/sigmay;
nyp = ((y*alphay)+(yp*betay))/sigmay;
ndp = dp/sigdp;
nct = ct/sigct;

xplim = [min(xp) max(xp)];
yplim = [min(yp) max(yp)];

nxlim = [min(nx) max(nx)];
nylim = [min(ny) max(ny)];
nxplim = [min(nxp) max(nxp)];
nyplim = [min(nyp) max(nyp)];
nctlim = [min(nct) max(nct)];
ndplim = [min(ndp) max(ndp)];

%% Plot xy as heat map
figure;

data1 = ny; %// example data
data2 = nx; %// example data correlated to above
values = hist3([data1(:) data2(:)],[5E2 5E2]);

imagesc(nxlim,nylim,values);
colormap(hot(200));
% colormap(bone(200));
colormap(flipud(colormap));
colorbar;

set(gca,'FontSize',12,'PlotBoxAspectratio',[4 2 2],'Linewidth',1,'XLim',[-7 7]);
% title('6.5 TeV Beam 2');
title('7 TeV Beam 1');
ylabel('y_{normalised} [\sigma]');
xlabel('x_{normalised} [\sigma]');
grid on;
axis equal
%axis xy

hold off;

%% Plot xx' as normalised heat map
figure;

data1 = nxp; %// example data
data2 = nx; %// example data correlated to above
values = hist3([data1(:) data2(:)],[5E2 5E2]);

imagesc(nxlim,nxplim,values);
colormap(hot(200));
% colormap(bone(200));
colormap(flipud(colormap));
colorbar;

set(gca,'FontSize',12,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% title('6.5 TeV Beam 2');
title('7 TeV Beam 1');
ylabel('xp_{normalised} [\sigma]');
xlabel('x_{normalised} [\sigma]');
grid on;
axis equal
%axis xy

hold off;

%% Plot x'y' as heat map
figure;

data1 = yp; %// example data
data2 = xp; %// example data correlated to above
values = hist3([data1(:) data2(:)],[5E2 5E2]);

imagesc(xplim,yplim,values);
colormap(hot(200));
% colormap(bone(200));
colormap(flipud(colormap));
colorbar;

set(gca,'FontSize',12,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% title('6.5 TeV Beam 2');
title('7 TeV Beam 1');
ylabel('yp [rad]');
xlabel('xp [rad]');
grid on;
axis equal
%axis xy

hold off;

%% Plot yy' as normalised heat map
figure;

data1 = nyp; %// example data
data2 = ny; %// example data correlated to above
values = hist3([data1(:) data2(:)],[5E2 5E2]);

imagesc(nylim,nyplim,values);
colormap(hot(200));
% colormap(bone(200));
colormap(flipud(colormap));
colorbar;

set(gca,'FontSize',12,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% title('6.5 TeV Beam 2');
title('7 TeV Beam 1');
ylabel('yp_{normalised} [\sigma]');
xlabel('y_{normalised} [\sigma]');
grid on;
axis equal
%axis xy

hold off;

%% Plot ct dp as heat map
figure;

data1 = ndp; %// example data
data2 = nct; %// example data correlated to above
values = hist3([data1(:) data2(:)],[5E2 5E2]);

imagesc(nctlim,ndplim,values);
colormap(hot(200));
% colormap(bone(200));
colormap(flipud(colormap));
colorbar;

set(gca,'FontSize',12,'PlotBoxAspectratio',[4 2 2],'Linewidth',1);
% title('6.5 TeV Beam 2');
title('7 TeV Beam 1');
ylabel('ct_{normalised} [\sigma]');
xlabel('dp_{normalised} [\sigma]');
grid on;
axis equal
%axis xy

hold off;

