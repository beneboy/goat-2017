% Analyse the waves to see if lower numbered waves finished faster

data = csvread("goat2017.csv")(2:end,:);
finish_only_data = data(data(:,9) != 0, :);

figure(2);
hold on;

wave_count = 12;
wave_bin_size = 12;

min_time = min(finish_only_data(:,9));
max_time = max(finish_only_data(:,9));

time_bins = [min_time:(max_time - min_time) / wave_bin_size:max_time];


for i = 0:2:wave_count-1
    wave_group_times = finish_only_data( finish_only_data(:,2) == i | finish_only_data(:,2) == (i+1), 9);

    binned_waves_group = zeros(1,length(time_bins));

    for j = 1:length(wave_group_times)
        for k = 1:length(time_bins)
            if wave_group_times(j) < time_bins(k);
                binned_waves_group(k) += 1;
                break;
            end
        end
    end

    plot(time_bins, binned_waves_group);
end
legend('1', '2', '3', '4', '5', '6')
title('Finish Time By Wave');
xlabel('Finish Time');
ylabel('Counts');
print("WaveFinishTimes.png");
hold off;

wave_group_averages = zeros(1, wave_count);

wave_names = {'1A'; '1B'; '2A'; '2B'; '3A'; '3B'; '4A'; '4B'; '5A'; '5B'; '6A'; '6B'};

for i = 0:wave_count-1
    wave_group_times = finish_only_data( finish_only_data(:,2) == i, :);
    wave_group_median = median(wave_group_times(:,9));
    wave_name = wave_names{i + 1};
    fprintf("Wave %s mean: %f (of %d entries)\n", wave_name, wave_group_median, length(wave_group_times));
    subsequent_faster = finish_only_data(finish_only_data(:,9) < wave_group_median & finish_only_data(:,2) > i);
    num_subsequent_faster = length(subsequent_faster);
    fprintf("Wave %s mean beaten by %d in later waves\n", wave_name, num_subsequent_faster);
end
