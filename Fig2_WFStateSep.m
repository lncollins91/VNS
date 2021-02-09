%VNS4 WF State Separation and behavior graphing
%Smooth walk and whisk traces
avencoder=abs(avencoder); %no negative values for walk
avencoder=movmean(avencoder,2000);


% split into walking and not walking
% hardcoded walk values
meanwalk=0.01;
sd_walk=0.004;
sd4_walk=sd_walk*4;
mean4sd=meanwalk+sd4_walk;
frq=8000;
% 
% % %uncomment if you want to determine mean and SD walk again
% figure ('Name','Walking Trace','units','normalized','outerposition',[0 0 1 1])
% plot(avencoder(:,2));
% title('Choose stationary segment.')
% [x1,~] =(ginput(1)); 
% [x2,~] = (ginput(1)); 
% close('Walking Trace');
% x1=round(x1); 
% x2=round(x2);
% mean_walk = mean(avencoder((x1:x2),2));
% sd_walk = std(avencoder((x1:x2),2));
% sd4_walk=(sd_walk*4);
% mean4sd=mean_walk+sd4_walk;

%find the average walking speed during stimulation each trial
avspeed = [];
% prewalk=frq*1;

for i = 1:size(avencoder,2)
     avspeed(:,i) = mean(avencoder((frq*4:frq*13),i));
end

this_WALK = [];
this_PUP = [];
this_WHISK = [];
this_avWF_WB = [];
this_avWF_Motor = [];
this_avWF_Somato = [];
this_avWF_Visual = [];
this_avWF_Retro = [];
this_avWF_L_Motor = [];
this_avWF_L_Somato = [];
this_avWF_L_Visual = [];
this_avWF_L_Retro = [];

WALK_walking = [];
PUP_walking = [];
WHISK_walking = [];
avWF_WB_walking = [];
avWF_Motor_walking = [];
avWF_Somato_walking = [];
avWF_Visual_walking = [];
avWF_Retro_walking = [];
avWF_L_Motor_walking = [];
avWF_L_Somato_walking = [];
avWF_L_Visual_walking = [];
avWF_L_Retro_walking = [];

WALK_stationary = [];
PUP_stationary = [];
WHISK_stationary = [];
avWF_WB_stationary = [];
avWF_Motor_stationary = [];
avWF_Somato_stationary = [];
avWF_Visual_stationary = [];
avWF_Retro_stationary = [];
avWF_L_Motor_stationary = [];
avWF_L_Somato_stationary = [];
avWF_L_Visual_stationary = [];
avWF_L_Retro_stationary = [];

for i = 1:length(avspeed)
    if avspeed(i) > mean4sd
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
        this_avWF_WB = (avWF_WB(:,i));
        this_avWF_Motor = (avWF_Motor(:,i));
        this_avWF_Somato = (avWF_Somato(:,i));
        this_avWF_Visual = (avWF_Visual(:,i));
        this_avWF_Retro = (avWF_Retro(:,i));
        this_avWF_L_Motor = (avWF_L_Motor(:,i));
        this_avWF_L_Somato = (avWF_L_Somato(:,i));
        this_avWF_L_Visual = (avWF_L_Visual(:,i));
        this_avWF_L_Retro = (avWF_L_Retro(:,i));
%         
        WALK_walking = [WALK_walking, this_WALK]; 
        PUP_walking = [PUP_walking, this_PUP];
        WHISK_walking = [WHISK_walking, this_WHISK];
        avWF_WB_walking = [avWF_WB_walking, this_avWF_WB]; 
        avWF_Motor_walking = [avWF_Motor_walking, this_avWF_Motor];
        avWF_Somato_walking = [avWF_Somato_walking, this_avWF_Somato]; 
        avWF_Visual_walking = [avWF_Visual_walking, this_avWF_Visual];
        avWF_Retro_walking = [avWF_L_Retro_walking, this_avWF_Retro];
        avWF_L_Motor_walking = [avWF_L_Motor_walking, this_avWF_L_Motor];
        avWF_L_Somato_walking = [avWF_L_Somato_walking, this_avWF_L_Somato]; 
        avWF_L_Visual_walking = [avWF_L_Visual_walking, this_avWF_L_Visual];
        avWF_L_Retro_walking = [avWF_L_Retro_walking, this_avWF_L_Retro];
