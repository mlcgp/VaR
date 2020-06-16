[num] = xlsread('Adj_Close.xlsx','Sheet1', 'B2:E502');
[txt] = xlsread('Adj_Close.xlsx','Sheet1','A3:A502');
t = datetime(txt,'ConvertFrom','excel','format','yyyy/MM/dd');

P = 1000000;
w1 = 0.153339.*P; w2 = 0.637413.*P; w3 = 0.089923.*P; w4 = 0.119325.*P; % weights

r1 = diff(log(num(:,1))); %log return of 1060.HK
r2 = diff(log(num(:,2))); %log return of 1109.HK
r3 = diff(log(num(:,3))); %log return of 3883.HK
r4 = diff(log(num(:,4))); %log return of 3968.HK

cweights_row = [w1 w2 w3 w4];
weights_column = [w1 w2 w3 w4]';
r = [r1 r2 r3 r4];
lambda = 0.94;
cov_matrix = var_cov(r,lambda);

P_var = (weights_row*cov_matrix)*weights_column;
P_sd = ((P_var)^0.5)*sqrt(500);

VaR = (norminv(0.99) * P_sd);
ES = P_sd * ((exp(1) ^ -((norminv(0.99) ^ 2) / 2)) / ((sqrt(2*pi)) * (1 - 0.99)));

[VaR ES]


