clc; clear variables; close all;
%% 2.1.1 Wykresy sygnałów dyskretny
N = 2000;
Tp = 0.001;

tn = 0:Tp:(N-1)*Tp;
% tn = linspace(0,N-1,N)*Tp

H = tf(0.1,[1 -0.9],Tp); %Transmitancja dyskretna

std = 0.8;

x = sin(2*pi*5*tn) + 0.5*sin(2*pi*10*tn) + 0.25*sin(2*pi*30*tn);
e = std*randn(1,N);
v = lsim(H,e,tn);

wykres1=figure('Position',[0 0 1300 800]);
plot(tn,x,'Marker','.','LineStyle','none','MarkerSize',6);
hold on
plot(tn,e,'Marker','.','LineStyle','none','MarkerSize',6);
plot(tn,v,'Marker','.','LineStyle','none','MarkerSize',6);
lgd = legend('x','e','v','interpreter','latex');
grid on
ylabel('wartosci sygnalow','Interpreter','latex','FontSize',18)
xlabel('$nT_p$','FontSize',18,'Interpreter','latex');
title('Przebiegi sygnalow','FontSize',20,'Interpreter','latex');
fontsize(lgd,14,"points")

%% 2.1.2 Pasmo widmowe 
X = fft(x,N) * Tp;
Fs = 1/Tp;
fn = Fs/N*(0:N-1); % freq vector
w_k = 2*pi*fn;
Omega_k = w_k*Tp;

wykres2=figure('Position',[0 0 1300 800]);
stem(Omega_k,abs(X),'MarkerSize',6);
grid on
title("Widmo amplitudowe $|X_N(j\omega_k)|$",'Interpreter','latex','FontSize',18);
xlabel("Czestotliwosc $\Omega_k [rad]$",'Interpreter','latex','FontSize',16);
ylabel("Amplituda prazkow widma",'Interpreter','latex','FontSize',16);

%% 2.1.3 Wyciek widma
N_vec = [1000, 200, 100];
for i = 1:length(N_vec)
N = N_vec(i);
X = fft(x,N) * Tp;
Fs = 1/Tp;
fn = Fs/N*(0:N-1);
wykres3=figure('Position',[0 0 1300 800]);
stem(fn,abs(X),'MarkerSize',6);
grid on
title("Widmo amplitudowe $|X_N(j\omega_k)|$ dla N = " + num2str(N),'Interpreter','latex','FontSize',18);
xlabel("Czestotliwosc $f[Hz]$",'Interpreter','latex','FontSize',16);
ylabel("Amplituda prazkow widma",'Interpreter','latex','FontSize',16);
end

%% 2.1.4 Prawo Parsevala
N=2000;
X = fft(x,N)*Tp;
Fs = 1/Tp;
fn = Fs/N*(0:N-1);

%Energia w czasie
Energia_t = 0;
for i = 1:N
Energia_t = Energia_t + x(i)^2;
end
Energia_t = Energia_t*Tp;
%Energia w dziedzinie częstotliwości
Energia_f = 0;
for i = 1:N
Energia_f = Energia_f + 1/(N*Tp)*abs(X(i))^2;
end
disp(["Energia w dziedzinie czasu E_t = " Energia_t])
disp(["Energia w dziedzinie czestotliwoscic E_f = " Energia_f])

%% 2.1.5 Estymata widmowa
% clc;
% wzor(14) - metoda periodogramowa
w_k = 2*pi*fn;
Omega_k = w_k*Tp;
Est_sum=0;
Est_met_perio = [];
for j = 1:length(Omega_k)
Est_sum = 0;
Omega=Omega_k(j);
for i = 1:N
Est_sum = Est_sum + e(i)*exp(-1i*i*Omega);
end
Est_met_perio = [Est_met_perio Tp/N*(abs(Est_sum)^2)];
end


%wzor (16) - metoda korelogramowa
N_Okno = N/100;
Est_sum = 0;
Est_met_korelo = [];
for j = 1:length(Omega_k)
Omega=Omega_k(j);
Est_sum = 0;
for Tau = -(N_Okno-1):N_Okno-1
Est_sum = Est_sum + Okno_prost(Tau,N_Okno-1)*Korelacja([e' e'],Tau)*exp(-1i*Omega*Tau);
end
Est_met_korelo = [Est_met_korelo Tp*Est_sum];
end


wykres4=figure('Position',[0 0 1300 800]);
subplot(1,2,1)
plot(Omega_k,abs(Est_met_perio),'Marker','.','LineStyle','none','MarkerSize',6);
grid on
xlabel("$\Omega_k$ [rad]",'Interpreter','latex','FontSize',16);
ylabel("Wartosc estymaty",'Interpreter','latex','FontSize',16);
title("Estymata metoda periodogramowa",'Interpreter','latex','FontSize',18)
subplot(1,2,2)
plot(Omega_k,abs(Est_met_korelo),'Marker','.','LineStyle','none','MarkerSize',6);
grid on
xlabel("$\Omega_k$ [rad]",'Interpreter','latex','FontSize',16);
ylabel("Wartosc estymaty",'Interpreter','latex','FontSize',16);
title("Estymata metoda korelogramowa",'Interpreter','latex','FontSize',18)
%% 2.1.6 Estymata widmowa korelogramowa, zmiana szerokości okna

N_vec = [1000 500 200 100]; % Wektor różnych szerokości okna 
for k = 1:length(N_vec)
    N_Okno=N_vec(k); % Zamiana na nową szerokość okna
Est_sum = 0; % Zmienna do sumy
Est_met_korelo2 = []; % Bufor wektora
for j = 1:length(Omega_k)
Omega=Omega_k(j); % Kolejna wartość znormalizowanej Omegi (0,2pi)
for Tau = -(N_Okno-1):N_Okno-1 % Metoda korelogramowa
Est_sum = Est_sum + Okno_prost(Tau,N_Okno-1)*Korelacja([x' x'],Tau)*exp(-1i*Omega*Tau);
end
Est_met_korelo2 = [Est_met_korelo2 Tp*Est_sum]; % Uzupełnienie wektora estymaty
end
% Pórównanie dwóch metod 
disp(["N = " N_Okno])
blad = RMSE(Est_met_korelo,Est_met_korelo2);
end

%% 2.1.7 Estymata gęstości widmowej mocy v. Obydwie metody

w_k = 2*pi*fn;
Omega_k = w_k*Tp;
v_Est_sum=0;
v_Est_met_perio = [];
for j = 1:length(Omega_k)
Omega=Omega_k(j);
for i = 1:N
v_Est_sum = v_Est_sum + x(i)*exp(-1i*i*Omega);
end
v_Est_met_perio = [v_Est_met_perio Tp/N * abs(v_Est_sum)^2];
end


%wzor (16) - metoda korelogramowa
N_Okno = 2000;
v_Est_sum = 0;
v_Est_met_korelo = [];
for j = 1:length(Omega_k)
Omega=Omega_k(j);
for Tau = -(N_Okno-1):N_Okno-1
v_Est_sum = v_Est_sum + Okno_prost(Tau,N_Okno)*Korelacja([x' x'],Tau)*exp(-1i*Omega*Tau);
end
v_Est_met_korelo = [v_Est_met_korelo Tp*v_Est_sum];
end





