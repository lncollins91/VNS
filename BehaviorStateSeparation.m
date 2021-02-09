%VNS4 WF State Separation and behavior graphing

% 

%Graphing all combined with behavioral measures
time=time(:,1);

figure;
set(gcf,'color','w');
set(gcf,'Position',[100 100 1000 1200])

subplot(4,1,1)
stdshade(avpup',0.2,'r',time',300)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([45 85]); 
xlim([0 20])
ylabel('Pupil Diameter (% of Max)')

subplot(4,1,2)
stdshade(avwhisk',0.2,'g',time',300)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([0 0.2]); 
xlim([0 20])
ylabel('Whisker Motion Energy')

subplot(4,1,3)
stdshade(avencoder',0.2,'m',time',300)
box off
set(gca,'TickDir','out');
ylim([-0.05 0.2]); 
xlim([0 20])
title('Walk Velocity (m/s)')
ylabel('Walk Velocity (m/s)')

subplot(4,1,4)
plot(time,avstim(:,1))
xlim([0 20])
set(gca,'TickDir','out');
box off
title('Stimulation')



%%
avencoder=abs(avencoder);
%split into walking and not walking
%hardcoded walk values
meanwalk=0.01;
sd_walk=0.004;
sd4_walk=sd_walk*4;
mean4sd=meanwalk+sd4_walk;
frq=8000;
% 
% % %uncomment if you want to determine mean and SD walk again
% figure ('Name','Walking Trace','units','normalized','outerposition',[0 0 1 1])
% plot(wfavencoder(:,1));
% title('Choose stationary segment.')
% [x1,~] =(ginput(1)); 
% [x2,~] = (ginput(1)); 
% close('Walking Trace');
% x1=round(x1); 
% x2=round(x2);
% mean_walk = mean(wfavencoder((x1:x2),1));
% sd_walk = std(wfavencoder((x1:x2),1));
% sd4_walk=(sd_walk*4);
% mean4sd=mean_walk+sd4_walk;

%find the average walking speed during stimulation each trial
avspeed = [];
% prewalk=frq*1;

for i = 1:size(avencoder,2)
     avspeed(:,i) = mean(avencoder((frq*5:frq*6),i));
end

this_WALK = [];
this_PUP = [];
this_WHISK = [];

WALK_walking = [];
PUP_walking = [];
WHISK_walking = [];

WALK_stationary = [];
PUP_stationary = [];
WHISK_stationary = [];



for i = 1:length(avspeed)
    if avspeed(i) > mean4sd
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));

        WALK_walking = [WALK_walking, this_WALK]; 
        PUP_walking = [PUP_walking, this_PUP];
        WHISK_walking = [WHISK_walking, this_WHISK];

    elseif avspeed(i) < mean4sd 
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));

        WALK_stationary = [WALK_stationary, this_WALK]; 
        PUP_stationary = [PUP_stationary, this_PUP];
        WHISK_stationary = [WHISK_stationary, this_WHISK];

    end
end



%% Graphing with behavioral measures
%Stationary WF with behavioral measures
figure;
set(gcf,'color','w');
set(gcf,'Position',[100 100 1000 1200])

subplot(4,1,1)
stdshade(PUP_stationary',0.2,'r',time',1000)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([45 85]); 
xlim([0 20])
ylabel('Pupil Diameter (% of Max)')

subplot(4,1,2)
stdshade(WHISK_stationary',0.2,'g',time',1000)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([0 0.2]); 
xlim([0 20])
ylabel('Whisker Motion Energy')

subplot(4,1,3)
stdshade(WALK_stationary',0.2,'m',time',1000)
box off
set(gca,'TickDir','out');
ylim([-0.05 0.15]); 
xlim([0 20])
title('Walk Velocity (m/s)')
ylabel('Walk Velocity (m/s)')

subplot(4,1,4)
plot(time,avstim(:,1))
xlim([0 20])
set(gca,'TickDir','out');
box off
title('Stimulation')


%Walking WF with behavioral measures
figure;
set(gcf,'color','w');
set(gcf,'Position',[100 100 1000 1200])

subplot(4,1,1)
stdshade(PUP_walking',0.2,'r',time',1000)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([45 85]); 
xlim([0 20])
ylabel('Pupil Diameter (% of Max)')

subplot(4,1,2)
stdshade(WHISK_walking',0.2,'g',time',1000)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([0 0.2]); 
xlim([0 20])
ylabel('Whisker Motion Energy')

subplot(4,1,3)
stdshade(WALK_walking',0.2,'m',time',1000)
box off
set(gca,'TickDir','out');
ylim([-0.05 0.15]); 
xlim([0 20])
title('Walk Velocity (m/s)')
ylabel('Walk Velocity (m/s)')

subplot(4,1,4)
plot(time,avstim(:,1))
xlim([0 20])
set(gca,'TickDir','out');
box off
title('Stimulation')

