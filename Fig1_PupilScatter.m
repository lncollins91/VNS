for i =1:size(avpup100,2)
    baseline100(:,i)=nanmean(avpup100(1:40000,i));
    postpup100(:,i)=max(avpup100(40001:56000,i));
end
pupchange100=postpup100-baseline100;

for i =1:size(avpup400,2)
    baseline400(:,i)=nanmean(avpup400(1:40000,i));
    postpup400(:,i)=max(avpup400(40001:56000,i));
end
pupchange400=postpup400-baseline400;
%figure;
%scatter(baseline400,pupchange400);

for i =1:size(avpup800,2)
    baseline800(:,i)=nanmean(avpup800(1:40000,i));
    postpup800(:,i)=max(avpup800(40001:56000,i));
end

pupchange800=postpup800-baseline800;

for i =1:size(avpup1000,2)
    baseline1000(:,i)=nanmean(avpup1000(1:40000,i));
    postpup1000(:,i)=max(avpup800(40001:56000,i));
end
pupchange1000=postpup1000-baseline1000;

figure;
scatter(baseline1000,pupchange1000,'g');

hold on
scatter(baseline800,pupchange800,'k');
lsline

hold on
scatter(baseline400,pupchange400,'r');

hold on
scatter(baseline100,pupchange100);

xlabel('Baseline Pupil Diameter');
ylabel('Pupil Diameter Change after VNS')
ylim([-10 40])
