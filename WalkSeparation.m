%Test walk script
avencoder_abs=abs(avencoder);

avencoder_mean=movmean(avencoder_abs,5000);
avwhisk_mean=movmean(avwhisk,1000);

%smooth walk first
final_time_all_inds=[];
long_bout_inds=[];
long_bout_binary=[];
short_bout_inds=[];
short_bout_binary=[];

for i=1:size(avencoder,2);
    %remember to comment out the plot at the end of the function if you
    %want to avoid slow plotting of many graphs
[this_final_time_all_inds, this_long_bout_inds, this_long_bout_binary,...
    this_short_bout_inds, this_short_bout_binary] = ...
    findWalkBouts_Dennis_Tai(time(:,1),avencoder_mean(:,i),0.03,0.5,3); 
%time, values, speed threshold(cm/s), min time for long walk bout, min times between bouts 
           
final_time_all_inds{1,i}=this_final_time_all_inds;
long_bout_inds{1,i}=this_long_bout_inds;
long_bout_binary=[long_bout_binary,this_long_bout_binary];
short_bout_inds{1,i}=this_short_bout_inds;
short_bout_binary=[short_bout_binary,this_short_bout_binary];
end

disp('done');


frq=8000;
state=zeros(1,size(avencoder,2));

for i = 1:size(avencoder,2)
      if sum(long_bout_binary((frq*5:frq*7)-1,i))>0
     state(:,i)=state(:,i)+2; %2 means walking
     
      elseif sum(short_bout_binary((frq*5:frq*7)-1,i))>0
     state(:,i)=state(:,i)+1; %1 means twitch
     
     %0     means stationary
     
      end
end

this_WALK = [];
this_PUP = [];
this_WHISK = [];
% this_avWF_WB = [];
% this_avWF_Motor = [];
% this_avWF_Somato = [];
% this_avWF_Visual = [];
% this_avWF_Retro = [];
% this_avWF_L_Motor = [];
% this_avWF_L_Somato = [];
% this_avWF_L_Visual = [];
% this_avWF_L_Retro = [];

WALK_walking = [];
PUP_walking = [];
WHISK_walking = [];
% avWF_WB_walking = [];
% avWF_Motor_walking = [];
% avWF_Somato_walking = [];
% avWF_Visual_walking = [];
% avWF_Retro_walking = [];
% avWF_L_Motor_walking = [];
% avWF_L_Somato_walking = [];
% avWF_L_Visual_walking = [];
% avWF_L_Retro_walking = [];

WALK_twitch = [];
PUP_twitch = [];
WHISK_twitch = [];
% avWF_WB_twitch = [];
% avWF_Motor_twitch = [];
% avWF_Somato_twitch = [];
% avWF_Visual_twitch = [];
% avWF_Retro_twitch = [];
% avWF_L_Motor_twitch = [];
% avWF_L_Somato_twitch = [];
% avWF_L_Visual_twitch = [];
% avWF_L_Retro_twitch = [];
%    

WALK_stationary = [];
PUP_stationary = [];
WHISK_stationary = [];
% avWF_WB_stationary = [];
% avWF_Motor_stationary = [];
% avWF_Somato_stationary = [];
% avWF_Visual_stationary = [];
% avWF_Retro_stationary = [];
% avWF_L_Motor_stationary = [];
% avWF_L_Somato_stationary = [];
% avWF_L_Visual_stationary = [];
% avWF_L_Retro_stationary = [];

