data = importdata('exchangerate.mat');
n_data = length(data);

% Problem 1
x_t = data(1:end - 1);
x_t_1 = data(2:end);

abs_returns = x_t_1 - x_t;
log_returns = log(x_t_1) - log(x_t);
n_returns = length(abs_returns);

corr_abs_returns = abs_returns - mean(abs_returns);
corr_log_returns = log_returns - mean(log_returns);

figure;
subplot(1,2,1);
plot(corr_abs_returns);
subplot(1,2,2);
plot(corr_log_returns);

% Problem 2
% Incorrect, TODO
h = 20;
gamma0 = (data - mean(data))' * (data - mean(data)) / n_data;
gamma20 = data(1 + h:end) - mean(data)' * (data(1:end - h) - mean(data)) / n_data;
acf = gamma20 / gamma0;


