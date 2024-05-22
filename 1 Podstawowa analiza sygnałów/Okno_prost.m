function Out = Okno_prost(Tau,N)
%OKNO Summary of this function goes here
% N - szerokosc okna
% tau - przesuniecie
if abs(Tau) <= N
    Out = 1;
else
    Out = 0;
end
end

