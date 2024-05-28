function wy = Kalman_CM1(we)
global p_parCM1_1 P_macCM1_1 V_macCM1;

% 4 wejścia modelu
y = we(1);
y_1 = we(2);
y_2 = we(3);
u_1 = we(4);

fi = [-y_1 -y_2 u_1 ]';
P_predyktor = P_macCM1_1 + V_macCM1;
k = P_predyktor*fi*(1+fi'*P_predyktor*fi)^(-1);
P_mac = P_predyktor - k*fi'*P_predyktor;
eps = y - fi'*p_parCM1_1;
p_par = p_parCM1_1 + k*eps;


P_macCM1_1 = P_mac;
p_parCM1_1 = p_par;

% wyjscie 3 param
wy = p_par;

end

