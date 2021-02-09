%VNS3 - Graphing and State Separation for Ephys data
%new ephys script for Feb 19 darpa update
%Can also do whisking AND walking state separation if you uncomment some
%parts 

lengthofstim=3; %change depending on length of stim 1, 5 or 0.5
pre_stimchop=3;


data_filt=avSU_hits'; %transpose to correctly detect units
data_mu=zeros(size(data_filt,1),size(data_filt,2)); %preallocate space
frq=8000;

ints=1/frq;
figure;    
plot(data_filt(1,:)) %%plots the MU trace - you select two points to calculate mean/sd
[x1,~] =(ginput(1)); %select first x-coordinate
[x2,~] = (ginput(1)); %select second x-coordinate
x1=round(x1); %round to make a full integer
x2=round(x2);    
 
x=4;
%Detect Spikes
for i=1:size(data_filt,1)
         disp(num2str(i))
        sd(i)=std(data_filt(i,x1:x2));
        [v1,idx1]=findpeaks(data_filt(i,:),'MinPeakHeight',x*sd(i),...
            'MinPeakDistance',ints);
        [v2,idx2]=findpeaks(-data_filt(i,:),'MinPeakHeight',x*sd(i),...
            'MinPeakDistance',ints);
        tmp=[idx1';idx2'];
        [tmp1(:,1),tmp1(:,2)]=sort(tmp);
        tmp=[v1';v2'];
        tmp2=tmp(tmp1(:,2));
        data_mu(i,tmp1(:,1))=tmp2;
        clear('tmp1')
end



% Calculate and plot spike rate
start=1;
window=frq/10;  %10 for 100ms bins
numbins=abs(length(avSU_hits)-1)/window; 
increment=0;

spikecountbin=zeros((size(data_mu,1)),numbins);
data_mu(data_mu > 0) = 1; 

