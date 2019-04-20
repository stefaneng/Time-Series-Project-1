function [gm, gamma_mat, acf] = acvf(data, h)
    % gamma_mat is sample covariance matrix
    % gm is the gamma values
    gm = zeros(1,h+1);
    n = length(data);
    mx = mean(data);

    for i = 0:h
        gm(i + 1) = (data(1 + i:end) - mx)' * (data(1:end - i) - mx) / n;
    end

    gamma_mat = zeros(h, h);
    for i = 1:h
        for j = i:h
           res = gm((j - i) + 1);
           gamma_mat(i,j) = res;
           gamma_mat(j,i) = res;
        end
    end

    acf = gm / gm(1);
end
