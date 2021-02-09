%   Pupil analysis
%calculate mean, std, and sem values of baseline to peak within 3 seconds
Fs=8000;
%basepup=avpup(1:5*Fs,:);
basepup=avpup(3*Fs:5*Fs,:);
%[peakpup indpeakpup]=max(avpup((5*Fs:8*Fs),:));
peakpup = mean(avpup((6*Fs:8*Fs),:),1);
meanbasepup=nanmean(basepup,1);
changepup=((peakpup-meanbasepup)./ meanbasepup)*100;
N=size(avpup,2);
meanchange=nanmean(changepup);
stdchange=nanstd(changepup);
semchange=stdchange/sqrt(N);

%create pre vs post scatter plot
lne=1:100;
figure;
scatter(meanbasepup,peakpup,'k')
hold on
plot(lne,lne,'k')
xlim([20 100])
ylim([20,100])
xlabel('Pre-stim pupil % of Max')
ylabel('Post-stim pupil % of Max')

%plot pupil with peak indices
figure;
plot(avpup)
hold on
plot(indpeakpup+40000,peakpup,'r*')

%stdshade
time=time(:,1);

figure;
subplot(4,1,1)
stdshade(avpup',0.2,'r',time',300)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([25 85]); 
xlim([0 30])

subplot(4,1,2)
stdshade(avwhisk',0.2,'g',time',300)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([-0.05 0.2]); 
xlim([0 30])
ylabel('Whisker Motion Energy')

subplot(4,1,3)
stdshade(avencoder',0.2,'m',time',300)
box off
set(gca,'TickDir','out');
ylim([-0.05 0.2]); 
xlim([0 30])
title('Walk Velocity (m/s)')
ylabel('Walk Velocity (m/s)')

%%
%Test walk script
avencoder_abs=abs(avencoder);
avencoder_mean=movmean(avencoder_abs,1000);

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
    findWalkBouts_Dennis_Tai(time(:,1),avencoder_mean(:,i),0.01,1,3); 
%time, values, speed threshold(cm/s), min time for long walk boub   t, min times between bouts 
           
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

WALK_walking = [];
PUP_walking = [];
WHISK_walking = [];


WALK_twitch = [];
PUP_twitch = [];
WHISK_twitch = [];

   

WALK_stationary = [];
PUP_stationary = [];
WHISK_stationary = [];

for i =1:size(avencoder,2);
     if state(i)==2;
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
    
        WALK_walking = [WALK_walking, this_WALK]; 
        PUP_walking = [PUP_walking, this_PUP];
        WHISK_walking = [WHISK_walking, this_WHISK];
      
        
    elseif state(i)==1;
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
      
%         
        WALK_twitch = [WALK_twitch, this_WALK]; 
        PUP_twitch = [PUP_twitch, this_PUP];
        WHISK_twitch = [WHISK_twitch, this_WHISK];
      
        
    elseif state(i)==0;
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
     
        
        WALK_stationary = [WALK_stationary, this_WALK]; 
        PUP_stationary = [PUP_stationary, this_PUP];
        WHISK_stationary = [WHISK_stationary, this_WHISK];
      
    end
end