%% for pupil change state dep. bar graph

base_peak = [meanbasepup;peakpup];

bins = [20 30 40 50 60 70 80 90 100 120];

for o = 1:length(base_peak)-1
for i = 1:length(bins)
    if base_peak(1,o) > bins(i) & base_peak(1,o) < bins(i+1)
    base_peak_bin(:,o,i) = base_peak(:,o);
    else base_peak_bin(:,o,i) = NaN;
    end
end
end

base_peak_bin(base_peak_bin == 0) = NaN;

figure;hold on;
for i = 1:size(base_peak_bin,3);
    stdshade(base_peak_bin(:,:,i)')
end

 y = ones(281,1); z = y+1;
scatter(y,base_peak(1,:))
scatter(z,base_peak(2,:))

