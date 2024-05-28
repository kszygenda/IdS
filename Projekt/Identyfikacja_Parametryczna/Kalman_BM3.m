function wy = Kalman_BM3(we)
global p_parBM3_1 P_macBM3_1 V_macBM3;
y = we(1);
y_1 = we(2);
y_2 = we(3);
y_3 = we(4);
u_1 = we(5);
u_2 = we(6);

fi = [-y_1 -y_2 -y_3 u_1 u_2]';
P_predyktor = P_macBM3_1 + V_macBM3;
k = P_predyktor*fi*(1+fi'*P_predyktor*fi)^(-1);
P_mac = P_predyktor - k*fi'*P_predyktor;
eps = y - fi'*p_parBM3_1;
p_par = p_parBM3_1 + k*eps;


P_macBM3_1 = P_mac;
p_parBM3_1 = p_par;

% wyjscie 5 param
wy = p_par;

end

