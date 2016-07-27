
clear all
list = dir(fullfile(cd, 'Dustbin*.txt'));


numfiles = length(list);
mydata = cell(1, length(list));

for k = 1:length(list)
   
    mydata{k} = importdata(list(k).name);
end


% save('importedvariables.mat');
job_name={};
job_s=[];
job_bin=[];
job_loss=[];
job_temperature=[];
job_length=[];


for i=1:length(list)
      if isempty(mydata{1,i})
        continue
    else
    
    job_name=[job_name;mydata{1,i}.textdata(2:end)];
    job_s=[job_s;mydata{1,i}.data(:,1)];
    job_bin=[job_bin;mydata{1,i}.data(:,2)];
    job_loss=[job_loss;mydata{1,i}.data(:,3)];
    job_temperature=[job_temperature;mydata{1,i}.data(:,4)];
    job_length=[job_length;mydata{1,i}.data(:,5)];
   
 
      end
end







[job_s_sorted index_s_sorted] = sort(job_s,'ascend');

job_name_sorted=job_name(index_s_sorted);

job_loss_sorted=job_loss(index_s_sorted);

job_length_sorted=job_length(index_s_sorted);

job_bin_sorted=job_bin(index_s_sorted);

job_temperature_sorted=job_temperature(index_s_sorted);
max=26658.8832;

f = find(diff(job_s_sorted)~=0);
f=[f;length(job_s_sorted)];
% c=jet(job_length(f));
for i=1:(length(f))
    if i==1
        output_loss_sorted(i)=sum(job_loss_sorted(1:(f(1))));
        output_name_sorted{i}=job_name_sorted{f(i)};
        output_length_sorted(i)=job_length_sorted(f(i));
        output_s_sorted(i)=job_s_sorted(f(i));
        output_temperature_sorted(i)=job_temperature_sorted(f(i));
    else
        output_loss_sorted(i)=sum(job_loss_sorted(f(i-1)+1:(f(i))));
        output_name_sorted{i}=job_name_sorted{f(i)};
        output_length_sorted(i)=job_length_sorted(f(i));
        output_s_sorted(i)=job_s_sorted(f(i));
        output_temperature_sorted(i)=job_temperature_sorted(f(i));
    end
end

Nabs=sum(output_loss_sorted);
Ntot=length(mydata)*20000;
output=[output_s_sorted;output_loss_sorted;output_length_sorted;output_temperature_sorted]';

%sum all the losses per collimator
%look for colliamtor with same name and sum losses
%prima separa coll cold warm  


tempColl=find(output(:,4)==0);
tempCold=find(output(:,4)==1);
tempWarm=find(output(:,4)==2);
nameColl=output_name_sorted(tempColl)';
nameCold=output_name_sorted(tempCold)';
nameWarm=output_name_sorted(tempWarm)';
LossesColl=output_loss_sorted(tempColl);
LossesCold=output_loss_sorted(tempCold);
LossesWarm=output_loss_sorted(tempWarm);
lengthcoll=output_length_sorted(tempColl);
sColl=output_s_sorted(tempColl);
sCold=output_s_sorted(tempCold);
sWarm=output_s_sorted(tempWarm);


