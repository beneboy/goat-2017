% Use machine learning to predict this year's finish from previous year's time

data = csvread("goat2017.csv")(2:end,:);
previous_only_data = data(data(:,9) != 0 & data(:,6) != 0, :);

previous_finish_times = previous_only_data(:,6);
times_to_end = previous_only_data(:,9);

m = length(previous_finish_times);

[X mu sigma] = featureNormalize(previous_finish_times);

training_data = [ones(m, 1), X];
theta = zeros(2, 1);

% for gradient descent
iterations = 1500;
alpha = 0.01;

theta = gradientDescent(training_data, times_to_end, theta, alpha, iterations);

test_data = [5892, 8030; 10760, 14297; 9185, 12849; 8615, 11813];

for test_data_index = 1:size(test_data)(1)
    td_item = test_data(test_data_index, 1);
    real = test_data(test_data_index, 2);
    n_test_data = (td_item - mu) / sigma;

    predict = [1, n_test_data] * theta;

    fprintf("Expected finish time for %d: %f (actual %d, diff %f)\n", td_item, predict, real, real-predict);
end



figure(3);
hold on;
plot(previous_finish_times, previous_only_data(:,9), 'rx', 'MarkerSize', 10);
ylabel('Finish Time');
xlabel('Previous Finish Time');
plot(previous_finish_times, training_data*theta, '-')
legend('Training data', 'Linear regression')
print("PreviousTimeVsFinish.png");
hold off;

