data = importdata('exchangerate.mat');
n_data = length(data);

% Problem 1
% mean correct all three series, i.e., subtract the sample mean from each series.
% Plot them. Which, if any, of them do you think can be modeled as a stationary time
% series? Motivate your answer. After this, you may assume that all three time series
% have mean zero.

x_t = data(1:end - 1);
x_t_1 = data(2:end);

abs_returns = x_t_1 - x_t;
log_returns = log(x_t_1) - log(x_t);

n_returns = length(abs_returns);

corrected_abs_returns = abs_returns - mean(abs_returns);
corrected_log_returns = log_returns - mean(log_returns);
corrected_data = data - mean(data);

figure;
% subplot(2,2,1);
plot(corrected_data);
ylabel("Australian Trade Weighted Index");
xlabel("Months after Jan 1978");
title("Monthly observations of the Australian Trade Weighted Index");
saveas(gcf,'plots/exchangedata.png');
figure;
% subplot(2,2,2);
plot(corrected_abs_returns);
xlabel("Months after Jan 1978");
ylabel("Absolute returns");
title("Absolute returns");
saveas(gcf,'plots/abs_returns.png');
figure;
% subplot(2,2,3);
plot(corrected_log_returns);
xlabel("Months after Jan 1978");
ylabel("Log returns");
title("Log Returns");
saveas(gcf,'plots/log_returns.png');

% Problem 2
crit_val = chi2inv(0.95, 20);
[lambda_data, acf_data] = ljungbox(corrected_data, 20);
[lambda_abs, acf_abs] = ljungbox(corrected_abs_returns, 20);
[lambda_log, acf_log] = ljungbox(corrected_log_returns, 20);

% Hypothesis test
chi2cdf(lambda_data, 20, 'upper');
chi2cdf(lambda_abs, 20, 'upper');
chi2cdf(lambda_log, 20, 'upper');

% IID should be 0 covariance
figure;
%subplot(2,2,1);
stem(acf_data, 'filled');
%Draw +- 1.96 / sqrt(n) lines

yline(-1.96 / sqrt(n_data), '--', '-1.96/sqrt(n)');

yline(1.96 / sqrt(n_data), '--');
yline(-1.96 / sqrt(n_data), '--');
title("ACF for original data");
ylabel("Correlation");
xlabel("h");
axis([1 20 -1 1]);
saveas(gcf,'plots/acf_exchange.png');

figure;
%subplot(2,2,2);
stem(acf_abs, 'filled');
% Draw +- 1.96 / sqrt(n) lines
yline(1.96 / sqrt(n_returns), '--');
yline(-1.96 / sqrt(n_returns), '--');
title("ACF for absolute returns");
ylabel("Correlation");
xlabel("h");
axis([1 20 -1 1]);
saveas(gcf,'plots/acf_abs_returns.png');

%subplot(2,2,3);
figure;
stem(acf_log, 'filled');
% Draw +- 1.96 / sqrt(n) lines
yline(1.96 / sqrt(n_returns), '--');
yline(-1.96 / sqrt(n_returns), '--');
title("ACF for log returns");
ylabel("Correlation");
xlabel("h");
axis([1 20 -1 1]);
saveas(gcf,'plots/acf_log_returns.png');

% Problem 3
training = corrected_log_returns(1:102);
test = corrected_log_returns(103:end);
[gm, train_gamma_mat, train_acf] = acvf(training, 20);

% First coefficient, a_0 is zero since mean is zero.
coefs = train_gamma_mat \ flip(gm(2:end)');

preds = zeros(n_returns, 1);
preds(1:102) = training;
for i = 103:n_returns
    preds(i) = preds(i-1:-1:i-20)' * coefs;    
end

% Print out the coefficients nicely for latex
coef_format = arrayfun(@(x) sprintf("%.3f", x), coefs);
zs_format = arrayfun(@(x) sprintf("z_{n-%d}",x), 1:20);
% {' + '}, 
blp_format = strcat(coef_format', zs_format);
% add plus between coefficients
blp_format = strjoin(blp_format, ' + ');

% Plot the predictions (red) and the actual values (black)
figure;
preds_plot = plot(103:n_returns, preds(103:n_returns), '-o');
preds_plot.Color = "red";
hold on;
actual_plot = plot(103:n_returns, test, '-o');
actual_plot.Color = "black";
title("Log Returns Predictions and actual values");
ylabel("Log Returns");
legend("Predictions", "Actual");
saveas(gcf,'plots/log_returns_preds.png');

% Plot the residuals
% figure;
% stem(103:n_returns, preds(103:n_returns) - test, 'filled');
% title("Predicted - Actual (Residuals)");

% mean squared error
forecast_mse = mean((preds(103:n_returns) - test).^2);
mean_mse = mean(test.^2);

% Not much difference in the forecasted MSE and the naive mean prediction
% Since log returns look IID it makes sense that mean prediction is almost
% as good

% Problem 4
% qqplot(corrected_log_returns);
% Standardized log return (divided off standard deviation)
log_returns_std = sort(corrected_log_returns / std(corrected_log_returns));
% Generate samples from normal distribution
norm_sample = sort(normrnd(0, 1, [1,n_returns]));

% Plot QQ-plot
figure;
scatter(norm_sample, log_returns_std);
hold on;
refline(1,0);
title("QQ plot");
ylabel("Standardize Log Returns Quantiles");
xlabel("Normal Quantiles");
saveas(gcf,'plots/qqplot.png');

% Test of Normality by Kolmogorov Smirnov Test:
% h = kstest(x) returns a test decision for the null hypothesis that the
% data in vector x comes from a standard normal distribution, against 
% the alternative that it does not come from such a distribution, using
% the one-sample Kolmogorov-Smirnov test. The result h is 1 if the test
% rejects the null hypothesis at the 5 significance level, or 0 otherwise.
h = kstest(corrected_log_returns)


% Second part, repeat problem 2 but for |Z|
log_abs_returns = abs(log(x_t_1) - log(x_t));
log_abs_returns = log_abs_returns - mean(log_abs_returns);
[lambda_log_abs, ~] = ljungbox(log_abs_returns, 20);
log_abs_pval = chi2cdf(lambda_log_abs, 20, 'upper');