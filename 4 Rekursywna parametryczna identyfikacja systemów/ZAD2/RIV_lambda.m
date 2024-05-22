function wy = RIV_lambda(we)
global P_mac_1 p_par_1 lambda eps_max P_min 
y = we(1);
y_1 = we(2);
y_2 = we(3);
u_2 = we(4);
y_m_1 = we(5);
x_1 = we(6); % Nowe instrumentalne
x_2 = we(7);

epsOE = y_1 - y_m_1;

fi = [-y_1 -y_2 u_2]';
z = [-x_1 -x_2 u_2]';
% Wzory (17)-(20)
P_mac = (1/lambda)*(P_mac_1 - (P_mac_1*z*fi'*P_mac_1)/(lambda+fi'*P_mac_1*z));
% Dla RIV_lambda dzeta(n) = z(n)
k = P_mac*z;
eps = y - fi'*p_par_1;
p_par = p_par_1 + k*eps;
%%
% if trace(P_mac) < P_min || abs(eps)>eps_max
%     P_mac = diag([10 10 10]);
%     % P_mac = diag([0 0 10]);
%     % P_mac = diag([0 0 1]);
% end
%% Przesuwanie wartosci
P_mac_1 = P_mac;
p_par_1 = p_par;

slad = trace(P_mac_1);
wy = [p_par;slad];

end

