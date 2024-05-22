function wy = PIV(we)
global phat_RIV_n1 PIV_n1;
xPF = we(1);
xF = we(2);
yPF = we(3);
yF = we(4);
uF = we(5);
yPPF = we(6);


phi = [-yPF -yF uF]';
z_n = [-xPF -xF uF]';

% wzory (9) - (12)
PIV = PIV_n1 - (PIV_n1 * z_n * phi' * PIV_n1) / (1 + phi' * PIV_n1 *z_n);
k = PIV * z_n;
eps = yPPF - phi'*phat_RIV_n1;
phat_RIV = phat_RIV_n1 + k*eps;

phat_RIV_n1 = phat_RIV;
PIV_n1 = PIV;

wy = phat_RIV;

%dodać macierz PIV na start symulacji 
% dodac obliczenie zn xp
end

