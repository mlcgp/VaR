[num] = xlsread('Adj_Close.xlsx','Sheet1', 'B4:E502');
[txt] = xlsread('Adj_Close.xlsx','Sheet1','A4:A502');
t = datetime(txt,'ConvertFrom','excel','format','yyyy/MM/dd');

r1 = diff(log(num(:,1))); %return of 1060.HK
r2 = diff(log(num(:,2))); %return of 1109.HK
r3 = diff(log(num(:,3))); %return of 3883.HK
r4 = diff(log(num(:,4))); %return of 3968.HK

r = [r1 r2 r3 r4];
lambda = 0.94;
cov_matrix = var_cov(r,lambda);

n = 10000;
dx = randn(n,1);

% generate random samples of mean asset returns
r1mean = mean(r1);
r1std = std(r1);
r1p = r1mean + r1std.*dx;

r2mean = mean(r2);
r2std = std(r2);
r2p = r2mean + r1std.*dx;

r3mean = mean(r3);
r3std = std(r3);
r3p = r3mean + r3std.*dx;

r4mean = mean(r4);
r4std = std(r4);
r4p = r4mean + r4std.*dx;

pmean = [r1p r2p r3p r4p];
dp = zeros(n,1);
for i = 1:n
    dp(i,1) = mean(pmean(i,:)); % generates probability distribution of portfolio means
end

outcomes = zeros(n,6); % to store results of the portfolio optimizer

% Optimization of portfolio through iterations of random possible means
for j = 1:n
    % correct dp for the mean of the portfolio
    fun = @(x) x * cov_matrix * x';
    x0 = [0.25, 0.25, 0.25, 0.25];
    A = [];
    B = [];
    Aeq = [1, 1, 1, 1; pmean(j,:)];
    beq = [1; dp(j,1)];
    lb = [0, 0, 0, 0];
    ub = []; % constrain each asset to only allow to take up 40% of the portfolio
    % Store each outcome of the porfolio in a matrix
    meanP = dp(j,1);
    stdP = (varP)^0.5;
    outcomes(j,:) = [weights, stdP, meanP];
end

% find the desired maximum risk/return tradeoff
risk_return = outcomes(:,6)./outcomes(:,5);
results = [outcomes, risk_return];
ranked_return_results = sortrows(results,6,'descend'); % rank results from greatest to least in terms of return
ranked_std_results = sortrows(results,5,'ascend'); % rank results from least to greatest in terms of std dev
maxmeanP = ranked_return_results(1,:);
minstd = ranked_std_results(1,:);