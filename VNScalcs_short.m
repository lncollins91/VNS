function [avpup,avencoder,avwhisk,avlfp,avSU,avstim,time] = VNScalcs_short(pre,post,pks,locs,tsresam_pupil,tsresam_encoder,tsresam_whisk,tsresam_lfp,tsresam_SU,tsresam_stim,Resamp_r)
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
avstim=zeros(pre+post+1,length(pks));
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
       avlfp(:,k)=tsresam_lfp.data(locs(k)-pre:locs(k)+post); %lfp at each stim
    %SU
       avSU(:,k)=tsresam_SU.data(locs(k)-pre:locs(k)+post); %SU at each stim
    %Stim
       avstim(:,k)=tsresam_stim.data(locs(k)-pre:locs(k)+post); %Stim at each stim       
end

%make timebase for graphs
pup_t=tsresam_pupil.time(locs(1)-pre:locs(1)+post);
time=(linspace(0,(max(pup_t)-min(pup_t)),pre+post+1))';



end

