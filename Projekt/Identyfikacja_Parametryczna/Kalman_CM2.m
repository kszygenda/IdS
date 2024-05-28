function wy = Kalman_CM2(we)
global p_parCM2_1 P_macCM2_1 V_macCM2;

% 5 Wejść 
y = we(1);
y_1 = we(2);
y_2 = we(3);
u_1 = we(4);
u_2 = we(5);
fi = [-y_1 -y_2 u_1 u_2]';
P_predyktor = P_macCM2_1 + V_macCM2;
k = P_predyktor*fi*(1+fi'*P_predyktor*fi)^(-1);
P_mac = P_predyktor - k*fi'*P_predyktor;
eps = y - fi'*p_parCM2_1;
p_par = p_parCM2_1 + k*eps;


P_macCM2_1 = P_mac;
p_parCM2_1 = p_par;

% wyjscie 4 param
wy = p_par;

end

