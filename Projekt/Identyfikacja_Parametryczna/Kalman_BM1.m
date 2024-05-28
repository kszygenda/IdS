function wy = Kalman_BM1(we)
global p_parBM1_1 P_macBM1_1 V_macBM1;
y = we(1);
y_1 = we(2);
y_2 = we(3);
u_1 = we(4);

fi = [-y_1 -y_2 u_1]';
P_predyktor = P_macBM1_1 + V_macBM1;
k = P_predyktor*fi*(1+fi'*P_predyktor*fi)^(-1);
P_mac = P_predyktor - k*fi'*P_predyktor;
eps = y - fi'*p_parBM1_1;
p_par = p_parBM1_1 + k*eps;


P_macBM1_1 = P_mac;
p_parBM1_1 = p_par;

% wyjscie 5 param
wy = p_par;

end

