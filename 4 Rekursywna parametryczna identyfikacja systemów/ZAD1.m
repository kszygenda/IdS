clear variables; clc; close all;

Tp = 0.1;
tend = 1000;
Td = 1500;

c1o = 0;
% c1o = 0.7;


global p_par_1 P_mac_1
ro = 10;
p_par_1 = zeros(3,1);
P_mac_1 = ro*eye(3,3);