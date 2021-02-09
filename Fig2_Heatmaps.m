%for concatenating heatmap clipped files from
%VNS4_heatmap_clip_denniswalkwhiskclip.m

[file,path]= uigetfile('MultiSelect','on');
cd(path);

%preallocate variables
    concat_still=[];
%    concat_twitch=[];
   concat_walk=[];
   concat_whisk=[];
%    concat_shortwalk=[];
    
     concat_pre_still=[];
% %    concat_pre_twitch=[];
    concat_pre_walk=[];
    concat_pre_whisk=[];
% %    concat_pre_shortwalk=[];
    
    %load in and concatentate files
tic
for i=3:length(file)
    load(file{i})
    
    concat_still=cat(3,concat_still, clip_still);
%    concat_twitch=cat(3,concat_twitch, clip_twitch);
    concat_walk=cat(3,concat_walk, clip_walk);
    concat_whisk=cat(3,concat_whisk, clip_whisk);
%    concat_shortwalk=cat(3,concat_shortwalk, clip_shortwalk);
    
    concat_pre_still=cat(3,concat_pre_still, preclip_still);
%    concat_pre_twitch=cat(3,concat_pre_twitch, preclip_twitch);
    concat_pre_walk=cat(3,concat_pre_walk, preclip_walk);
    concat_pre_whisk=cat(3,concat_pre_whisk, preclip_whisk);
%    concat_pre_shortwalk=cat(3,concat_pre_shortwalk, preclip_shortwalk);
    
   % clearvars clip_still clip_twitch clip_walk clip_whisk clip_shortwalk preclip_still ...
       % preclip_twitch preclip_walk preclip_whisk preclip_shortwalk
    
     clearvars clip_still preclip_still clip_walk clip_whisk  ...
        preclip_walk preclip_whisk 
    i
end
    toc
    
    
    %%
    load('allenDorsalMap.mat');    
close all
axmin = 0;
axmax=0.10;
   
figure('Name','Whisk Only')
% subplot(1,2,1)
% stim_clip_mean1=mean(concat_pre_whisk,3);
% imshow(stim_clip_mean1,[0 max(stim_clip_mean1(:))]), colorbar
% colormap(gca,parula) 
% caxis([axmin axmax]) 
%     hold on
%     for p=1:length(dorsalMaps.edgeOutline)
%         plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
%     end  
%     hold off
subplot(1,2,2)
stim_clip_mean=mean(concat_whisk,3);
imshow(stim_clip_mean,[0 max(stim_clip_mean(:))]), colorbar
colormap(gca,jet)
caxis([axmin axmax]) 
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end  
    hold off

figure('Name','Walk Only')
% subplot(1,2,1)
% stim_clip_mean=mean(concat_pre_walk,3);
% imshow(stim_clip_mean,[0 max(stim_clip_mean(:))]), colorbar
% colormap(gca,parula) 
% caxis([axmin axmax]) 
%     hold on
%     for p=1:length(dorsalMaps.edgeOutline)
%         plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
%     end  
%     hold off
subplot(1,2,2)
stim_clip_mean=mean(concat_walk,3);
imshow(stim_clip_mean,[0 max(stim_clip_mean(:))]), colorbar
colormap(gca,jet)
caxis([axmin axmax]) 
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end  
    hold off

figure('Name','Still Only')
subplot(1,2,1)
stim_clip_mean=mean(concat_pre_still,3);
imshow(stim_clip_mean,[0 max(stim_clip_mean(:))]), colorbar
colormap(gca,jet) 
caxis([axmin axmax]) 
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end  
    hold off
subplot(1,2,2)
stim_clip_mean=mean(concat_still,3);
imshow(stim_clip_mean,[0 max(stim_clip_mean(:))]), colorbar
colormap(gca,jet) 
caxis([axmin axmax]) 
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end  
    hold off
%%
close all
axmin = 0;
axmax=0.035;

    clipsub= concat_still - mean(concat_pre_still,3);
   
figure('Name','Still Subtract Only')
    subplot(1,2,2)
stim_clip_mean=mean(clipsub,3);
imshow(stim_clip_mean,[0 max(stim_clip_mean(:))]), colorbar
colormap(gca,jet) 
caxis([axmin axmax]) 
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end  
    hold off
    
    
       clipsub= concat_whisk - mean(concat_pre_whisk,3);
figure('Name','Whisk Subtract Only')
    subplot(1,2,2)
stim_clip_mean=mean(clipsub,3);
imshow(stim_clip_mean,[0 max(stim_clip_mean(:))]), colorbar
colormap(gca,jet) 
caxis([axmin axmax]) 
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end  
    hold off 
    
           clipsub= concat_walk - mean(concat_pre_walk,3);
figure('Name','Walk Subtract Only')
    subplot(1,2,2)
stim_clip_mean=mean(clipsub,3);
imshow(stim_clip_mean,[0 max(stim_clip_mean(:))]), colorbar
colormap(gca,jet) 
caxis([axmin axmax]) 
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end  
    hold off 


    
    
    