%                 
    elseif avspeed(i) < mean4sd 
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
        this_avWF_WB = (avWF_WB(:,i));
        this_avWF_Motor = (avWF_Motor(:,i));
        this_avWF_Somato = (avWF_Somato(:,i));
        this_avWF_Visual = (avWF_Visual(:,i));
        this_avWF_Retro = (avWF_Retro(:,i));
        this_avWF_L_Motor = (avWF_L_Motor(:,i));
        this_avWF_L_Somato = (avWF_L_Somato(:,i));
        this_avWF_L_Visual = (avWF_L_Visual(:,i));
        this_avWF_L_Retro = (avWF_L_Retro(:,i));
        
        WALK_stationary = [WALK_stationary, this_WALK]; 
        PUP_stationary = [PUP_stationary, this_PUP];
        WHISK_stationary = [WHISK_stationary, this_WHISK];
        avWF_WB_stationary = [avWF_WB_stationary, this_avWF_WB]; 
        avWF_Motor_stationary = [avWF_Motor_stationary, this_avWF_Motor];
        avWF_Somato_stationary = [avWF_Somato_stationary, this_avWF_Somato]; 
        avWF_Visual_stationary = [avWF_Visual_stationary, this_avWF_Visual];        
        avWF_Retro_stationary = [avWF_Retro_stationary, this_avWF_Retro];
        avWF_L_Motor_stationary = [avWF_L_Motor_stationary, this_avWF_L_Motor];
        avWF_L_Somato_stationary = [avWF_L_Somato_stationary, this_avWF_L_Somato]; 
        avWF_L_Visual_stationary = [avWF_L_Visual_stationary, this_avWF_L_Visual];        
        avWF_L_Retro_stationary = [avWF_L_Retro_stationary, this_avWF_L_Retro];
    end
end


%% DO THE SAME WITH WHISKING - If running always whisking - but if still, may be whisking or not

%Smooth  whisk traces
avwhisksep=movmean(WHISK_stationary,2000);
 
% split into walking and not walking
% hardcoded walk values
meanwhisk=0.01;
sd_whisk=0.004;
sd4_whisk=sd_whisk*4;
mean4sd=meanwhisk+sd4_whisk;
frq=8000;

%find the average walking speed during stimulation each trial
avMEwhisk = [];
% prewalk=frq*1;

for i = 1:size(avwhisksep,2)
     avMEwhisk(:,i) = mean(avwhisksep((frq*4:frq*13),i));
end

this_WALK = [];
this_PUP = [];
this_WHISK = [];
this_avWF_WB = [];
this_avWF_Motor = [];
this_avWF_Somato = [];
this_avWF_Visual = [];
this_avWF_Retro = [];
this_avWF_L_Motor = [];
this_avWF_L_Somato = [];
this_avWF_L_Visual = [];
this_avWF_L_Retro = [];

WALK_whisk = [];
PUP_whisk = [];
WHISK_whisk = [];
avWF_WB_whisk = [];
avWF_Motor_whisk = [];
avWF_Somato_whisk = [];
avWF_Visual_whisk = [];
avWF_Retro_whisk = [];
avWF_L_Motor_whisk = [];
avWF_L_Somato_whisk = [];
avWF_L_Visual_whisk = [];
avWF_L_Retro_whisk = [];

WALK_still = [];
PUP_still = [];
WHISK_still = [];
avWF_WB_still = [];
avWF_Motor_still = [];
avWF_Somato_still = [];
avWF_Visual_still = [];
avWF_Retro_still = [];
avWF_L_Motor_still = [];
avWF_L_Somato_still = [];
avWF_L_Visual_still = [];
avWF_L_Retro_still = [];

for i = 1:length(avMEwhisk)
    if avMEwhisk(i) > mean4sd
        this_WALK = (WALK_stationary(:,i));
        this_PUP = (PUP_stationary(:,i));
        this_WHISK = (avwhisksep(:,i));
        this_avWF_WB = (avWF_WB_stationary(:,i));
        this_avWF_Motor = (avWF_Motor_stationary(:,i));
        this_avWF_Somato = (avWF_Somato_stationary(:,i));
        this_avWF_Visual = (avWF_Visual_stationary(:,i));
        this_avWF_Retro = (avWF_Retro_stationary(:,i));
        this_avWF_L_Motor = (avWF_L_Motor_stationary(:,i));
        this_avWF_L_Somato = (avWF_L_Somato_stationary(:,i));
        this_avWF_L_Visual = (avWF_L_Visual_stationary(:,i));
        this_avWF_L_Retro = (avWF_L_Retro_stationary(:,i));
