% EWMA Variances of each asset
[num] = xlsread('Adj_Close.xlsx','Sheet1', 'B2:E502');
[txt] = xlsread('Adj_Close.xlsx','Sheet1','A3:A502');
t = datetime(txt,'ConvertFrom','excel','format','yyyy/MM/dd');

r1 = diff(log(num(:,1))); %return of 1060.HK
r2 = diff(log(num(:,2))); %return of 1109.HK
r3 = diff(log(num(:,3))); %return of 3883.HK
r4 = diff(log(num(:,4))); %return of 3968.HK


% 1060.HK variance
n = size(num,1);
n = n-1;
ui_1 = r1; ui2_1 = r1 .^ 2;
m = 250; lambda = 0.94;
ai = (1-lambda)*lambda.^(m-1:-1:0)';

V_alpha_r1 = zeros(n-m,1);
for i = 1:n-m
    V_alpha_r1(i,1) = sum(ui2_1(i:i+m-1,1).*ai,1);
end

V_r1= zeros(n-m,1); V_r1(1,1) = V_alpha_r1(1,1);
for i = 2:n-m
    V_r1(i,1) = lambda*V_r1(i-1,1)+(1-lambda)*ui2_1(i+m-1,1);
end

% 1109.HK variance
n = size(num,1);
n = n-1;
ui_2 = r2; ui2_2 = r2 .^ 2;
m = 250; lambda = 0.94;
ai = (1-lambda)*lambda.^(m-1:-1:0)';

V_alpha_r2 = zeros(n-m,1);
for i = 1:n-m
    V_alpha_r2(i,1) = sum(ui2_2(i:i+m-1,1).*ai,1);
end

V_r2 = zeros(n-m,1); V_r2(1,1) = V_alpha_r2(1,1);
for i = 2:n-m
    V_r2(i,1) = lambda*V_r2(i-1,1)+(1-lambda)*ui2_2(i+m-1,1);
end

% 3883.HK variance
n = size(num,1);
n = n-1;
ui_3 = r3; ui2_3 = r3 .^ 2;
m = 250; lambda = 0.94;
ai = (1-lambda)*lambda.^(m-1:-1:0)';

V_alpha_r3 = zeros(n-m,1);
for i = 1:n-m
    V_alpha_r3(i,1) = sum(ui2_3(i:i+m-1,1).*ai,1);
end

V_r3 = zeros(n-m,1); V_r3(1,1) = V_alpha_r3(1,1);
for i = 2:n-m
    V_r3(i,1) = lambda*V_r3(i-1,1)+(1-lambda)*ui2_3(i+m-1,1);
end

% 3968.HK variance
n = size(num,1);
n = n-1;
ui_4 = r4; ui2_4 = r4 .^ 2;
m = 250; lambda = 0.94;
ai = (1-lambda)*lambda.^(m-1:-1:0)';

V_alpha_r4 = zeros(n-m,1);
for i = 1:n-m
    V_alpha_r4(i,1) = sum(ui2_4(i:i+m-1,1).*ai,1);
end

V_r4 = zeros(n-m,1); V_r4(1,1) = V_alpha_r4(1,1);
for i = 2:n-m
    V_r4(i,1) = lambda*V_r4(i-1,1)+(1-lambda)*ui2_4(i+m-1,1);
end

subplot(2,2,1)
plot(V_r1)
title('1060.HK')
xlabel('Scenarios'); ylabel('Variance');

subplot(2,2,2)
plot(V_r2)
title('1109.HK')
xlabel('Scenarios'); ylabel('Variance');

subplot(2,2,3)
plot(V_r3)
title('3883.HK')
xlabel('Scenarios'); ylabel('Variance');

subplot(2,2,4)
plot(V_r4)
title('3968.HK')
xlabel('Scenarios'); ylabel('Variance');