for i =1:size(avencoder,2);
     if state(i)==2;
        this_WALK = (avencoder_mean(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
%         this_avWF_WB = (avWF_WB(:,i));
%         this_avWF_Motor = (avWF_Motor(:,i));
%         this_avWF_Somato = (avWF_Somato(:,i));
%         this_avWF_Visual = (avWF_Visual(:,i));
%         this_avWF_Retro = (avWF_Retro(:,i));
%         this_avWF_L_Motor = (avWF_L_Motor(:,i));
%         this_avWF_L_Somato = (avWF_L_Somato(:,i));
%         this_avWF_L_Visual = (avWF_L_Visual(:,i));
%         this_avWF_L_Retro = (avWF_L_Retro(:,i));
% %         
        WALK_walking = [WALK_walking, this_WALK]; 
        PUP_walking = [PUP_walking, this_PUP];
        WHISK_walking = [WHISK_walking, this_WHISK];
%         avWF_WB_walking = [avWF_WB_walking, this_avWF_WB]; 
%         avWF_Motor_walking = [avWF_Motor_walking, this_avWF_Motor];
%         avWF_Somato_walking = [avWF_Somato_walking, this_avWF_Somato]; 
%         avWF_Visual_walking = [avWF_Visual_walking, this_avWF_Visual];
%         avWF_Retro_walking = [avWF_L_Retro_walking, this_avWF_Retro];
%         avWF_L_Motor_walking = [avWF_L_Motor_walking, this_avWF_L_Motor];
%         avWF_L_Somato_walking = [avWF_L_Somato_walking, this_avWF_L_Somato]; 
%         avWF_L_Visual_walking = [avWF_L_Visual_walking, this_avWF_L_Visual];
%         avWF_L_Retro_walking = [avWF_L_Retro_walking, this_avWF_L_Retro];
        
    elseif state(i)==1;
        this_WALK = (avencoder_mean(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
%         this_avWF_WB = (avWF_WB(:,i));
%         this_avWF_Motor = (avWF_Motor(:,i));
%         this_avWF_Somato = (avWF_Somato(:,i));
%         this_avWF_Visual = (avWF_Visual(:,i));
%         this_avWF_Retro = (avWF_Retro(:,i));
%         this_avWF_L_Motor = (avWF_L_Motor(:,i));
%         this_avWF_L_Somato = (avWF_L_Somato(:,i));
%         this_avWF_L_Visual = (avWF_L_Visual(:,i));
%         this_avWF_L_Retro = (avWF_L_Retro(:,i));
% %         
        WALK_twitch = [WALK_twitch, this_WALK]; 
        PUP_twitch = [PUP_twitch, this_PUP];
        WHISK_twitch = [WHISK_twitch, this_WHISK];
%         avWF_WB_twitch = [avWF_WB_twitch, this_avWF_WB]; 
%         avWF_Motor_twitch = [avWF_Motor_twitch, this_avWF_Motor];
%         avWF_Somato_twitch = [avWF_Somato_twitch, this_avWF_Somato]; 
%         avWF_Visual_twitch = [avWF_Visual_twitch, this_avWF_Visual];
%         avWF_Retro_twitch = [avWF_L_Retro_twitch, this_avWF_Retro];
%         avWF_L_Motor_twitch = [avWF_L_Motor_twitch, this_avWF_L_Motor];
%         avWF_L_Somato_twitch = [avWF_L_Somato_twitch, this_avWF_L_Somato]; 
%         avWF_L_Visual_twitch = [avWF_L_Visual_twitch, this_avWF_L_Visual];
%         avWF_L_Retro_twitch = [avWF_L_Retro_twitch, this_avWF_L_Retro];
        
    elseif state(i)==0;
        this_WALK = (avencoder_mean(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
%         this_avWF_WB = (avWF_WB(:,i));
%         this_avWF_Motor = (avWF_Motor(:,i));
%         this_avWF_Somato = (avWF_Somato(:,i));
%         this_avWF_Visual = (avWF_Visual(:,i));
%         this_avWF_Retro = (avWF_Retro(:,i));
%         this_avWF_L_Motor = (avWF_L_Motor(:,i));
%         this_avWF_L_Somato = (avWF_L_Somato(:,i));
%         this_avWF_L_Visual = (avWF_L_Visual(:,i));
%         this_avWF_L_Retro = (avWF_L_Retro(:,i));
        
        WALK_stationary = [WALK_stationary, this_WALK]; 
        PUP_stationary = [PUP_stationary, this_PUP];
        WHISK_stationary = [WHISK_stationary, this_WHISK];
%         avWF_WB_stationary = [avWF_WB_stationary, this_avWF_WB]; 
%         avWF_Motor_stationary = [avWF_Motor_stationary, this_avWF_Motor];
%         avWF_Somato_stationary = [avWF_Somato_stationary, this_avWF_Somato]; 
%         avWF_Visual_stationary = [avWF_Visual_stationary, this_avWF_Visual];        
%         avWF_Retro_stationary = [avWF_Retro_stationary, this_avWF_Retro];
%         avWF_L_Motor_stationary = [avWF_L_Motor_stationary, this_avWF_L_Motor];
%         avWF_L_Somato_stationary = [avWF_L_Somato_stationary, this_avWF_L_Somato]; 
%         avWF_L_Visual_stationary = [avWF_L_Visual_stationary, this_avWF_L_Visual];        
%         avWF_L_Retro_stationary = [avWF_L_Retro_stationary, this_avWF_L_Retro];
    end
end

%% code to pull out stationary/no whisks
avwhisk_meansplit=WHISK_stationary;

%smooth walk first
final_time_all_inds=[];
long_bout_inds=[];
long_bout_binary=[];
short_bout_inds=[];
short_bout_binary=[];

for i=1:size(avwhisk_meansplit,2);
    %remember to comment out the plot at the end of the function if you
    %want to avoid slow plotting of many graphs
[this_final_time_all_inds, this_long_bout_inds, this_long_bout_binary,...
    this_short_bout_inds, this_short_bout_binary] = ...
    findWalkBouts_Dennis_Tai(time(:,1),avwhisk_meansplit(:,i),0.05,0.5,5); 
%time, values, speed threshold(cm/s), min time for long walk bout, min times between bouts 
           
final_time_all_inds{1,i}=this_final_time_all_inds;
long_bout_inds{1,i}=this_long_bout_inds;
long_bout_binary=[long_bout_binary,this_long_bout_binary];
short_bout_inds{1,i}=this_short_bout_inds;
short_bout_binary=[short_bout_binary,this_short_bout_binary];
end

disp('done');


frq=8000;
state=zeros(1,size(avwhisk_meansplit,2));

for i = 1:size(avwhisk_meansplit,2)
      if sum(long_bout_binary((frq*5:frq*7)-1,i))>0
     state(:,i)=state(:,i)+2; %2 means walking
     
      elseif sum(short_bout_binary((frq*5:frq*7)-1,i))>0
     state(:,i)=state(:,i)+1; %1 means twitch
     
     %0     means stationary
     
      end
end



this_WALK = [];
this_PUP = [];
this_WHISK = [];

WALK_whisking = [];
PUP_whisking = [];
WHISK_whisking = [];

WALK_whisktwitch = [];
PUP_whisktwitch = [];
WHISK_whisktwitch = [];

WALK_still = [];
PUP_still = [];
WHISK_still = [];


for i =1:size(WALK_stationary,2);
     if state(i)==2;
        this_WALK = (WALK_stationary(:,i));
        this_PUP = (PUP_stationary(:,i));
        this_WHISK = (WHISK_stationary(:,i));
 
        WALK_whisking = [WALK_whisking, this_WALK]; 
        PUP_whisking = [PUP_whisking, this_PUP];
        WHISK_whisking = [WHISK_whisking, this_WHISK];

        
    elseif state(i)==1;
        this_WALK = (WALK_stationary(:,i));
        this_PUP = (PUP_stationary(:,i));
        this_WHISK = (WHISK_stationary(:,i));
 
        WALK_whisktwitch = [WALK_whisktwitch, this_WALK]; 
        PUP_whisktwitch = [PUP_whisktwitch, this_PUP];
        WHISK_whisktwitch = [WHISK_whisktwitch, this_WHISK];

        
    elseif state(i)==0;
        this_WALK = (WALK_stationary(:,i));
        this_PUP = (PUP_stationary(:,i));
        this_WHISK = (WHISK_stationary(:,i));

        
        WALK_still = [WALK_still, this_WALK]; 
        PUP_still = [PUP_still, this_PUP];
        WHISK_still = [WHISK_still, this_WHISK];

    end
end




%%

%Graphing all combined with behavioral measures
time=time(:,1);

figure;
set(gcf,'color','w');
set(gcf,'Position',[100 100 1000 1200])

subplot(4,1,1)
stdshade(PUP_still',0.2,'r',time',300)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([45 85]); 
xlim([0 20])
ylabel('Pupil Diameter (% of Max)')
title('Still')

subplot(4,1,2)
stdshade(WHISK_still',0.2,'g',time',300)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([-0.05 0.1]); 
xlim([0 20])
ylabel('Whisker Motion Energy')

subplot(4,1,3)
stdshade(WALK_still',0.2,'m',time',300)
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


figure;
set(gcf,'color','w');
set(gcf,'Position',[100 100 1000 1200])

subplot(4,1,1)
stdshade(PUP_whisking',0.2,'r',time',300)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([45 85]); 
xlim([0 20])
ylabel('Pupil Diameter (% of Max)')
title('Whisking')

subplot(4,1,2)
stdshade(WHISK_whisking',0.2,'g',time',300)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([-0.05 0.1]); 
xlim([0 20])
ylabel('Whisker Motion Energy')

subplot(4,1,3)
stdshade(WALK_whisking',0.2,'m',time',300)
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


figure;
set(gcf,'color','w');
set(gcf,'Position',[100 100 1000 1200])

subplot(4,1,1)
stdshade(PUP_walking',0.2,'r',time',300)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([50 90]); 
xlim([0 20])
ylabel('Pupil Diameter (% of Max)')
title('Walking')

subplot(4,1,2)
stdshade(WHISK_walking',0.2,'g',time',300)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([-0.05 0.1]); 
xlim([0 20])
ylabel('Whisker Motion Energy')

subplot(4,1,3)
stdshade(WALK_walking',0.2,'m',time',300)
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

