% Plot histograms for each gender

hist_bucket_size = 100;

data = csvread("goat2017.csv")(2:end,:);
finish_only_data = data(data(:,9) != 0, :);

gender = finish_only_data(:,5);
men = finish_only_data(logical(gender), :);
women = finish_only_data(!logical(gender), :);

hold on;
figure(1);
hist(men(:,9), hist_bucket_size, "facecolor", "b");
hist(women(:,9), hist_bucket_size, "facecolor", "r");

legend("Men", "Women");
title('Finish Time Gender Split');
xlabel('Finish Time');
ylabel('Counts');
print("GenderSplit.png");
hold off;
