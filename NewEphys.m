%% new ephys figure

prebase_walking = mean(avspikerate_walking(260:300));
prebase_walking_sem = std(avspikerate_walking(260:300))/sqrt(length(avspikerate_walking(260:300)));

norm_walking = (avspikerate_walking-prebase_walking)/prebase_walking;
figure; bar(norm_walking(1,260:440))
figure; envelope(norm_walking(1,260:500),1,'peak');ylim([-0.4 1.6])


prebase_stationary = mean(avspikerate_stationary(260:300));
prebase_stationary_sem = std(avspikerate_stationary(260:300))/sqrt(length(avspikerate_stationary(260:300)));

norm_stationary = (avspikerate_stationary-prebase_stationary)/prebase_stationary;
figure; bar(norm_stationary(1,260:440));ylim([-0.4 1.6])
figure; envelope(norm_stationary(1,220:440),1,'peak');ylim([-0.4 1.6])

[h,p,ci,stats] = ttest(avspikerate_walking(260:300),avspikerate_stationary(260:300));


walk1 = norm_walking(1,280:300);
walk2 = norm_walking(1,300:320);
walk3 = norm_walking(1,320:340);
walk4 = norm_walking(1,400:420);

stat1 = norm_stationary(1,280:300);
stat2 = norm_stationary(1,300:320);
stat3 = norm_stationary(1,320:340);
stat4 = norm_stationary(1,400:420);

figure; bar([mean(walk1) mean(walk2) mean(walk3) mean(walk4)])
hold on;errorbar([mean(walk1) mean(walk2) mean(walk3) mean(walk4)],[std(walk1)/sqrt(length(walk1)) std(walk2)/sqrt(length(walk2)) std(walk3)/sqrt(length(walk3)) std(walk4)/sqrt(length(walk4))]);

figure; bar([mean(stat1) mean(stat2) mean(stat3) mean(stat4)])
hold on;errorbar([mean(stat1) mean(stat2) mean(stat3) mean(stat4)], std(stat2)/sqrt(length(stat2)) std(stat3)/sqrt(length(stat3)) std(stat4)/sqrt(length(stat4))]);

%  sig testing

[walkp,walktbl,walkstats] = anova1([walk1; walk2; walk3; walk4]');
[statp,stattbl,statstats] = anova1([stat1; stat2; stat3 ;stat4]');
mcwalk = multcompare(walkstats);
mcstat=multcompare(statstats);