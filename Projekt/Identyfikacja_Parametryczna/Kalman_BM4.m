function wy = Kalman_BM4(we)
global p_parBM4_1 P_macBM4_1 V_macBM4;
y = we(1);
y_1 = we(2);
y_2 = we(4);
u_1 = we(3);
u_2 = we(4);

fi = [-y_1 -y_2 u_1 u_2]';
P_predyktor = P_macBM4_1 + V_macBM4;
k = P_predyktor*fi*(1+fi'*P_predyktor*fi)^(-1);
P_mac = P_predyktor - k*fi'*P_predyktor;
eps = y - fi'*p_parBM4_1;
p_par = p_parBM4_1 + k*eps;


P_macBM4_1 = P_mac;
p_parBM4_1 = p_par;

% wyjscie 4 param
wy = p_par;

end

