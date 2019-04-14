function [lambda, acf] = ljungbox(data, h)
    gamma = acvf(data, h);
    n = length(data);
    
    acf = gamma(2:end) / gamma(1);
    
    lambda = n * (n + 2) * sum(acf.^2 / (n - 1));
end