RSrate=8000; %input resample rate
time=linspace(0,length(avWF_WB_1s_100)/RSrate,length(avWF_WB_1s_100));
dstime=downsample(time,300)';

dsPupil_100=downsample(avWF_WB_1s_100,300);
dsPupil_400=downsample(avWF_WB_1s_400,300);
dsPupil_800=downsample(avWF_WB_1s_800,300);

dsPupil_100=downsample(avWF_WB_500ms_100,300);
dsPupil_400=downsample(avWF_WB_500ms_400,300);
dsPupil_800=downsample(avWF_WB_500ms_800,300);

dsPupil_100=downsample(avWF_WB_5s_100,300);
dsPupil_400=downsample(avWF_WB_5s_400,300);
dsPupil_800=downsample(avWF_WB_5s_800,300);



%% plot dose response curves
figure;
    stdshade(dsPupil_100',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',10);
    set(gcf,'Position',[600 600 750 300]);
%     title('Pupil','fontsize',30)
%     ylabel('Pupil Diameter (% of Max)','fontsize',30)
%     line([5 5], [0 95]);
%     line([5.5 5.5], [0 95]);
    ylim([-0.01 0.08]); 
     xlim([4 12]);
%     yticks([55 65 75 85 95]);
%     xticks([0 5 10 15 20]);
    box off 
    
    hold on
    
    stdshade(dsPupil_400',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',10);
    set(gcf,'Position',[600 600 750 300]);
    title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',30)
%     line([5 5], [0 95]);
%     line([5.5 5.5], [0 95]);
    ylim([-0.01 0.08]);  
     xlim([4 12]);
%     yticks([55 65 75 85 95]);
%     xticks([0 5 10 15 20]);
    box off 
        hold on
    
    stdshade(dsPupil_800',0.2,'g',dstime')
    set(gca,'TickDir','out','FontSize',10);
    set(gcf,'Position',[600 600 750 300]);
    title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',30)
%     line([5 5], [0 95]);
%     line([5.5 5.5], [0 95]);
    ylim([-0.01 0.08]); 
     xlim([4 12]);
%     yticks([55 65 75 85 95]);
%     xticks([0 5 10 15 20]);
    box off 
%         hold on
%     
%     stdshade(dsPupil_1000',0.2,'m',dstime')
%     set(gca,'TickDir','out','FontSize',30);
%     set(gcf,'Position',[600 600 750 300]);
%     title('Pupil','fontsize',30)
%     ylabel('Pupil Diameter (% of Max)','fontsize',30)
%     line([5 5], [0 95]);
%     line([5.5 5.5], [0 95]);
%     ylim([50 100]); 
%     xlim([0 20]);
%     yticks([55 65 75 85 95]);
%     xticks([0 5 10 15 20]);
%     box off 