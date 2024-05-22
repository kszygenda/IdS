clear variables; clc; close all;

Tp = 0.1;
tend = 1500;
Td = 500;

c1o = 0;
% c1o = 0.7;


global p_par_1 P_mac_1 lambda eps_max P_min 
ro = 10;
p_par_1 = zeros(3,1);
P_mac_1 = ro*eye(3,3);
lambda = 0.99;
eps_max = 0.4;
P_min = 1;

% Kalman wzory 22 25 26 24 23 tak zeby nie bylo za milo kurwa nie
% XD Kalmana standardowo popierdolilo i michalka tez 


