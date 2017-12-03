function [X_norm, mu, sigma] = featureNormalize(X)


mu = mean(X);
sigma = std(X);

for i = 1:size(X, 1),
    for j = 1:size(X, 2),
        X_norm(i, j) = (X(i, j) - mu(j)) / sigma(j);
    end
end


end
