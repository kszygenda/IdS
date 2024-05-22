clc; clear variables; close all;
Tp = 0.05;
sigma2e = 0.1;
TF = 8*Tp;
N = 20000;
tend = N*Tp;
Ro = 10;
global phat_RIV_n1 PIV_n1;
phat_RIV_n1 = zeros(3,1);
PIV_n1 = Ro*eye(3,3);


