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

%% Analiza korelacyjna + przejrzenie danych na oko 

M = 100; % maksymalna wartosc przesuniecia do obliczenia korelacji

r_yu = [];
r_uu = [];
for tau = 0:M-1
r_yu = [r_yu Covar([y u],tau)];
r_uu = [r_uu Covar([u u],tau)];
end

%utworzenie macierzy korelacji R_uu
R_uu = r_uu;
for i = 2:M
buf = [fliplr(r_uu(2:i)) r_uu(1:M+1-i)];
R_uu = [R_uu; buf];
end

% Estymaty odpowiedzi systemu, Wzor (12)
ghat_10 = (1/Tp)*pinv(R_uu)*r_yu';
%Wzor (11) + wzor (12)
ghat_11 = (1/Tp)*r_yu/r_uu(1);


h_hat11 = [];
for i = 1:length(ghat_11)
h_hat11 = [h_hat11 sum(ghat_11(1:i))*Tp]; 
end

h_hat10 = [];
for i = 1:length(ghat_10)
h_hat10 = [h_hat10 sum(ghat_10(1:i))*Tp]; 
end
% Wykres (10) wzor
plot_gh10 = figure('Position',[0 0 1000 600]);
subplot(2,1,1)
plot(h_hat10)
xlabel('probki [n]')
title('estymowana odpowiedz skokowa $\hat{h_n}$','Interpreter','latex')
subplot(2,1,2)
plot(ghat_10)
xlabel('probki [n]')
title('estymowana odpowiedz impulsowa $\hat{g_n}$','Interpreter','latex')
sgtitle("wzor 10 Estymaty odpowiedzi")
% plot_gh11 = figure('Position',[0 0 1000 600]);
% subplot(2,1,1)
% plot(h_hat11)
% xlabel('probki [n]')
% title('estymowana odpowiedz skokowa $\hat{h_n}$','Interpreter','latex')
% subplot(2,1,2)
% plot(ghat_11)
% xlabel('probki [n]')
% title('estymowana odpowiedz impulsowa $\hat{g_n}$','Interpreter','latex')



% Komenatarz koncowy - Analiza korelacyjna nie daje zbytnio dobrych
% informacji o systemie, 

%% Analiza Poprzez estymate gęstości widmowej



end



% Komentarze dla siebie
% - Analiza odpowiedzi czasowych nie jest zbytnio możliwa ze względu na
% pobudzenie nie skokowe 
% Ewentualnie mozna pozyskac z analizy korelacyjnej odpowiedź impulsową,
% a potem z pochodnej zrobic odpowiedz skokową i z tego na oko patrzec czy
% jest jakies dopasowanie modelu wieloinercyjnego


