[num] = xlsread('Adj_Close.xlsx','Sheet1', 'B2:E502');
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
ranked_A = -sortrows(-A,2);
ranked_loss = ranked_A(:,2);

% Determining u and nu
u = prctile(ranked_loss,95); % u = 
nu = ranked_loss(ranked_loss > u); % Determine and create vector of the values that are greater than u

% The maximum likelihood function
vi = nu;
x0 = [0.3, 40];
A = [];
B = [];
Aeq = [];
beq = [];
lb = [0, 0]; % constrain xi and beta to be positive
ub = [0.8, 60];
% To compute the optimal parameters of xi and beta through maximizing the likelihood function
[x, fval] = fmincon(@(x)sum(log(((1./x(2)).*(1+(((x(1).*(vi(1:25)-u)))./x(2))).^(-1./(x(1)-1))))), x0, A, B, Aeq, beq, lb, ub); 

% now set some more parameters
n = size(ranked_loss,1);
nu = size(vi,1);
beta = x(2);
xi = x(1);
q = 0.99;

% Compute VaR and ES
VaR = u+((beta./xi).*(((n./nu).*(1-q)).^(-xi)-1));
ES = (VaR+beta-(xi.*u))./(1-xi);

% VaR and ES
[VaR, ES]