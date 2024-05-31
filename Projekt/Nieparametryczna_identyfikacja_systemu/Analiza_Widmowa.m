clc; clear all; close all;
% Wstepna analiza parametrów
Tp = 0.01;
% Conajmniej 3 modele parametryczne, jedne wiecej, drugie mniej.
for j = 1:3
    % Wczytanie roznych danych do identyfikacji wstepnej
    if j == 1
        load("IdentDataA.mat")
        system = "A";
    end
    if j == 2
        load("IdentDataB.mat")
        system = "B";
    end
    if j == 3
        load("IdentDataC.mat")
        system = "C";
    end

%% Analiza widmowa
N = length(u);
Mw = 600;
tend = N*Tp; % Czas aby otrzymać N = 1000;

U = Tp*fft(u);
Y = Tp*fft(y);

%% Wzór (15) - doswiadzalny estymator transmitancji - podpunkt 3
k = 0:N-1;
Omega_k1 = 2*pi/N * k;
G_hat15 = Y./U;

%% Wzór (16) - iloraz estymatorów gęstości widmowych; - podpunkt 3

Upsilon = N-1; % Symbol nazwany jak odpowiadająca komenda w LateX
Gamma = 2*Upsilon + 1;
k = 0:1:Gamma-1;
Omega_k2 = 2*pi/Gamma * k;
Tau = -Upsilon:1:Upsilon;


%Obliczenie Estymaty korelacji uu i yu
Est_yu = zeros(length(Tau),1);
Est_uu = zeros(length(Tau),1);

for i = 1:length(Tau)
Est_yu(i) = Covar([y u],Tau(i));
Est_uu(i) = Covar([u u],Tau(i));
end

% Obliczenie Estymaty gęstości widmowych
Estg_yu = zeros(length(Omega_k2),1);
Estg_uu = zeros(length(Omega_k2),1);
for i = 1:length(Omega_k2)
    Sum_buf_uu = 0;
    Sum_buf_yu = 0;
    omega_buf = Omega_k2(i);
    %Obliczanie sumy 
    for j = 1:length(Tau)
    tau = Tau(j);
    Sum_buf_uu = Sum_buf_uu + Est_uu(j)*Okno_Hanning(tau,Mw)*exp(-1i*omega_buf*tau);
    Sum_buf_yu = Sum_buf_yu + Est_yu(j)*Okno_Hanning(tau,Mw)*exp(-1i*omega_buf*tau);
    end
    Estg_uu(i) = Tp*Sum_buf_uu;
    Estg_yu(i) = Tp*Sum_buf_yu;
end
clear Sum_buf_uu Sum_buf_yu i;
G_hat16 = Estg_yu./Estg_uu;

omega_k1 = Omega_k1 / Tp;
LM1 = 20*log10(abs(G_hat15));
indm = floor(length(omega_k1)/2);% połowa pulsacji
omega_k2 = Omega_k2 / Tp;
LM2 = 20*log10(abs(G_hat16));
indm2 = floor(length(omega_k2)/2);% połowa pulsacji

Wykres1 = figure("Position",[200 200 1400 800]);
% subplot(1,2,1)
set(gca,'TickLabelInterpreter','latex')
sgtitle('Estymowane wykresy bodego, HILsys Dane ' + system,'FontSize',16,'interpreter','latex')
plot(omega_k1(1:indm),LM1(1:indm),'LineWidth',1,'Color','#999999','Marker','.','MarkerSize',8);
hold on
plot(omega_k2(1:indm2),LM2(1:indm2),'LineWidth',1,'Color','#000000','Marker','.','MarkerSize',8);
ylabel("Wzmocnienie [dB]",'Interpreter','latex','FontSize',16)
xlabel("czestotliwosc $\omega_k$ [rad] ",'Interpreter','latex','FontSize',16)
xscale log
grid on
ylim([-10 10]);
lgd = legend("$\hat{G}^*_N (j\Omega_k)$","$\hat{G}_N (j\Omega_k)$",'interpreter','latex');
fontsize(lgd,14,"points")
% odkomentowac do wykresu fazowego
% subplot(1,2,2)
% plot(omega_k1,unwrap(angle(G_hat15))*180/pi,'LineWidth',3);
% hold on
% plot(omega_k2,unwrap(angle(G_hat16))*180/pi,'LineWidth',3);
% title("Przesuniecie fazowe",'Interpreter','latex','FontSize',14)
% ylabel("Phase $[^\circ]$",'Interpreter','latex','FontSize',12)
% xlabel("czestotliwosc $\omega_k$ [rad] ",'Interpreter','latex','FontSize',12)
% xscale log
% grid on
% ylim([-500 500]);
saveas(Wykres1,"Bode"+system,'jpg')

end



% Komentarze dla siebie
% - Analiza odpowiedzi czasowych nie jest zbytnio możliwa ze względu na
% pobudzenie nie skokowe 
% Ewentualnie mozna pozyskac z analizy korelacyjnej odpowiedź impulsową,
% a potem z pochodnej zrobic odpowiedz skokową i z tego na oko patrzec czy
% jest jakies dopasowanie modelu wieloinercyjnego