%         
        WALK_whisk = [WALK_whisk, this_WALK]; 
        PUP_whisk = [PUP_whisk, this_PUP];
        WHISK_whisk = [WHISK_whisk, this_WHISK];
        avWF_WB_whisk = [avWF_WB_whisk, this_avWF_WB]; 
        avWF_Motor_whisk = [avWF_Motor_whisk, this_avWF_Motor];
        avWF_Somato_whisk = [avWF_Somato_whisk, this_avWF_Somato]; 
        avWF_Visual_whisk = [avWF_Visual_whisk, this_avWF_Visual];
        avWF_Retro_whisk = [avWF_Retro_whisk, this_avWF_Retro];
        avWF_L_Motor_whisk = [avWF_L_Motor_whisk, this_avWF_L_Motor];
        avWF_L_Somato_whisk = [avWF_L_Somato_whisk, this_avWF_L_Somato]; 
        avWF_L_Visual_whisk = [avWF_L_Visual_whisk, this_avWF_L_Visual];
        avWF_L_Retro_whisk = [avWF_L_Retro_whisk, this_avWF_L_Retro];
%                 
    elseif avMEwhisk(i) < mean4sd 
        this_WALK = (WALK_stationary(:,i));
        this_PUP = (PUP_stationary(:,i));
        this_WHISK = (avwhisksep(:,i));
        this_avWF_WB = (avWF_WB_stationary(:,i));
        this_avWF_Motor = (avWF_Motor_stationary(:,i));
        this_avWF_Somato = (avWF_Somato_stationary(:,i));
        this_avWF_Visual = (avWF_Visual_stationary(:,i));
        this_avWF_Retro = (avWF_Retro_stationary(:,i));
        this_avWF_L_Motor = (avWF_L_Motor_stationary(:,i));
        this_avWF_L_Somato = (avWF_L_Somato_stationary(:,i));
        this_avWF_L_Visual = (avWF_L_Visual_stationary(:,i));
        this_avWF_L_Retro = (avWF_L_Retro_stationary(:,i));
        
        WALK_still = [WALK_still, this_WALK]; 
        PUP_still = [PUP_still, this_PUP];
        WHISK_still = [WHISK_still, this_WHISK];
        avWF_WB_still = [avWF_WB_still, this_avWF_WB]; 
        avWF_Motor_still = [avWF_Motor_still, this_avWF_Motor];
        avWF_Somato_still = [avWF_Somato_still, this_avWF_Somato]; 
        avWF_Visual_still = [avWF_Visual_still, this_avWF_Visual];
        avWF_Retro_still = [avWF_Retro_still, this_avWF_Retro];
        avWF_L_Motor_still = [avWF_L_Motor_still, this_avWF_L_Motor];
        avWF_L_Somato_still = [avWF_L_Somato_still, this_avWF_L_Somato]; 
        avWF_L_Visual_still = [avWF_L_Visual_still, this_avWF_L_Visual];
        avWF_L_Retro_still = [avWF_L_Retro_still, this_avWF_L_Retro];
    end
end


%% Downsample everything to graph

RSrate=8000; %input resample rate
time=linspace(0,length(avpup)/RSrate,length(avpup));
dstime=downsample(time,300)';
%all together
dsPupil=downsample(avpup,300);
dsWhisk=downsample(avwhisk,300);
dsWalk=downsample(avencoder,300);
dsavWF_L_Motor=downsample(avWF_L_Motor,300);
dsavWF_L_Retro=downsample(avWF_L_Retro,300);
dsavWF_L_Somato=downsample(avWF_L_Somato,300);
dsavWF_L_Visual=downsample(avWF_L_Visual,300);
dsavWF_Motor=downsample(avWF_Motor,300);
dsavWF_Retro=downsample(avWF_Retro,300);
dsavWF_Somato=downsample(avWF_Somato,300);
dsavWF_Visual=downsample(avWF_Visual,300);
dsavWF_WB=downsample(avWF_WB,300);

