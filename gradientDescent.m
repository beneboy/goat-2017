function theta = gradientDescent(X, y, theta, alpha, num_iters)

m = length(y);
%J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    H = X * theta;
    cost_sum = [0; 0];

    for i = 1:m
        cost_sum  = cost_sum + (H(i) - y(i)) * X(i,:)';
    end

    theta = theta - alpha * cost_sum / m;

%    J_history(iter) = computeCost(X, y, theta);

end

end
