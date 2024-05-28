%%Podpunkt 1 i 2
clc; clear variables; 
close all;
Tp = 0.5;
TF = 2.5*Tp/(2*pi);
N = 1000;
sigma2v = 0.001;
Mw = 200;
tend = N*Tp; % Czas aby otrzymać N = 1000;
sim("AWident.mdl");


u = Zdata(1:end-1,1);
y = Zdata(1:end-1,2);

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

Wykres1 = figure("Position",[200 200 1400 800]);
subplot(1,2,1)
sgtitle('Estymowane wykresy bodego Wzor (15) - $\hat{G}(j\omega_k)$','FontSize',16,'interpreter','latex')
plot(omega_k1,LM1,'LineWidth',3);
title("Wzmocnienie",'Interpreter','latex','FontSize',14)
ylabel("Magnitude [dB]",'Interpreter','latex','FontSize',12)
xlabel("czestotliwosc $\omega_k$ [rad] ",'Interpreter','latex','FontSize',12)
xscale log
grid on
ylim([-50 10]);
subplot(1,2,2)
plot(omega_k1,unwrap(angle(G_hat15))*180/pi,'LineWidth',3);
title("Przesuniecie fazowe",'Interpreter','latex','FontSize',14)
ylabel("Phase $[^\circ]$",'Interpreter','latex','FontSize',12)
xlabel("czestotliwosc $\omega_k$ [rad] ",'Interpreter','latex','FontSize',12)
xscale log
grid on
ylim([-500 500]);

%małe omega dla nieparzystej liczcby próbek (Wzor 16)
% D2 = (Gamma - 1)/2;
% k = 0:1:D2;
% omega_k2 = 2*pi/(D2*Tp) * k;
omega_k2 = Omega_k2 / Tp;
LM2 = 20*log10(abs(G_hat16));

Wykres2 = figure("Position",[200 200 1400 800]);
subplot(1,2,1)
sgtitle('Estymowane wykresy bodego Wzor (16) - $\hat{G}(j\omega_k)$','FontSize',16,'interpreter','latex')
plot(omega_k2,LM2,'LineWidth',3);
title("Wzmocnienie",'Interpreter','latex','FontSize',14)
ylabel("Magnitude [dB]",'Interpreter','latex','FontSize',12)
xlabel("czestotliwosc $\omega_k$ [rad] ",'Interpreter','latex','FontSize',12)
xscale log
grid on
ylim([-50 10]);
subplot(1,2,2)
plot(omega_k2,unwrap(angle(G_hat16))*180/pi,'LineWidth',3);
title("Przesuniecie fazowe",'Interpreter','latex','FontSize',14)
ylabel("Phase $[^\circ]$",'Interpreter','latex','FontSize',12)
xlabel("czestotliwosc $\omega_k$ [rad] ",'Interpreter','latex','FontSize',12)
xscale log
grid on
ylim([-500 500]);

% %% Porównanie Rzeczywistego wykresu bodego do estymat wzoru 15 i 16
% G_org = tf(1,[0.1 1.05 0.6 1]);
% [mag,phase,wout] = bode(G_org,omega_k1);
% mag = 20*log10(squeeze(mag));
% phase = squeeze(phase);
% faza = unwrap(angle(G_hat15))*180/pi;
% faza2 = unwrap(angle(G_hat16))*180/pi;
% Wykres3 = figure("Position",[200 200 1400 800]);
% subplot(1,2,1)
% sgtitle('Estymowane wykresy bodego','FontSize',16,'interpreter','latex')
% plot(omega_k1(1:300),LM1(1:300),'LineWidth',3);
% hold on
% plot(omega_k2,LM2,'LineWidth',3);
% plot(wout,mag,'LineWidth',3)
% ylim([-50 10]);
% xlim([wout(1) wout(400)])
% legend('$\hat{G}^*_N$','$\hat{G}_N$','$G_o$','interpreter','latex','fontsize',12);
% title("Wzmocnienie",'Interpreter','latex','FontSize',14)
% ylabel("Magnitude [dB]",'Interpreter','latex','FontSize',12)
% xlabel("czestotliwosc $\omega_k$ [rad] ",'Interpreter','latex','FontSize',12)
% xscale log
% grid on
% 
% subplot(1,2,2)
% plot(omega_k1(1:218),faza(1:218),'LineWidth',3);
% hold on
% plot(omega_k2,faza2,'LineWidth',3);
% plot(wout,phase,'LineWidth',3)
% ylim([-500 500]);
% xlim([wout(1) wout(400)])
% legend('$\hat{G}^*_N$','$\hat{G}_N$','$G_o$','interpreter','latex','fontsize',12);
% title("Przesuniecie fazowe",'Interpreter','latex','FontSize',14)
% ylabel("Phase $[^\circ]$",'Interpreter','latex','FontSize',12)
% xlabel("czestotliwosc $\omega_k$ [rad] ",'Interpreter','latex','FontSize',12)
% xscale log
% grid on

