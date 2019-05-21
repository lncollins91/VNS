function [avpup,avpuppre,avencoder,avwhisk,avlfp,avSU,time,WALK_Sig,WALK_NonSig,PUP_Sig,PUP_NonSig,WHISK_Sig,WHISK_NonSig,LFP_Sig,LFP_NonSig,SU_Sig,SU_NonSig, WALK_high,PUP_high,WHISK_high,LFP_high,SU_high,WALK_low,PUP_low,WHISK_low,LFP_low,SU_low,WALK_int,PUP_int,WHISK_int,LFP_int,SU_int,prestim_pupav,PCP,mean4sd,prewalk,avpuppret] = VNScalcs(pre,post,pks,locs,tsresam_pupil,tsresam_encoder,tsresam_whisk,tsresam_lfp,tsresam_SU,Resamp_r)
%This function will separate out all of the variables based on arousal state and,
%walking
%   Detailed explanation goes here...


%-------Average traces 
%preallocate all variables for speed
avpup=zeros(pre+post+1,length(pks));
avpuppre=zeros(pre+1,length(pks));
avencoder=zeros(pre+post+1,length(pks));
avwhisk=zeros(pre+post+1,length(pks));
avlfp=zeros(pre+post+1,length(pks));
avSU=zeros(pre+post+1,length(pks));
%Pull out data for Pupil, encoder, whisk, lfp and SU for each stim

for k = 1:length(pks)
    %Pupil
       avpup(:,k)=tsresam_pupil.Data(locs(k)-pre:locs(k)+post); %pupil at each stim
       avpuppre(:,k)=tsresam_pupil.data(locs(k)-pre:locs(k));   %pupil prestim
    %Encoder
       avencoder(:,k)=tsresam_encoder.data(locs(k)-pre:locs(k)+post); %encoder at each stim
    %Whisk
       avwhisk(:,k)=tsresam_whisk.data(locs(k)-pre:locs(k)+post); %whisk at each stim
    %LFP
       %avlfp(:,k)=tsresam_lfp.data(locs(k)-pre:locs(k)+post); %lfp at each stim
    %SU
       %avSU(:,k)=tsresam_SU.data(locs(k)-pre:locs(k)+post); %SU at each stim
end

%transpose variables for stdshade
avpupt = avpup';
avpuppret = avpuppre';
avencodert = avencoder';
avwhiskt = avwhisk';
avlfpt = avlfp';
avSUt = avSU';

%make timebase for graphs
pup_t=tsresam_pupil.time(locs(1)-pre:locs(1)+post);
time=(linspace(0,(max(pup_t)-min(pup_t)),pre+post+1))';


%--------separate out walking traces 
%pick a point where the animal isn't walking and calculate 4x the stdev of
%that section of encoder trace
figure ('Name','Walking Trace','units','normalized','outerposition',[0 0 1 1])
plot(tsresam_encoder.Data) 
title('Choose stationary segment.')
[x1,~] =(ginput(1)); 
[x2,~] = (ginput(1)); 
close('Walking Trace');
x1=round(x1); 
x2=round(x2);
mean_walk = mean(tsresam_encoder.data(x1:x2));
sd_walk = std(tsresam_encoder.data(x1:x2));
sd4_walk=(sd_walk*4);
mean4sd=mean_walk+sd4_walk;
%find the average walking speed BEFORE each trial
avspeed = [];
prewalk=Resamp_r*1;

for s = 1:length(pks)
     avspeed(:,s) = mean(tsresam_encoder.data(locs(s)-prewalk:locs(s)));
end

