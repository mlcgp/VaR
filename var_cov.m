function [ var_cov ] = var_cov(r, lambda)
    [N, n] = size(r);
    var_cov_sample = cov(r); mean_sample = mean(r,1);
    var_mat = zeros(N+1,n);
    cov_mat = zeros(N+1,n*(n-1)/2);

    var_mat(1,:) = diag(var_cov_sample)';
    cov_mat(1,:) = var_cov_sample(tril(ones(n,n),-1)==1)';

    idx = repmat([1:n]',1,n); idy = repmat([1:n],n,1);
    cov_idx = [idx(tril(ones(n,n),-1)==1), idy(tril(ones(n,n),-1)==1)];

    temp = zeros(N,n);

    for i = 1:n*(n-1)/2
        temp(:,i) = r(:,cov_idx(i,1)).*r(:,cov_idx(i,2)) - mean_sample(1,cov_idx(i,1))*mean_sample(1,cov_idx(i,2));
    end

    for i = 2:N+1
        var_mat(i,:) = var_mat(i-1,:)*lambda + r(i-1,:).^2*(1-lambda);
        cov_mat(i,:) = cov_mat(i-1,:)*lambda + temp(i-1,:)*(1-lambda);
    end

    var_cov = zeros(n,n);
    var_cov(tril(ones(n,n),-1)==1) = cov_mat(end,:);
    var_cov = var_cov + var_cov';
    var_cov(eye(n)==1) = var_mat(end,:);

end