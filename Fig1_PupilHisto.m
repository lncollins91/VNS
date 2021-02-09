figure; 
histogram(avpup(1:40000,:),100) %5 seconds before stim
hold on
histogram(avpup(40001:80000,:),100)
xlabel('Baseline Pupil Diameter');
ylabel('Count')
%5 seconds after 1s stim

