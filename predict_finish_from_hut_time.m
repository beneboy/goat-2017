% Use machine learning to predict this year's finis from time to hut

data = csvread("goat2017.csv")(2:end,:);
finish_only_data = data(data(:,9) != 0, :);

times_to_hut = finish_only_data(:,7);
times_to_end = finish_only_data(:,9);

m = length(times_to_hut);

[X mu sigma] = featureNormalize(times_to_hut);

training_data = [ones(m, 1), X];
theta = zeros(2, 1);

% for gradient descent
iterations = 1500;
alpha = 0.01;

theta = gradientDescent(training_data, times_to_end, theta, alpha, iterations);

test_data = [13592, 18314; 5884, 8306; 12444, 16741; 9602, 13393];

for test_data_index = 1:size(test_data)(1)
    td_item = test_data(test_data_index, 1);
    real = test_data(test_data_index, 2);
    n_test_data = (td_item - mu) / sigma;

    predict = [1, n_test_data] * theta;

    fprintf("Expected finish time for %d: %f (actual %d, diff %f)\n", td_item, predict, real, real-predict);
end



figure(3);
hold on;
plot(times_to_hut, finish_only_data(:,9), 'rx', 'MarkerSize', 10);
ylabel('Time to Finish');
xlabel('Time to Hut');
plot(times_to_hut, training_data*theta, '-')
legend('Training data', 'Linear regression')
print("TimeToHutVsFinish.png");
hold off;

