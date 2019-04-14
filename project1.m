data = importdata('exchangerate.mat');
n_data = length(data);

% Problem 1
x_t = data(1:end - 1);
x_t_1 = data(2:end);

abs_returns = x_t_1 - x_t;
log_returns = log(x_t_1) - log(x_t);

n_returns = length(abs_returns);

corrected_abs_returns = abs_returns - mean(abs_returns);
corrected_log_returns = log_returns - mean(log_returns);
corrected_data = data - mean(data);

figure;
subplot(2,2,1);
plot(corrected_data);
title("Exchange data");
subplot(2,2,2);
plot(corrected_abs_returns);
title("Absolute returns");
subplot(2,2,3);
plot(corrected_log_returns);
title("Log Returns");

% Problem 2
crit_val = chi2inv(0.95, 20);
[lambda_data, acf_data] = ljungbox(corrected_data, 20);
[lambda_abs, acf_abs] = ljungbox(corrected_abs_returns, 20);
[lambda_log, acf_log] = ljungbox(corrected_log_returns, 20);

% Hypothesis test
% TODO: Pvalues
% chi2cdf(lambda_log, 20, 'upper')
% Reject the null for the data
% Fail to reject for abs and log
chi2cdf(lambda_data, 20, 'upper');
chi2cdf(lambda_abs, 20, 'upper');
chi2cdf(lambda_log, 20, 'upper');

% IID should be 0 covariance
figure;
subplot(2,2,1);
stem(acf_data, 'filled');
% Draw +- 1.96 / sqrt(n) lines
yline(1.96 / sqrt(n_data), '--', '1.96/sqrt(n)');
yline(-1.96 / sqrt(n_data), '--', '-1.96/sqrt(n)');
title("ACF for original data");
axis([1 20 -1 1]);

subplot(2,2,2);
stem(acf_abs, 'filled');
% Draw +- 1.96 / sqrt(n) lines
yline(1.96 / sqrt(n_returns), '--', '1.96/sqrt(n)');
yline(-1.96 / sqrt(n_returns), '--', '-1.96/sqrt(n)');
title("ACF for absolute returns");
axis([1 20 -1 1]);

subplot(2,2,3);
stem(acf_log, 'filled');
% Draw +- 1.96 / sqrt(n) lines
yline(1.96 / sqrt(n_returns), '--', '1.96/sqrt(n)');
yline(-1.96 / sqrt(n_returns), '--', '-1.96/sqrt(n)');
title("ACF for log returns");
axis([1 20 -1 1]);

% Problem 3
training = corrected_log_returns(1:102);
test = corrected_log_returns(103:end);
[gm, train_gamma_mat, train_acf] = acvf(training, 20);

% First coefficient, a_0 is zero since mean is zero.
coefs = train_gamma_mat \ flip(gm(2:end)');

preds = zeros(n_returns, 1);
preds(1:102) = training;
for i = 103:n_returns
    preds(i) = dot(preds(i-1:-1:i-20), coefs);
end

% Plot the predictions (red) and the actual values (black)
figure;
preds_plot = plot(preds(103:n_returns), '-o');
preds_plot.Color = "red";
hold on;
actual_plot = plot(test, '-o');
actual_plot.Color = "black";
title("Predictions (red) and actual values (black)");

% Plot the residuals
figure;
stem(preds(103:n_returns) - test, 'filled');
title("Predicted - Actual (Residuals)");

% mean squared error
forecast_mse = mean((preds(103:n_returns) - test).^2);
mean_mse = mean(test.^2);

% Not much difference in the forecasted MSE and the naive mean prediction
% Since log returns look IID it makes sense that mean prediction is almost
% as good

% Problem 4
% qqplot(corrected_log_returns);
figure;
x = corrected_log_returns / std(corrected_log_returns);
cdfplot(x)
hold on;
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
legend('Empirical CDF','Standard Normal CDF','Location','best')

% Histogram fit of normal
histfit(x)


