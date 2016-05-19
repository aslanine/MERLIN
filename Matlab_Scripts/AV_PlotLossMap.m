
clear all
list = dir(fullfile(cd, 'Dustbin_losses_20000_*.txt'));


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

lhcs=26658.8832;
fig1=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

bar(s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
h=bar(sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');
grid on;
%title ('Loss Map 6p5TeV B2','FontSize',20,'Fontweight','bold');
set(gca,'yscale','log','FontSize',20,'XLim',[0 lhcs],'Xtick',[0:1000:lhcs],'PlotBoxAspectRatio',[3 1.5 1.5]);
xlabel('s [m] ','FontSize',20,'Fontweight','bold');
ylabel('Local Ineffiency [1/m]','FontSize',20,'Fontweight','bold');
legend('Collimator','Cold','Warm');
%saveas(fig1,['LossMap6p5TeV_WHOLELATTICE','.fig'],'fig');'Xtick',[0:1000:lhcs],
% saveas(fig1,['LossMap_6p5TeV_FlatTop_B1','.epsc'],'epsc');
% close(fig1);

lhcs=26658.8832;
fig1=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');

bar(s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
h=bar(sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');
grid on;
%title ('Loss Map 6p5TeV B2','FontSize',20,'Fontweight','bold');
set(gca,'yscale','log','FontSize',20,'XLim',[19700 20700],'Xtick',[19700:50:20700],'PlotBoxAspectRatio',[3 1.5 1.5]);
xlabel('s [m] ','FontSize',20,'Fontweight','bold');
ylabel('Local Ineffiency [1/m]','FontSize',20,'Fontweight','bold');
legend('Collimator','Cold','Warm');







fig3=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');
bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');
grid on;
title ('Loss Map in IR7','FontSize',20,'Fontweight','bold');
xlabel('Distance from IP1 [m] ','FontSize',20,'Fontweight','bold');
ylabel('Local Ineffiency','FontSize',20,'Fontweight','bold');
set(gca,'yscale','log','FontSize',14,'XLim',[19800 20600],'Xtick',[19800:100:20600])
saveas(fig3,['IR3','.fig'],'fig');

close(fig3);

fig3=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');
bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');
grid on;
title ('Loss Map in IR7','FontSize',20,'Fontweight','bold');
xlabel('Distance from IP1 [m] ','FontSize',20,'Fontweight','bold');
ylabel('Local Ineffiency','FontSize',20,'Fontweight','bold');
set(gca,'yscale','log','FontSize',14,'XLim',[12000 13500],'Xtick',[12000:100:13500])
saveas(fig3,['IR5','.fig'],'fig');

fig3=figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'color','w');
bar(lhcs-s_position_Coll,sum_losses_Coll./(Nabs*Length_final_Coll),'BaseValue',10E-8,'FaceColor', 'k', 'Edgecolor', 'k');
hold on;
bar(lhcs-sCold,LossesCold*10/Nabs,'BaseValue',10E-8,'FaceColor', 'b', 'Edgecolor', 'b');
hold on;
bar(lhcs-sWarm,LossesWarm*10/Nabs,'BaseValue',10E-8,'FaceColor', 'r', 'Edgecolor', 'r');
grid on;
title ('Loss Map in IR7','FontSize',20,'Fontweight','bold');
xlabel('Distance from IP1 [m] ','FontSize',20,'Fontweight','bold');
ylabel('Local Ineffiency','FontSize',20,'Fontweight','bold');
set(gca,'yscale','log','FontSize',14,'XLim',[16000 17000],'Xtick',[16000:100:17000])
saveas(fig3,['IR6','.fig'],'fig');

index_tcts=[];
str={'TCT'};
for i=1:length(name_Coll)
    
    if (strmatch(name_Coll{i}(12:14),str)==1)
       index_tcts=[index_tcts;i];
        
    end
end
tcts1000_10000_1000_3000=name_Coll(index_tcts);
loss_tcts1000_10000_1000_3000=sum_losses_Coll(index_tcts)./(Nabs*Length_final_Coll(index_tcts));
s_tcts1000_10000_1000_3000=sColl(index_tcts);

save('1000.mat','tcts1000_10000_1000_3000','loss_tcts1000_10000_1000_3000','s_tcts1000_10000_1000_3000')


IR7=sum_losses_Coll(15:29);
perc=IR7*100/Ntot
