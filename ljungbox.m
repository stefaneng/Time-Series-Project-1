function [lambda, acf] = ljungbox(data, h)
  % Compute the Ljung-Box test statistic
    [~, ~, acf] = acvf(data, h);
    n = length(data);

    acf_vals = acf(2:end);
    lambda = n * (n + 2) * (acf_vals * acf_vals') / (n - 1);
end
