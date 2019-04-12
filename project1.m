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
title("Exchange data");
plot(corrected_data);
subplot(2,2,2);
title("Absolute returns");
plot(corrected_abs_returns);
subplot(2,2,3);
title("Log Returns");
plot(corrected_log_returns);

% Problem 2
crit_val = chi2inv(0.95, 20);
[lambda_data, acf_data] = ljungbox(corrected_data, 20);
[lambda_abs, acf_abs] = ljungbox(corrected_abs_returns, 20);
[lambda_log, acf_log] = ljungbox(corrected_log_returns, 20);

% Hypothesis test
lambda_data > crit_val
lambda_abs > crit_val
lambda_log > crit_val

% TODO: Plot on same scale
% IID should be 0 covariance
figure;
subplot(2,2,1);
plot(acf_data);
subplot(2,2,2);
plot(acf_abs);
subplot(2,2,3);
plot(acf_log);




