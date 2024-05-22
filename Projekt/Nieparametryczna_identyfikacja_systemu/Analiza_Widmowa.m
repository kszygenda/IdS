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
% wykres = figure('Position',[0 0 1000 600]);
% subplot(2,1,1)
% plot(t,y)
% title("wyjscie systemu $y$",'interpreter','latex')
% grid on
% subplot(2,1,2)
% plot(t,u)
% title("wyjscie systemu $u$",'interpreter','latex')
% grid on
% sgtitle("Sygnaly systemu nr " + num2str(j))

%% Analiza Widmowa 
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

end



% Komentarze dla siebie
% - Analiza odpowiedzi czasowych nie jest zbytnio możliwa ze względu na
% pobudzenie nie skokowe 
% Ewentualnie mozna pozyskac z analizy korelacyjnej odpowiedź impulsową,
% a potem z pochodnej zrobic odpowiedz skokową i z tego na oko patrzec czy
% jest jakies dopasowanie modelu wieloinercyjnego


