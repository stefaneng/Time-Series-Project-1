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
ljungbox(corrected_data,20);

