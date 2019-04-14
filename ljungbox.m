function [lambda, acf] = ljungbox(data, h)
    [~, ~, acf] = acvf(data, h);
    n = length(data);
    
    lambda = n * (n + 2) * sum(acf.^2 / (n - 1));
end