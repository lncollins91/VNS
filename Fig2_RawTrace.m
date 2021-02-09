WFtsre_encoder.data=abs(WFtsre_encoder.data);

%%
WFtsre_Pupil.data=smooth(WFtsre_Pupil.data,2000);
WFtsre_whisk.data=smooth(WFtsre_whisk.data,2000);
WFtsre_encoder.data=smooth(WFtsre_encoder.data,1000);

%%
figure(1);
set(gcf,'color','w');
set(gcf,'Position',[100 100 800 800]) 
subplot(5,1,1)
plot(WFtsre_Pupil)
xlim([550 780])
ylim([30 100])
title('Pupil')

subplot(5,1,2)
plot(WFtsre_whisk)
xlim([550 780])
ylim([-0.02 0.2])
title('Whisk')

subplot(5,1,3)
plot(WFtsre_encoder)
xlim([550 780])
ylim([-0.02 0.1])
title('Walk')

subplot(5,1,4)
plot(WFtsre_stim)
xlim([550 780])
title('Stim')

subplot(5,1,5)
plot(ts_WB_dff)
xlim([550 780])
title('Whole Brain dF/F')