DATA=nameColl;
%  [un idx_last idx] = unique(DATA(:,1));
[vu,idx_last,idx] = unique(DATA.','stable');
N = length(vu);
idx_unique = cell(1,N);
for i = 1:N 
    idx_unique{i} = find(strcmp(DATA(:,1),vu(i))==1);
end



for i=1:length(idx_unique)
    sum_losses_Coll(i)=sum(LossesColl(idx_unique{i}(1:end)));
    s_position_Coll(i)=sColl(idx_last(i));
    name_Coll{i}=nameColl{idx_last(i)};
    temperaturae_Coll(i)=tempColl(idx_last(i));
   Length_final_Coll(i)=lengthcoll(idx_last(i));
end

%% Plot

% LHC length
lhcs=26658.8832;

%% Full Loss Map
fig1=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
h=bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');

% set(gca,'yscale','log','FontSize',16,'XLim',[0 lhcs],'Xtick',[0:2000:lhcs],'YLim',[1E-7 1E2],'PlotBoxAspectRatio',[4 2 2]);
% CF Measurement
% set(gca,'yscale','log','FontSize',16,'XLim',[0 lhcs],'Xtick',[0:2000:lhcs],'YLim',[1E-7 1E0],'Ytick',[1E-7 1E-6 1E-5 1E-4 1E-3 1E-2 1E-1 1E0],'PlotBoxAspectRatio',[4 2 2]);
% CF SixTrack
set(gca,'yscale','log','FontSize',16,'XLim',[0 lhcs],'Xtick',[0:1000:lhcs],'YLim',[1E-8 1E2],'Ytick',[1E-8 1E-6 1E-4 1E-2 1E0 1E2],'PlotBoxAspectRatio',[4 1.5 1]);

grid on;
xlabel('s [m] ','FontSize',16);
ylabel('Local Inefficiency [m^{-1}]','FontSize',16);
legend('Collimator','Cold','Warm');
title ('6.5 TeV Beam 2 Comp 4D','FontSize',16);

%% IR7 Loss Map
fig2=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
h=bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');

% Beam 1
% set(gca,'yscale','log','FontSize',16,'XLim',[19780 20680],'Xtick',[19780:100:20680],'YLim',[1E-7 1E2],'PlotBoxAspectRatio',[4 2 2]);
% Beam 2
% set(gca,'yscale','log','FontSize',16,'XLim',[6400 7500],'Xtick',[6400:100:7500],'YLim',[1E-7 1E2],'PlotBoxAspectRatio',[4 2 2]);
% Beam 2 in B1 co-ordinates
% set(gca,'yscale','log','FontSize',16,'XLim',[19300 20300],'Xtick',[19300:100:20300],'YLim',[1E-7 1E2],'PlotBoxAspectRatio',[4 2 2]);
% CF SixTrack
set(gca,'yscale','log','FontSize',16,'XLim',[18500 20300],'Xtick',[18500:100:20300],'YLim',[1E-8 1E2],'Ytick',[1E-8 1E-6 1E-4 1E-2 1E0 1E2],'PlotBoxAspectRatio',[4 1.5 1]);
% CF Measurement
% set(gca,'yscale','log','FontSize',16,'XLim',[18500 20300],'Xtick',[18500:100:20300],'YLim',[1E-7 1E0],'Ytick',[1E-7 1E-6 1E-5 1E-4 1E-3 1E-2 1E-1 1E0],'PlotBoxAspectRatio',[4 2 1]);

grid on;
xlabel('s [m] ','FontSize',16);
ylabel('Local Inefficiency [m^{-1}]','FontSize',16);
legend('location', 'northwest', 'Collimator','Cold','Warm');
title ('6.5 TeV Beam 2 IR7 Comp 4D','FontSize',16);

%% IR3 Loss Map
fig3=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
h=bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');

% Beam 1
% set(gca,'yscale','log','FontSize',16,'XLim',[6400 7000],'Xtick',[6400:100:7000],'PlotBoxAspectRatio',[4 2 2]);
% Beam 2
% set(gca,'yscale','log','FontSize',16,'XLim',[19700 20700],'Xtick',[19700:100:20700],'PlotBoxAspectRatio',[4 2 2]);
% Beam 2 in B1 co-ordinates
% set(gca,'yscale','log','FontSize',16,'XLim',[6100 6900],'Xtick',[6100:100:6900],'PlotBoxAspectRatio',[4 2 2]);

% CF SixTrack
set(gca,'yscale','log','FontSize',16,'XLim',[6300 7000],'Xtick',[6300:50:7000],'YLim',[1E-8 1E-3],'Ytick',[1E-8 1E-7 1E-6 1E-5 1E-4 1E-3],'PlotBoxAspectRatio',[4 1.3 1]);
% CF Measurement
% set(gca,'yscale','log','FontSize',16,'XLim',[6300 7000],'Xtick',[6300:50:7000],'YLim',[1E-7 1E0],'Ytick',[1E-7 1E-6 1E-5 1E-4 1E-3 1E-2 1E-1 1E0],'PlotBoxAspectRatio',[4 2 1]);

grid on;
xlabel('s [m] ','FontSize',16);
ylabel('Local Inefficiency [m^{-1}]','FontSize',16);
legend('location', 'northwest', 'Collimator','Cold','Warm');
title ('6.5 TeV Beam 2 IR3 Comp 4D','FontSize',16);


%% DS Loss Map
fig4=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
h=bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');

% CF SixTrack
set(gca,'yscale','log','FontSize',16,'XLim',[19300 19800],'Xtick',[19300:100:19800],'YLim',[1E-8 1E-3],'Ytick',[1E-8 1E-7 1E-6 1E-5 1E-4 1E-3],'PlotBoxAspectRatio',[4 1.5 1]);

grid on;
xlabel('s [m] ','FontSize',16);
ylabel('Local Inefficiency [m^{-1}]','FontSize',16);
legend('location', 'northwest', 'Collimator','Cold','Warm');
title ('6.5 TeV Beam 2 IR7 DS Comp 4D','FontSize',16);


%% Other stuff
% fig4=figure('units','normalized','outerposition',[0 0 1 1]);
% set(gcf,'color','w');
% bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
% hold on;
% bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
% hold on;
% bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');
% grid on;
% title ('7 TeV Beam 1 IR7','FontSize',20,'Fontweight','bold');
% xlabel('Distance from IP1 [m] ','FontSize',20,'Fontweight','bold');
% ylabel('Local Inefficiency','FontSize',20,'Fontweight','bold');
% set(gca,'yscale','log','FontSize',14,'XLim',[19800 20600],'Xtick',[19800:100:20600])
% saveas(fig4,['IR7','.png'],'png');
% 
% close(fig3);
% 
% fig3=figure('units','normalized','outerposition',[0 0 1 1]);
% set(gcf,'color','w');
% bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
% hold on;
% bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
% hold on;
% bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');
% grid on;
% title ('7 TeV Beam 1 IR5','FontSize',20,'Fontweight','bold');
% xlabel('Distance from IP1 [m] ','FontSize',20,'Fontweight','bold');
% ylabel('Local Inefficiency','FontSize',20,'Fontweight','bold');
% set(gca,'yscale','log','FontSize',14,'XLim',[12000 13500],'Xtick',[12000:100:13500])
% saveas(fig3,['IR5','.png'],'png');
% 
% fig3=figure('units','normalized','outerposition',[0 0 1 1]);
% set(gcf,'color','w');
% bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
% hold on;
% bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
% hold on;
% bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');
% grid on;
% title ('7 TeV Beam 1 IR7','FontSize',20,'Fontweight','bold');
% xlabel('Distance from IP1 [m] ','FontSize',20,'Fontweight','bold');
% ylabel('Local Inefficiency','FontSize',20,'Fontweight','bold');
% set(gca,'yscale','log','FontSize',14,'XLim',[0 266659],'Xtick',[16000:100:17000])
% saveas(fig3,['Full','.png'],'png');

% index_tcts=[];
% str={'TCT'};
% for i=1:length(name_Coll)
%     
%     if (strmatch(name_Coll{i}(12:14),str)==1)
%        index_tcts=[index_tcts;i];
%         
%     end
% end
% tcts1000_10000_1000_3000=name_Coll(index_tcts);
% loss_tcts1000_10000_1000_3000=sum_losses_Coll(index_tcts)./(Nabs*Length_final_Coll(index_tcts));
% s_tcts1000_10000_1000_3000=sColl(index_tcts);
% 
% save('1000.mat','tcts1000_10000_1000_3000','loss_tcts1000_10000_1000_3000','s_tcts1000_10000_1000_3000')
% 
% 
% IR7=sum_losses_Coll(15:29);
% perc=IR7*100/Ntot;