%-------separate into two new matrices based on walking
WALK_Sig =[];
WALK_NonSig =[];
PUP_Sig = [];
PUP_NonSig = [];
WHISK_Sig = [];
WHISK_NonSig = [];
LFP_Sig = [];
LFP_NonSig = [];
SU_Sig = [];
SU_NonSig = [];
this_WALK = [];
this_PUP = [];
this_WHISK = [];
this_LFP = [];
this_SU=[];
for b = 1:length(avspeed)
    if avspeed(b) > mean4sd
        this_WALK = (tsresam_encoder.Data((locs(b)-pre):(locs(b)+post)));
        this_PUP = (tsresam_pupil.Data((locs(b)-pre):(locs(b)+post)));
        this_WHISK = (tsresam_whisk.Data((locs(b)-pre):(locs(b)+post)));
        this_LFP = (tsresam_lfp.Data((locs(b)-pre):(locs(b)+post)));
        this_SU = (tsresam_SU.Data((locs(b)-pre):(locs(b)+post)));
        WALK_Sig = [WALK_Sig, this_WALK]; 
        PUP_Sig = [PUP_Sig, this_PUP];
        WHISK_Sig = [WHISK_Sig, this_WHISK];
        LFP_Sig = [LFP_Sig, this_LFP]; 
        SU_Sig = [SU_Sig, this_SU];
        
    elseif  avspeed(b) <= mean4sd
        this_WALK = (tsresam_encoder.Data((locs(b)-pre):(locs(b)+post)));
        this_PUP = (tsresam_pupil.Data((locs(b)-pre):(locs(b)+post)));
        this_WHISK = (tsresam_whisk.Data((locs(b)-pre):(locs(b)+post)));
        this_LFP = (tsresam_lfp.Data((locs(b)-pre):(locs(b)+post)));
        this_SU = (tsresam_SU.Data((locs(b)-pre):(locs(b)+post)));
        WALK_NonSig = [WALK_NonSig, this_WALK];
        PUP_NonSig = [PUP_NonSig, this_PUP];
        WHISK_NonSig = [WHISK_NonSig, this_WHISK];
        LFP_NonSig = [LFP_NonSig, this_LFP]; 
        SU_NonSig = [SU_NonSig, this_SU];
    else
        disp('Error Generated. Please Check inputs/outputs to FOR Loop.') 
    end
end


%--------Separate based on arousal state

WALK_high =[];
WALK_int =[];
WALK_low =[];

PUP_high = [];
PUP_int = [];
PUP_low = [];

WHISK_high = [];
WHISK_int = [];
WHISK_low = [];

LFP_high =[];
LFP_int =[];
LFP_low =[];

SU_high =[];
SU_int =[];
SU_low =[];

this_WALK = [];
this_PUP = [];
this_WHISK = [];
this_LFP = [];
this_SU=[];

for b = 1:length(pks)
    if mean(avpuppret(b)) >= 70 
        this_WALK = (tsresam_encoder.Data((locs(b)-pre):(locs(b)+post)));
        this_PUP = (tsresam_pupil.Data((locs(b)-pre):(locs(b)+post)));
        this_WHISK = (tsresam_whisk.Data((locs(b)-pre):(locs(b)+post)));
        this_LFP = (tsresam_lfp.Data((locs(b)-pre):(locs(b)+post)));
        this_SU = (tsresam_SU.Data((locs(b)-pre):(locs(b)+post)));
        WALK_high = [WALK_high, this_WALK]; 
        PUP_high = [PUP_high, this_PUP];
        WHISK_high = [WHISK_high, this_WHISK];
        LFP_high = [LFP_high, this_LFP];
        SU_high = [SU_high, this_SU];
                
    elseif  mean(avpuppret(b)) < 40
        this_WALK = (tsresam_encoder.Data((locs(b)-pre):(locs(b)+post)));
        this_PUP = (tsresam_pupil.Data((locs(b)-pre):(locs(b)+post)));
        this_WHISK = (tsresam_whisk.Data((locs(b)-pre):(locs(b)+post)));
        this_LFP = (tsresam_lfp.Data((locs(b)-pre):(locs(b)+post)));
        this_SU = (tsresam_SU.Data((locs(b)-pre):(locs(b)+post)));
        WALK_low = [WALK_low, this_WALK];
        PUP_low = [PUP_low, this_PUP];
        WHISK_low = [WHISK_low, this_WHISK];
        LFP_low = [LFP_low, this_LFP];
        SU_low = [SU_low, this_SU];        
        
    else 
        this_WALK = (tsresam_encoder.Data((locs(b)-pre):(locs(b)+post)));
        this_PUP = (tsresam_pupil.Data((locs(b)-pre):(locs(b)+post)));
        this_WHISK = (tsresam_whisk.Data((locs(b)-pre):(locs(b)+post)));
        this_LFP = (tsresam_lfp.Data((locs(b)-pre):(locs(b)+post)));
        this_SU = (tsresam_SU.Data((locs(b)-pre):(locs(b)+post)));
        WALK_int = [WALK_int, this_WALK];
        PUP_int = [PUP_int, this_PUP];
        WHISK_int = [WHISK_int, this_WHISK]; 
        LFP_int = [LFP_int, this_LFP];
        SU_int = [SU_int, this_SU];       
    end
