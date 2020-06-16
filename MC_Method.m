[num] = xlsread('Adj_Close','Sheet1', 'B2:E502');
[txt] = xlsread('Adj_Close.xlsx','Sheet1','A3:A502');
t = datetime(txt,'ConvertFrom','excel','format','yyyy/MM/dd');


P = 1000000;
w1 = 0.153339 ; w2 = 0.637413 ; w3 = 0.089923 ; w4 = 0.119325 ;
r1 = diff(log(num(:,1))) * P*w1; %return of 1060.HK
r2 = diff(log(num(:,2))) * P*w2; %return of 1109.HK
r3 = diff(log(num(:,3))) * P*w3; %return of 3883.HK
r4 = diff(log(num(:,4))) * P*w4; %return of 3968.HK

totalReturn = [r1 + r2 + r3 + r4];

% Ranking Loss
N = size(totalReturn,1);
I = 1000000;
flag = [1:500]'; X = 0.99; cr_X = floor((N-1)*(1-X));
loss = I - totalReturn; A = [flag, loss];

N_MC = 1000000; 
plmean = mean(loss,1); 
plstd = std(loss,0,1);
dx = randn(N_MC,1);
dp = plmean + plstd*dx;

n = floor((1-X)*N_MC);
ranked_dp = sort(dp,'descend');
VaR_MC = ranked_dp(n,1);
ES_MC = mean(ranked_dp(1:n,1),1);

[VaR_MC, ES_MC]

histogram(loss,50,'Normalization','pdf'); hold on;

