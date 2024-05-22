clear all; clc;
%% 3.1.2 Parametry
Tp = 0.5;
TF = 2.5*Tp/(2*pi);
N = 1001;
sigma2v = 0.001;
tend = N;
sim("AWident.mdl");

u = Zdata(:,1); % Po filtrze antyaliasingowym
y = Zdata(:,2); % Po filtrze antyaliasingowym
t = [0:Tp:N];

wykres1=figure('Position',[0 0 1300 800]);
plot(t, u, 'LineWidth', 1.5);
hold on
plot(t, y, 'LineWidth', 1.5);
hold off
grid on;
legend('$FAA_u$','$FAA_y$','interpreter','latex','fontsize',12);
xlabel("$t[s]$",'Interpreter','latex','FontSize',16);
ylabel("Wartosci danych",'Interpreter','latex','FontSize',16);
title('Dane pomiarowe w dziedzinie czasu', 'Interpreter','latex','FontSize',15);
%% 3.1.3
% Wzór (15) -> G_N = Y_N/U_N
Y_N = Tp * fft(y);
U_N = Tp * fft(u);
ETFE = Y_N./U_N; % Empirical Transfer-Function Estimate

% Wzór (16) -> estymator wygładzony
Mw = 200; % Szerokosc okna
for j = 0:N-1
    ruuP(j+1) = Covar([u u], j);
    if (j<=Mw)
        ruuP(j+1) = ruuP(j+1)*0.5*(1+cos(pi*j/Mw));
    else
        ruuP(j+1) = ruuP(j+1)*0;
    end
end
Ruu = [ruuP(1:Mw+1) zeros(1,2*N-2*Mw-2) ruuP(Mw+1:-1:2)];

for j = 0:N-1
    ryuP(j+1) = Covar([y u], j);
    if (j<=Mw)
        ryuP(j+1) = ryuP(j+1)*0.5*(1+cos(pi*j/Mw));
    else
        ryuP(j+1) = ryuP(j+1)*0;
    end
end

for j = 0:N-1
    i = j-(N-1);

    ryuN(j+1) = Covar([y u], i);
    if (abs(i)<=Mw)
        ryuN(j+1) = ryuN(j+1)*0.5*(1+cos(pi*i/Mw));
    else
        ryuN(j+1) = ryuN(j+1)*0;
    end
end

Ryu = [ryuP(1:Mw+1) zeros(1,2*N-2*Mw-2) ryuN(N-Mw:N-1)];

phi_uu = Tp * fft(Ruu);
phi_yu = Tp * fft(Ryu);

hat_Gn = phi_yu./phi_uu;

%% 3.1.4
% ETFE
LmETFE = 20*log10(abs(ETFE));
ArgETFE = unwrap(angle(ETFE)) * 180/pi;

Nmm = size(abs(ETFE),1); % liczba elementów
dOmegam = 2*pi/Nmm; % bin pulsacji
k = (0:1:Nmm-1);
Omegam = dOmegam*k; % wektor pulsacji unormowanych [rad]
omegam = Omegam/Tp; % pulsacje w [rad/s]
indm = floor(Nmm/2);% połowa pulsacji
omega2m = omegam(1:indm);% wektor połowy pulsacji

% estymator wygładzony

Lmhat_Gn = 20*log10(abs(hat_Gn));
Arghat_Gn = unwrap(angle(hat_Gn)) * 180/pi;
Nm = size(abs(hat_Gn),2);
dOmega = 2*pi/Nm;
k = (0:1:Nm-1);
Omega = dOmega*k;
omega = Omega/Tp; 
ind = floor(Nm/2);
omega2 = omega(1:ind);

% Nieznany w praktyce obiekt
num = [1];
den = [0.1 1.05 0.6 1];
Go_s = tf(num,den);
[mag,phase] = bode(Go_s,omega2);
mag = squeeze(mag);
mag = 20*log10(mag);
phase = squeeze(phase);


%% 3.1.4 (wykres) 3.1.6 (wykres)
wykres2=figure('Position',[0 0 1300 800]);
subplot(1,2,1)
semilogx(omega2m, LmETFE(1:indm), 'LineWidth', 1);
hold on
semilogx(omega2, Lmhat_Gn(1:ind), 'LineWidth', 2);
semilogx(omega2,mag, 'k--','LineWidth',2);
hold off
grid on;
legend('$\hat{G}^*_N$','$\hat{G}_N$','$G_o$','interpreter','latex','fontsize',12);
xlabel("$\omega [rad/s]$",'Interpreter','latex','FontSize',16);
ylabel("Lm [dB]",'Interpreter','latex','FontSize',16);
title('Charakterystyka amplitudowa', 'Interpreter','latex','FontSize',13);

subplot(1,2,2)
semilogx(omega2m, ArgETFE(1:indm), 'LineWidth', 1);
hold on
semilogx(omega2, Arghat_Gn(1:ind), 'LineWidth', 2);
semilogx(omega2, phase, 'k--','LineWidth',2);
hold off
grid on;
ylim([-500,500])
legend('$\hat{G}^*_N$','$\hat{G}_N$','$G_o$','interpreter','latex','fontsize',12);
xlabel("$\omega [rad/s]$",'Interpreter','latex','FontSize',16);
ylabel("Arg [deg]",'Interpreter','latex','FontSize',16);
title('Charakterystyka fazowa', 'Interpreter','latex','FontSize',13);
sgtitle('Charakterystyka modulu Bodego', 'Interpreter','latex','FontSize',18);





