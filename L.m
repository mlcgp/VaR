[num] = xlsread('Adj_Close.xlsx','Sheet1', 'B2:E502');
[txt] = xlsread('Adj_Close.xlsx','Sheet1','A3:A502');
t = datetime(txt,'ConvertFrom','excel','format','yyyy/MM/dd');

r1 = diff(log(num(:,1))); %return of 1060.HK
r2 = diff(log(num(:,2))); %return of 1109.HK
r3 = diff(log(num(:,3))); %return of 3883.HK
r4 = diff(log(num(:,4))); %return of 3968.HK

P = 1000000;
w1 = 0.153339.*P; w2 = 0.637413.*P; w3 = 0.089923.*P; w4 = 0.119325.*P; % weights

% EWMA variance and sd of portfolio at t = 15
weights_row = [w1 w2 w3 w4];
weights_column = [w1 w2 w3 w4]';
r = [r1 r2 r3 r4];
lambda = 0.94;
cov_matrix = var_cov(r,lambda);

P_var = (weights_row*cov_matrix)*weights_column;
P_sd = (P_var)^0.5;

% Asset components of L 
x1 = ((w1.*sum(r1)) - 0.5.*((0.7.*P_sd).^2));
x2 = ((w2.*sum(r2)) - 0.5.*((0.7.*P_sd).^2));
x3 = ((w3.*sum(r3)) - 0.5.*((0.7.*P_sd).^2));
x4 = ((w4.*sum(r4)) - 0.5.*((0.7.*P_sd).^2));

% 15-day VaR and ES
VaR = 1042425.35936  .* (16)^0.5;
ES = 1048861.38826 .* (16)^0.5;

% L
total_assets = [x1 x2 x3 x4];
L_function = ((1./31).*(x1 + x2 + x3 + x4))-1/P.*((0.1.*VaR)+(0.2.*ES));

[L_function]

rr1 = w1.*(r1); rr2 = w2.*(r2); rr3 = w3.*(r3); rr4 = w4.*(r4);
P_r = rr1 + rr2 + rr3 + rr4;
plot(t,P_r, '-r','Linewidth',1); hold on;
ytickformat('jpy');
legend('portfolioReturn');
xlabel('Date'); ylabel('Value');