end

%-----Calculate percent changes in pupil size
prompt = {'Enter length of time to be used for max pupil calculation.'};
t = 'Input';
dims = [1 25];
definput = {'5'};
MAXlength = inputdlg(prompt,t,dims,definput);
tt = str2num(MAXlength{1,1});

prestim_pupav_high = [];
stim_pupmax_high = [];
PCP_high = [];
prestim_pupav_low = [];
stim_pupmax_low = [];
PCP_low = [];
prestim_pupav_int = [];
stim_pupmax_int = [];
PCP_int = [];

newavpup = [];
for s = 1:length(pks)
     newavpup(:,s) = mean(tsresam_pupil.data((locs(s)-5000):locs(s)));
end



for u = 1:length(newavpup)
    if newavpup(u) > 70
        prestim_pupav_high(1,u) = mean(tsresam_pupil.Data((locs(u)-pre:(locs(u)))));
        stim_pupmax_high(1,u) = max(tsresam_pupil.Data((locs(u):(locs(u)+(tt*Resamp_r)))));
        PCP_high(1,u) = ((stim_pupmax_high(u) - prestim_pupav_high(u))./(prestim_pupav_high(u)))*100;
   
    elseif newavpup(u) < 40
        prestim_pupav_low(1,u) = mean(tsresam_pupil.Data((locs(u)-pre:(locs(u)))));
        stim_pupmax_low(1,u) = max(tsresam_pupil.Data((locs(u):(locs(u)+(tt*Resamp_r)))));
        PCP_low(1,u) = ((stim_pupmax_low(u) - prestim_pupav_low(u))./(prestim_pupav_low(u)))*100;
    else 
        prestim_pupav_int(1,u) = mean(tsresam_pupil.Data((locs(u)-pre:(locs(u)))));
        stim_pupmax_int(1,u) = max(tsresam_pupil.Data((locs(u):(locs(u)+(tt*Resamp_r)))));
        PCP_int(1,u) = ((stim_pupmax_int(u) - prestim_pupav_int(u))./(prestim_pupav_int(u)))*100;  
        
    end
end
PCP_high = PCP_high(PCP_high ~= 0);
PCP_int = PCP_int(PCP_int ~= 0);
PCP_low = PCP_low(PCP_low ~= 0);       

