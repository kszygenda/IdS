function Out = Okno_prost(Tau,Mw)
%OKNO Summary of this function goes here
% N - szerokosc okna
% tau - przesuniecie
if abs(Tau) < Mw
    Out = 1;
else
    Out = 0;
end
end