%check accuracy of spike detection
figure;
plot(data_mu(1,:)', 'm'),; hold on; plot(data_filt(1,:),'k');
% ylim([0, 0.5])
% xlim([200000,300000])

data_mu = data_mu(:,1:(window*numbins));


for i = 1:size(data_mu,1)
    this_trace = data_mu(i,:);
    this_trace_rs = reshape(this_trace,[],numbins); 
    this_spike_rate = sum(this_trace_rs, 1);
%     figure; %uncomment to see every binnedspike rate trace
%     plot(this_spike_rate)
    spikecountbin(i,:) = this_spike_rate;
end

%compensate spike rate for artifact blanking

stimstart=pre_stimchop*10;
comp_spikecountbin= spikecountbin;
comp_spikecountbin(:,(stimstart:stimstart+lengthofstim*10))=comp_spikecountbin(:,stimstart:stimstart+lengthofstim*10)*1.081;  % *10 because of 100ms bins

avspikerate=mean(comp_spikecountbin,1);
sdspikerate=std(comp_spikecountbin,1);
semspikerate=std(comp_spikecountbin,1)/sqrt(size(data_filt,1));

figure;
subplot(1,1,1)
bar(avspikerate+semspikerate,'FaceColor',[0.8 0.8 0.8])
title('Spike Rate - High Arousal')
% ylim([0 20]);
xlim([0 600])
hold on 
bar(avspikerate)
title('Spike Rate -Compensated - all traces')
% ylim([0 20]); 
xlim([0 600])


%split into walking and not walking
%hardcoded walk values
meanwalk=0.01;
sd_walk=0.004;
sd4_walk=sd_walk*4;
mean4sd=meanwalk+sd4_walk;

% %uncomment for whiskerANDwalking state separation
% meanwhisk=0.0112;
% sd_whisk=0.0106;
% sd4_whisk=sd_whisk*4;
% mean4sdwhisk=meanwhisk+sd4_whisk;


% %uncomment if you want to determine mean and SD walk again
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
prewalk=frq*1;

for i = 1:size(avencoder,2)
     avspeed(:,i) = mean(avencoder((frq*pre_stimchop:(frq*(pre_stimchop+lengthofstim))),i));
end

% avwhisking = [];
% prewalk=frq*1;
% 
% for i = 1:size(avwhisk,2)
%      avwhisking(:,i) = mean(avwhisk((frq*5:(frq*6)),i));
% end


this_WALK = [];
this_PUP = [];
this_WHISK = [];
this_LFP = [];
this_SU = [];
this_spikerate = [];
this_raster=[];
WALK_walking = [];
PUP_walking = [];
WHISK_walking = [];
LFP_walking = [];
SU_walking = [];
WALK_stationary = [];
PUP_stationary = [];
WHISK_stationary = [];
LFP_stationary = [];
SU_stationary = [];
comp_spikecountbin_walking=[];
comp_spikecountbin_stationary=[];
raster_stationary=[];
raster_walking=[];

g=0;

for i = 1:length(avspeed)
     if avspeed(i) > mean4sd %& avwhisking(i) > mean4sdwhisk 
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
        this_LFP = (avlfp(:,i));
        this_SU = (avSU(:,i));
        this_spikerate=(comp_spikecountbin(i,:)');
        this_raster=(data_mu(i,:)');
        WALK_walking = [WALK_walking, this_WALK]; 
        PUP_walking = [PUP_walking, this_PUP];
        WHISK_walking = [WHISK_walking, this_WHISK];
        LFP_walking = [LFP_walking, this_LFP]; 
        SU_walking = [SU_walking, this_SU];
        comp_spikecountbin_walking = [comp_spikecountbin_walking, this_spikerate];
        raster_walking= [raster_walking, this_raster];
        
        
    elseif avspeed(i) < mean4sd %& avwhisking(i) < mean4sdwhisk
        this_WALK = (avencoder(:,i));
        this_PUP = (avpup(:,i));
        this_WHISK = (avwhisk(:,i));
        this_LFP = (avlfp(:,i));
        this_SU = (avSU(:,i));
        this_spikerate=(comp_spikecountbin(i,:))';
        this_raster=(data_mu(i,:)');
        WALK_stationary = [WALK_stationary, this_WALK]; 
        PUP_stationary = [PUP_stationary, this_PUP];
        WHISK_stationary = [WHISK_stationary, this_WHISK];
        LFP_stationary = [LFP_stationary, this_LFP]; 
        SU_stationary = [SU_stationary, this_SU];
        comp_spikecountbin_stationary = [comp_spikecountbin_stationary, this_spikerate];
        raster_stationary= [raster_stationary, this_raster];
    else 
        g=g+1
  
    end
end

comp_spikecountbin_walking=comp_spikecountbin_walking';
comp_spikecountbin_stationary=comp_spikecountbin_stationary';


avspikerate_walking=mean(comp_spikecountbin_walking,1);
sdspikerate_walking=std(comp_spikecountbin_walking,1);
semspikerate_walking=std(comp_spikecountbin_walking,1)/sqrt(size(comp_spikecountbin_walking,1));

avspikerate_stationary=mean(comp_spikecountbin_stationary,1);
sdspikerate_stationary=std(comp_spikecountbin_stationary,1);
semspikerate_stationary=std(comp_spikecountbin_stationary,1)/sqrt(size(comp_spikecountbin_stationary,1));

raster_all=logical(data_mu);
raster_walking=logical(raster_walking');
raster_stationary=logical(raster_stationary');


figure;
subplot(6,1,1)
bar(avspikerate+semspikerate,'FaceColor',[0.8 0.8 0.8])
xlim([0 600])
hold on 
bar(avspikerate)
title('Spike Rate -Compensated - all traces')
ylim([0 15]); 
xlim([0 600])
ylabel('Spike Rate (spikes per 100ms)')

subplot(6,1,2)
plotSpikeRaster(raster_all,'PlotType','vertline'); %'PlotType','scatter' for dots, 'PlotType','vertline' for lines
ylabel('Trial')
set(gca,'XTick',[]);

subplot(6,1,3)
bar(avspikerate_walking+semspikerate_walking,'FaceColor',[0.8 0.8 0.8])
title('Spike Rate - Walking')
xlim([0 600])
hold on 
bar(avspikerate_walking)
ylim([0 15]); 
xlim([0 600])
ylabel('Spike Rate (spikes per 100ms)')

subplot(6,1,4)
plotSpikeRaster(raster_walking,'PlotType','vertline'); %'PlotType','scatter' for dots, 'PlotType','vertline' for lines
ylabel('Trial')
set(gca,'XTick',[]);

subplot(6,1,5)
bar(avspikerate_stationary+semspikerate_stationary,'FaceColor',[0.8 0.8 0.8])
title('Spike Rate - Stationary')
xlim([0 600])
hold on 
bar(avspikerate_stationary)
ylim([0 15]); 
xlim([0 600])
ylabel('Spike Rate (spikes per 100ms)')

subplot(6,1,6)
plotSpikeRaster(raster_stationary,'PlotType','vertline'); %'PlotType','scatter' for dots, 'PlotType','vertline' for lines
ylabel('Trial')
set(gca,'XTick',[]);



%% Graphing with behavioral measures
time=time(:,1);

%Stationary Ephys with behavioral measures
figure;



set(gcf,'Position',[100 100 1000 1200])
subplot(5,1,1)
bar(avspikerate_stationary+semspikerate_stationary,'FaceColor',[0.8 0.8 0.8])
box off
set(gca,'TickDir','out');
title('Spike Rate - Stationary')
xlim([0 200])
hold on 
bar(avspikerate_stationary,'k')
set(gca,'TickDir','out');
ylim([0 15]); 
xlim([0 200])
ylabel('Spike Rate (spikes per 100ms)')

subplot(5,1,2)
stdshade(PUP_stationary',0.2,'r',time',200)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([45 85]); 
xlim([0 20])
ylabel('Pupil Diameter (% of Max)')

subplot(5,1,3)
stdshade(WHISK_stationary',0.2,'g',time',200)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([0 0.2]); 
xlim([0 20])
ylabel('Whisker Motion Energy')

subplot(5,1,4)
stdshade(WALK_stationary',0.2,'m',time',200)
box off
set(gca,'TickDir','out');
ylim([-0.01 0.4]); 
xlim([0 20])
title('Walk Velocity (m/s)')
ylabel('Walk Velocity (m/s)')

subplot(5,1,5)
plot(time,avstim(:,1))
xlim([0 20])
set(gca,'TickDir','out');
box off
title('Stimulation')



%Walking Ephys with behavioral measures
figure;
box off
set(gcf,'color','w');
subplot(5,1,1)
set(gcf,'Position',[100 100 1000 1200])
bar(avspikerate_walking+semspikerate_walking,'FaceColor',[0.8 0.8 0.8])
box off
set(gca,'TickDir','out');
title('Spike Rate - Walking')
xlim([0 200])
hold on 
bar(avspikerate_walking,'k')
set(gca,'TickDir','out');
ylim([0 15]); 
xlim([0 200])
ylabel('Spike Rate (spikes per 100ms)')

subplot(5,1,2)
stdshade(PUP_walking',0.2,'r',time',200)
box off
set(gca,'TickDir','out');
title('Pupil')
ylim([45 85]); 
xlim([0 20])
ylabel('Pupil Diameter (% of Max)')

subplot(5,1,3)
stdshade(WHISK_walking',0.2,'g',time',200)
box off
set(gca,'TickDir','out');
title('Whisker Motion Energy')
ylim([0 0.2]); 
xlim([0 20])
ylabel('Whisker Motion Energy')

subplot(5,1,4)
stdshade(WALK_walking',0.2,'m',time',200)
box off
set(gca,'TickDir','out');
title('Walk Velocity(cm/s)')
ylim([-0.01 0.4]); 
xlim([0 20])
ylabel('Walk Velocity (cm/s)')

subplot(5,1,5)
plot(time,avstim(:,1))
xlim([0 20])
box off
set(gca,'TickDir','out');
title('Stimulation')
ylabel('VNS')



% 
%% for plotting all of something
% for i= 1:size(avwhisk,2)
%     figure;
%     plot(avwhisk(:,i))
% end
% 
% avSU(:,16:47)=NaN;
% avpup(:,26)=NaN;