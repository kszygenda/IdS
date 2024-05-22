function out = fun_u_p(p,u)
%FUN_U_P Summary of this function goes here
%   Detailed explanation goes here
% Funkcja opisująca zadane f(u,p), obliczająca y dla danego zestawu
% parametrów P oraz danego u.
% Wektor P musi być 4 elementowy.
out = p(1) + p(2)/u + p(3)/(u^2) + p(4)/(u^3);
end