mean_PCP = [mean(PCP_low),mean(PCP_int),mean(PCP_high)];
std_PCP = [std(PCP_low),std(PCP_int),std(PCP_high)];
figure ('Name', 'Percent Pupil Change Bar')
hold on
bar(1:3,mean_PCP)
errorbar(1:3,mean_PCP,std_PCP,'.')
str = {'Low'; 'Intermediate'; 'High'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
hold off

for u = 1:length(newavpup)
    prestim_pupav(1,u) = mean(tsresam_pupil.Data((locs(u)-pre:(locs(u)))));
    stim_pupmax(1,u) = max(tsresam_pupil.Data((locs(u):(locs(u)+(tt*Resamp_r)))));
    PCP(1,u) = ((stim_pupmax(u) - prestim_pupav(u))./(prestim_pupav(u)))*100;
end



% % % % %transpose variables for stdshade
avpupt = avpup';
avpuppret = avpuppre';
avencodert = avencoder';
avwhiskt = avwhisk';
avlfpt = avlfp';
avSUt = avSU';
%transpose for graphs
WALK_Sigt =WALK_Sig';
WALK_NonSigt =WALK_NonSig';
PUP_Sigt = PUP_Sig';
PUP_NonSigt = PUP_NonSig';
WHISK_Sigt = WHISK_Sig';
WHISK_NonSigt = WHISK_NonSig';
LFP_Sigt = LFP_Sig';
LFP_NonSigt = LFP_NonSig';
SU_Sigt = SU_Sig';
SU_NonSigt = SU_NonSig';


figure ('Name','Averaged Arousal Measures')
subplot(3,1,1)
plot(avpup,'k')
title('All Pupil')
subplot(3,1,2)
plot(avencoder,'r')
title('All Walk')
subplot(3,1,3)
plot(avwhisk,'b')
title('All Whisk')


numwalk = size(WALK_Sig);
numwalk = numwalk(1,2);
numstat = size(WALK_NonSig);
numstat = numstat(1,2);
% 
if numwalk > 0
    figure ('Name','Walking Arousal Measures')
    subplot(3,1,1)
    plot(WALK_Sig,'k')
    title('Walking Walk')
    subplot(3,1,2)
    plot(PUP_Sig,'r')
    title('Walking Pupil')
    subplot(3,1,3)
    plot(WHISK_Sig,'b')
    title('Walking Whisk')
else
    disp('No stimulations during walking.')
end
if numstat > 0
    figure ('Name','Stationary Arousal Measures')
    subplot(3,1,1)
    plot(WALK_NonSig,'k')
    title('Stationary Walk')
    subplot(3,1,2)
    plot(PUP_NonSig,'r')
    title('Stationary Pupil')
    subplot(3,1,3)
    plot(WHISK_NonSig,'b')
    title('Stationary Whisk')
else
    disp('No stimulations without walking.')
end


numhigh = size(WALK_high);
numhigh = numhigh(1,2);
numint = size(WALK_int);
numint = numint(1,2);
numlow = size(WALK_low);
numlow = numlow(1,2);

if numhigh > 0 
    figure ('Name','High Arousal Behavior')
    subplot(3,1,1)
    plot(WALK_high,'k')
    title('High Arousal Walk')
    subplot(3,1,2)
    plot(PUP_high,'r')
    title('High Arousal Pupil')
    subplot(3,1,3)
    plot(WHISK_high,'b')
    title('High Arousal Whisk')
else
    disp('No stimulations during high arousal.')
end

if numint > 0
    figure ('Name','Intermediate Arousal Behavior')
    subplot(3,1,1)
    plot(WALK_int,'k')
    title('Intermediate Arousal Walk')
    subplot(3,1,2)
    plot(PUP_int,'r')
    title('Intermediate Arousal Pupil')
    subplot(3,1,3)
    plot(WHISK_int,'b')
    title('Intermediate Arousal Whisk')
else
    disp('No stimulations during intermediate arousal.')
end

if numlow > 0
    figure ('Name','Low Arousal Behavior')
    subplot(3,1,1)
    plot(WALK_low,'k')
    title('Low Arousal Walk')
    subplot(3,1,2)
    plot(PUP_low,'r')
    title('Low Arousal Pupil')
    subplot(3,1,3)
    plot(WHISK_low,'b')
    title('Low Arousal Whisk')
else
    disp('No stimulations during low arousal.')
end

figure ('Name','Percent Pupil Change Scatter')
scatter(prestim_pupav,PCP,'.b'); 
p = polyfit(prestim_pupav,PCP,1);
f = polyval(p,prestim_pupav);
hold on
plot(prestim_pupav,f,'--r')



end