%walking and whisking
dsPupil_walking=downsample(PUP_walking,300);
dsWhisk_walking=downsample(WHISK_walking,300);
dsWalk_walking=downsample(WALK_walking,300);
dsavWF_L_Motor_walking=downsample(avWF_L_Motor_walking,300);
dsavWF_L_Retro_walking=downsample(avWF_L_Retro_walking,300);
dsavWF_L_Somato_walking=downsample(avWF_L_Somato_walking,300);
dsavWF_L_Visual_walking=downsample(avWF_L_Visual_walking,300);
dsavWF_Motor_walking=downsample(avWF_Motor_walking,300);
dsavWF_Retro_walking=downsample(avWF_Retro_walking,300);
dsavWF_Somato_walking=downsample(avWF_Somato_walking,300);
dsavWF_Visual_walking=downsample(avWF_Visual_walking,300);
dsavWF_WB_walking=downsample(avWF_WB_walking,300);

%whisking no walking
dsPupil_whisk=downsample(PUP_whisk,300);
dsWhisk_whisk=downsample(WHISK_whisk,300);
dsWalk_whisk=downsample(WALK_whisk,300);
dsavWF_L_Motor_whisk=downsample(avWF_L_Motor_whisk,300);
dsavWF_L_Retro_whisk=downsample(avWF_L_Retro_whisk,300);
dsavWF_L_Somato_whisk=downsample(avWF_L_Somato_whisk,300);
dsavWF_L_Visual_whisk=downsample(avWF_L_Visual_whisk,300);
dsavWF_Motor_whisk=downsample(avWF_Motor_whisk,300);
dsavWF_Retro_whisk=downsample(avWF_Retro_whisk,300);
dsavWF_Somato_whisk=downsample(avWF_Somato_whisk,300);
dsavWF_Visual_whisk=downsample(avWF_Visual_whisk,300);
dsavWF_WB_whisk=downsample(avWF_WB_whisk,300);

%no whisking or walking
dsPupil_still=downsample(PUP_still,300);
dsWhisk_still=downsample(WHISK_still,300);
dsWalk_still=downsample(WALK_still,300);
dsavWF_L_Motor_still=downsample(avWF_L_Motor_still,300);
dsavWF_L_Retro_still=downsample(avWF_L_Retro_still,300);
dsavWF_L_Somato_still=downsample(avWF_L_Somato_still,300);
dsavWF_L_Visual_still=downsample(avWF_L_Visual_still,300);
dsavWF_Motor_still=downsample(avWF_Motor_still,300);
dsavWF_Retro_still=downsample(avWF_Retro_still,300);
dsavWF_Somato_still=downsample(avWF_Somato_still,300);
dsavWF_Visual_still=downsample(avWF_Visual_still,300);
dsavWF_WB_still=downsample(avWF_WB_still,300);

%% 
figure(1);
set(gcf,'color','w');
set(gcf,'Position',[100 100 800 800])
suptitle('Stationary - No Whisking or Walking') 
axpup=subplot(8,2,[1,2]);
stdshade(dsPupil_still',0.2,'k',dstime')
title('Pupil')

axwhisk=subplot(8,2,[3,4]);
stdshade(dsWhisk_still',0.2,'k',dstime')
title('Whisk')

axwalk=subplot(8,2,[5,6]);
stdshade(dsWalk_still',0.2,'k',dstime')
title('Walk')

subplot(8,2,[7,8]);
stdshade(dsavWF_WB_still',0.2,'k',dstime')
title('Whole Brain dF/F')
ylim([-0.02 0.15])
xlim([4 11])


subplot(8,2,9);
stdshade(dsavWF_Motor_still',0.2,'k',dstime')
title('Left Motor dF/F')
ylim([-0.02 0.15])
xlim([4 11])


subplot(8,2,10);
stdshade(dsavWF_L_Motor_still',0.2,'k',dstime')
title('Right Motor dF/F')
ylim([-0.02 0.15])
xlim([4 11])


