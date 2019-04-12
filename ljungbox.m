function [lambda, acf] = ljungbox(data, h)
    % Assumes that data is mean centered
    gamma = 1:h+1;
    n = length(data);
   
    for i = 0:h
        gamma(i + 1) = data(1 + i:end)' * data(1:end - i) / n;
    end
    
    acf = gamma(2:end) / gamma(1);
    
    lambda = n * (n + 2) * sum(acf.^2 / (n - 1));
end