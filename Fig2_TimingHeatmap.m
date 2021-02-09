   %% 
    load('allenDorsalMap.mat'); 
figure;
subplot(1,5,1)
imshow(mean(clip_10,3)-mean(concat_pre_walk,3),[0 max(clip_10(:))]), colorbar
colormap(gca,jet)
set(gcf,'Position',[100 600 2000 400])
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end

subplot(1,5,2)
imshow(mean(clip_20,3)-mean(concat_pre_walk,3),[0 max(clip_20(:))]), colorbar
colormap(gca,jet)
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end
    hold off

subplot(1,5,3)
imshow(mean(clip_30,3)-mean(concat_pre_walk,3),[0 max(clip_30(:))]), colorbar
colormap(gca,jet)
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end
    hold off

subplot(1,5,4)
imshow(mean(clip_40,3)-mean(concat_pre_walk,3),[0 max(clip_40(:))]), colorbar
colormap(gca,jet)
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end
    hold off
    
    subplot(1,5,5)
imshow(mean(clip_50,3)-mean(concat_pre_walk,3),[0 max(clip_50(:))]), colorbar
colormap(gca,jet)
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end
    hold off
%     
    

%%
    load('allenDorsalMap.mat'); 
figure;
subplot(1,5,1)
imshow(mean(stillclip_10,3)-mean(concat_pre_still,3),[0 max(clip_10(:))]), colorbar
colormap(gca,jet)
set(gcf,'Position',[100 600 2000 400])
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end

subplot(1,5,2)
imshow(mean(stillclip_20,3)-mean(concat_pre_still,3),[0 max(clip_20(:))]), colorbar
colormap(gca,jet)
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end
    hold off

subplot(1,5,3)
imshow(mean(stillclip_30,3)-mean(concat_pre_still,3),[0 max(clip_30(:))]), colorbar
colormap(gca,jet)
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end
    hold off

subplot(1,5,4)
imshow(mean(stillclip_40,3)-mean(concat_pre_still,3),[0 max(clip_40(:))]), colorbar
colormap(gca,jet)
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end
    hold off
    
    subplot(1,5,5)
imshow(mean(stillclip_50,3)-mean(concat_pre_still,3),[0 max(clip_50(:))]), colorbar
colormap(gca,jet)
caxis([0 0.06])
    hold on
    for p=1:length(dorsalMaps.edgeOutline)
        plot(dorsalMaps.edgeOutline{p}(:,2), dorsalMaps.edgeOutline{p}(:,1),'LineWidth',1.5);
    end
    hold off
%     
    
    
    