subplot(8,2,11);
stdshade(dsavWF_Somato_still',0.2,'k',dstime')
title('Left Somatosensory dF/F')
ylim([-0.02 0.15])
xlim([4 11])


subplot(8,2,12);
stdshade(dsavWF_L_Somato_still',0.2,'k',dstime')
title('Right Somatosensory dF/F')
ylim([-0.02 0.15])
xlim([4 11])


subplot(8,2,13);
stdshade(dsavWF_Visual_still',0.2,'k',dstime')
title('Left Visual dF/F')
ylim([-0.02 0.15])
xlim([4 11])


subplot(8,2,14);
stdshade(dsavWF_L_Visual_still',0.2,'k',dstime')
title('Right Visual dF/F')
ylim([-0.02 0.15])
xlim([4 11])


subplot(8,2,15);
stdshade(dsavWF_Retro_still',0.2,'k',dstime')
title('Left Retrospenial dF/F')
ylim([-0.02 0.15])
xlim([4 11])


subplot(8,2,16);
stdshade(dsavWF_L_Retro_still',0.2,'k',dstime')
title('Right Retrospenial dF/F')
ylim([-0.02 0.15])
xlim([4 11])


axpup.YLim=([30 100])
axwalk.YLim=([-0.1 0.2])
axwhisk.YLim=([-0.05 0.3])



figure(2);
set(gcf,'color','w');
set(gcf,'Position',[100 100 800 800])
suptitle('Stationary - No Walking') 
axpup=subplot(8,2,[1,2]);
stdshade(dsPupil',0.2,'k',dstime')
title('Pupil')

axwhisk=subplot(8,2,[3,4]);
stdshade(dsWhisk_whisk',0.2,'k',dstime')
title('Whisk')

axwalk=subplot(8,2,[5,6]);
stdshade(dsWalk_whisk',0.2,'k',dstime')
title('Walk')

subplot(8,2,[7,8]);
stdshade(dsavWF_WB_whisk',0.2,'k',dstime')
title('Whole Brain dF/F')
ylim([-0.02 0.1])

subplot(8,2,9);
stdshade(dsavWF_Motor_whisk',0.2,'k',dstime')
title('Left Motor dF/F')
ylim([-0.02 0.1])

subplot(8,2,10);
stdshade(dsavWF_L_Motor_whisk',0.2,'k',dstime')
title('Right Motor dF/F')
ylim([-0.02 0.1])

subplot(8,2,11);
stdshade(dsavWF_Somato_whisk',0.2,'k',dstime')
title('Left Somatosensory dF/F')
ylim([-0.02 0.1])

subplot(8,2,12);
stdshade(dsavWF_L_Somato_whisk',0.2,'k',dstime')
title('Right Somatosensory dF/F')
ylim([-0.02 0.1])

subplot(8,2,13);
stdshade(dsavWF_Visual_whisk',0.2,'k',dstime')
title('Left Visual dF/F')
ylim([-0.02 0.1])

subplot(8,2,14);
stdshade(dsavWF_L_Visual_whisk',0.2,'k',dstime')
title('Right Visual dF/F')
ylim([-0.02 0.1])

subplot(8,2,15);
stdshade(dsavWF_Retro_whisk',0.2,'k',dstime')
title('Left Retrospenial dF/F')
ylim([-0.02 0.1])

subplot(8,2,16);
stdshade(dsavWF_L_Retro_whisk',0.2,'k',dstime')
title('Right Retrospenial dF/F')
ylim([-0.02 0.1])

axpup.YLim=([30 100])
axwalk.YLim=([-0.1 0.2])
axwhisk.YLim=([-0.05 0.3])


figure(3);
set(gcf,'color','w');
set(gcf,'Position',[100 100 800 800])
suptitle('Walking and Whisking') 
axpup=subplot(8,2,[1,2]);
stdshade(dsPupil_walking',0.2,'k',dstime')
title('Pupil')

axwhisk=subplot(8,2,[3,4]);
stdshade(dsWhisk_walking',0.2,'k',dstime')
title('Whisk')

axwalk=subplot(8,2,[5,6]);
stdshade(dsWalk_walking',0.2,'k',dstime')
title('Walk')

subplot(8,2,[7,8]);
stdshade(dsavWF_WB_walking',0.2,'k',dstime')
title('Whole Brain dF/F')
ylim([-0.02 0.1])

