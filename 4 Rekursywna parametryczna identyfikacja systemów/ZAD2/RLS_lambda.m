function wy = RLS_lambda(we)
global P_mac_1 p_par_1 lambda eps_max P_min
y = we(1);
y_1 = we(2);
y_2 = we(3);
u_2 = we(4);
y_m_1 = we(5);
%% Resetowanie macierzy
epsOE = y_1 - y_m_1;

if ((abs(epsOE)>eps_max) && (trace(P_mac_1) < P_min) )
    P_mac_1 = diag([10 10 10]);
    % P_mac = diag([0 0 10]);
    % P_mac = diag([0 0 1]);
end
%%
fi = [-y_1 -y_2 u_2]';
% Wzory (17)-(20)
P_mac = (1/lambda)*(P_mac_1 - (P_mac_1*fi*fi'*P_mac_1)/(lambda+fi'*P_mac_1*fi));
% Dla RLS_lambda dzeta(n) = phi(n)
k = P_mac*fi;
eps = y - fi'*p_par_1;
p_par = p_par_1 + k*eps;


%%
P_mac_1 = P_mac;
p_par_1 = p_par;

slad = trace(P_mac_1);
wy = [p_par;slad];

end

