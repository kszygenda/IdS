function Out = Okno_Hanning(Tau,Mw)
%OKNO Summary of this function goes here
% N - szerokosc okna
% tau - przesuniecie
if abs(Tau) < Mw
    Out = 0.5*(1+cos(Tau*pi/Mw));
else
    Out = 0;
end
end