subplot(8,2,9);
stdshade(dsavWF_Motor_walking',0.2,'k',dstime')
title('Left Motor dF/F')
ylim([-0.02 0.1])

subplot(8,2,10);
stdshade(dsavWF_L_Motor_walking',0.2,'k',dstime')
title('Right Motor dF/F')
ylim([-0.02 0.1])

subplot(8,2,11);
stdshade(dsavWF_Somato_walking',0.2,'k',dstime')
title('Left Somatosensory dF/F')
ylim([-0.02 0.1])

subplot(8,2,12);
stdshade(dsavWF_L_Somato_walking',0.2,'k',dstime')
title('Right Somatosensory dF/F')
ylim([-0.02 0.1])

subplot(8,2,13);
stdshade(dsavWF_Visual_walking',0.2,'k',dstime')
title('Left Visual dF/F')
ylim([-0.02 0.1])

subplot(8,2,14);
stdshade(dsavWF_L_Visual_walking',0.2,'k',dstime')
title('Right Visual dF/F')
ylim([-0.02 0.1])

subplot(8,2,15);
stdshade(dsavWF_Retro_walking',0.2,'k',dstime')
title('Left Retrospenial dF/F')
ylim([-0.02 0.1])

subplot(8,2,16);
stdshade(dsavWF_L_Retro_walking',0.2,'k',dstime')
title('Right Retrospenial dF/F')
ylim([-0.02 0.1])

axpup.YLim=([30 100])
axwalk.YLim=([-0.1 0.2])
axwhisk.YLim=([-0.05 0.3])




% title('Left Motor dF/F')
% ylim([-0.02 0.1])
% plot(dstime,dsavWF_Motor,'Color',[0.85, 0.85, 0.85])
% hold on
% plot(dstime,mean(dsavWF_Motor,2),'k')
% hold off
% xlim([4 15])





figure(4);
set(gcf,'color','w');
set(gcf,'Position',[100 100 800 800])
suptitle('All combined') 
axpup=subplot(8,2,[1,2]);
stdshade(dsPupil',0.2,'k',dstime')
title('Pupil')
xlim([4 11])

axwhisk=subplot(8,2,[3,4]);
stdshade(dsWhisk',0.2,'k',dstime')
title('Whisk')
xlim([4 11])

axwalk=subplot(8,2,[5,6]);
stdshade(dsWalk',0.2,'k',dstime')
title('Walk')
xlim([4 11])

subplot(8,2,[7,8]);
stdshade(dsavWF_WB',0.2,'k',dstime')
title('Whole Brain dF/F')
ylim([-0.02 0.15])
xlim([4 11])

subplot(8,2,9);
stdshade(dsavWF_Motor',0.2,'k',dstime')
title('Left Motor dF/F')
ylim([-0.02 0.15])
xlim([4 11])

subplot(8,2,10);
stdshade(dsavWF_L_Motor',0.2,'k',dstime')
title('Right Motor dF/F')
ylim([-0.02 0.15])
xlim([4 11])

subplot(8,2,11);
stdshade(dsavWF_Somato',0.2,'k',dstime')
title('Left Somatosensory dF/F')
ylim([-0.02 0.15])
xlim([4 11])

subplot(8,2,12);
stdshade(dsavWF_L_Somato',0.2,'k',dstime')
title('Right Somatosensory dF/F')
ylim([-0.02 0.15])
xlim([4 11])

subplot(8,2,13);
stdshade(dsavWF_Visual',0.2,'k',dstime')
title('Left Visual dF/F')
ylim([-0.02 0.15])
xlim([4 11])

subplot(8,2,14);
stdshade(dsavWF_L_Visual',0.2,'k',dstime')
title('Right Visual dF/F')
ylim([-0.02 0.15])
xlim([4 11])

subplot(8,2,15);
stdshade(dsavWF_Retro',0.2,'k',dstime')
title('Left Retrospenial dF/F')
ylim([-0.02 0.15])
xlim([4 11])

subplot(8,2,16);
stdshade(dsavWF_L_Retro',0.2,'k',dstime')
title('Right Retrospenial dF/F')
ylim([-0.02 0.15])
xlim([4 11])


