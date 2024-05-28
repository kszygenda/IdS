function wy = JFIT(we)
%JFIT Summary of this function goes here
% Obliczanie JFIT w czasie rzeczywistym
global suma_licznik suma_mianownik N_biezace;
N_biezace = N_biezace+1;
y = we(1);
y_m = we(2);
suma_licznik = 

N_biezace = N_biezace+1;
JFIT = (1-(suma_licznik)/(suma_mianownik))*100;
wy = JFIT;
end

