%% downsample to allow for editing in Illustrator
RSrate=8000; %input resample rate
time=linspace(0,length(avpup)/RSrate,length(avpup));

dsPupil_100=downsample(avpup,300);
dsPupil_400=downsample(avpup_400,300);
dsPupil_800=downsample(avpup_800,300);
dsPupil_1000=downsample(avpup_1000,300);







dsPupil_s=downsample(PUP_stationary,300);
dsWhisk_s=downsample(WHISK_stationary,300);
dsWalk_s=downsample(WALK_stationary,300);

dsPupil_w=downsample(PUP_walking,300);
dsWhisk_w=downsample(WHISK_walking,300);
dsWalk_w=downsample(WALK_walking,300);

dsPupil_still=downsample(PUP_still,300);
dsWhisk_still=downsample(WHISK_still,300);
dsWalk_still=downsample(WALK_still,300);

dsPupil_whisk=downsample(PUP_whisk,300);
dsWhisk_whisk=downsample(WHISK_whisk,300);
dsWalk_whisk=downsample(WALK_whisk,300);

%%VNX
RSrate=8000; %input resample rate
time=linspace(0,length(avpup_VNX)/RSrate,length(avpup_VNX));
dstime=downsample(time,300)';
dsPupil_vnx=downsample(avpup_VNX,300);
dsWhisk_vnx=downsample(avwhisk_VNX,300);
dsWalk_vnx=downsample(avencoder_VNX,300);
dsPupil_800=downsample(avpup_800,300);
dsWhisk_800=downsample(avwhisk_800,300);
dsWalk_800=downsample(avencoder_800,300);



% dsWhisk=downsample(avwhisk,50);
% dsEncoder=downsample(avencoder,50);
% dsStim=downsample(avstim,50);
% dsPupil_100norm=(dsPupil_100-mean(dsPupil_100(750:800)))/mean(dsPupil_100(750:800)) *100;
% dsPupil_400norm=(dsPupil_400-mean(dsPupil_400(750:800)))/mean(dsPupil_400(750:800)) *100;
% dsPupil_800norm=(dsPupil_800-mean(dsPupil_800(750:800)))/mean(dsPupil_800(750:800)) *100;


%% plot dose response curves
figure;
    stdshade(dsPupil_100',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
    title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',30)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([55 95]); 
    xlim([0 20]);
    yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
    
    hold on
    
    stdshade(dsPupil_400',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
    title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',30)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([55 95]); 
    xlim([0 20]);
    yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
    
    stdshade(dsPupil_800',0.2,'g',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
    title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',30)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([55 95]); 
    xlim([0 20]);
    yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
    
    stdshade(dsPupil_1000',0.2,'m',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
    title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',30)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([50 100]); 
    xlim([0 20]);
    yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
    
      %% plot walking
figure;
subplot(3,1,1)
    stdshade(dsPupil_s',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([45 95]); 
    xlim([0 20]);
    yticks([45 55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
subplot(3,1,2)
    stdshade(dsWhisk_s',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Whisk','fontsize',30)
    ylabel('Whisker Pad Motion Energy','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([0 0.1]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
subplot(3,1,3)    
    stdshade(dsWalk_s',0.2,'g',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Walk','fontsize',30)
    ylabel('Walk Velocity (m/s)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([0 0.2]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold off
 
 
        % plot 
figure;
subplot(3,1,1)
    stdshade(dsPupil_w',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([45 95]); 
    xlim([0 20]);
    yticks([45 55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
subplot(3,1,2)
    stdshade(dsWhisk_w',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Whisk','fontsize',30)
    ylabel('Whisker Pad Motion Energy','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([0 0.1]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
subplot(3,1,3)    
    stdshade(dsWalk_w',0.2,'g',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Walk','fontsize',30)
    ylabel('Walk Velocity (m/s)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([0 0.2]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
        
             %% plot whisking
figure;
subplot(3,1,1)
    stdshade(dsPupil_whisk',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([45 95]); 
    xlim([0 20]);
    yticks([45 55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
subplot(3,1,2)
    stdshade(dsWhisk_whisk',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Whisk','fontsize',30)
    ylabel('Whisker Pad Motion Energy','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([0 0.1]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
subplot(3,1,3)    
    stdshade(dsWalk_whisk',0.2,'g',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Walk','fontsize',30)
    ylabel('Walk Velocity (m/s)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([0 0.2]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
        
                     % plot whisking
figure;
subplot(3,1,1)
    stdshade(dsPupil_still',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([45 95]); 
    xlim([0 20]);
    yticks([45 55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
subplot(3,1,2)
    stdshade(dsWhisk_still',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Whisk','fontsize',30)
    ylabel('Whisker Pad Motion Energy','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([0 0.1]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
subplot(3,1,3)    
    stdshade(dsWalk_still',0.2,'g',dstime')
    set(gca,'TickDir','out','FontSize',20);
    set(gcf,'Position',[600 100 750 750]);
%     title('Walk','fontsize',30)
    ylabel('Walk Velocity (m/s)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([0 0.2]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
        hold on
%% VNX
        figure;
    stdshade(dsPupil_vnx',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
    title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',30)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([55 95]); 
    xlim([0 20]);
    yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
    
    hold on
        stdshade(dsPupil_800',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
    title('Pupil','fontsize',30)
    ylabel('Pupil Diameter (% of Max)','fontsize',30)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([55 95]); 
    xlim([0 20]);
    yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
    
            figure;
    stdshade(dsWhisk_vnx',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
%     title('Whisk','fontsize',30)
    ylabel('Whisker Pad Motion Energy','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([-0.05 0.1]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
    
    hold on
        stdshade(dsWhisk_800',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
%     title('Whisk','fontsize',30)
    ylabel('Whisker Pad Motion Energy','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([-0.05 0.1]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
    
                figure;
    stdshade(dsWalk_vnx',0.2,'b',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
    title('Walk','fontsize',30)
    ylabel('Walk Velocity (m/s)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([-0.05 0.1]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
    
    hold on
        stdshade(dsWalk_800',0.2,'r',dstime')
    set(gca,'TickDir','out','FontSize',30);
    set(gcf,'Position',[600 600 750 300]);
    title('Walk','fontsize',30)
    ylabel('Walk Velocity (m/s)','fontsize',20)
    line([5 5], [0 95]);
    line([5.5 5.5], [0 95]);
    ylim([-0.05 0.1]); 
    xlim([0 20]);
%     yticks([55 65 75 85 95]);
    xticks([0 5 10 15 20]);
    box off 
    
    %% histogram before and during 5 sec stim
    figure;
    histogram(avpup_800(1:40000,:),50); hold on; histogram(avpup_800(50001:100000,:),50);hold off
