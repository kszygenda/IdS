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
wykres = figure('Position',[0 0 1000 600]);
subplot(2,1,1)
plot(t,y)
set(gca,'TickLabelInterpreter','latex')
title("wyjscie systemu $y$",'interpreter','latex')
grid on
subplot(2,1,2)
plot(t,u)
set(gca,'TickLabelInterpreter','latex')
title("wyjscie systemu $u$",'interpreter','latex')
grid on
sgtitle("Sygnaly systemu danych " + system,'interpreter','latex','fontsize',14)
saveas(wykres,"Przebiegi"+system,'jpg')

%% Analiza korelacyjna + przejrzenie danych na oko 

M = 400; % maksymalna wartosc przesuniecia do obliczenia korelacji

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
plot_gh10 = figure('Position',[0 0 600 600]);
subplot(2,1,1)
plot(h_hat10,'LineWidth',1.5)
set(gca,'TickLabelInterpreter','latex')
xlabel('probki [n]','Interpreter','latex')
title('estymowana odpowiedz skokowa $\hat{h_n}$','Interpreter','latex')
grid on
subplot(2,1,2)
plot(ghat_10,'LineWidth',1.5)
set(gca,'TickLabelInterpreter','latex')
xlabel('probki [n]','Interpreter','latex')
title('estymowana odpowiedz impulsowa $\hat{g_n}$','Interpreter','latex')
grid on
sgtitle("wzor (1) estymaty odpowiedzi dla danych " +system,'Interpreter','latex')
saveas(plot_gh10,"Kor1"+system,'jpg')

plot_gh11 = figure('Position',[0 0 600 600]);
subplot(2,1,1)
plot(h_hat11,'LineWidth',1.5)
set(gca,'TickLabelInterpreter','latex')
xlabel('probki [n]','Interpreter','latex')
title('estymowana odpowiedz skokowa $\hat{h_n}$','Interpreter','latex')
grid on
subplot(2,1,2)
plot(ghat_11,'LineWidth',1.5)
set(gca,'TickLabelInterpreter','latex')
xlabel('probki [n]','Interpreter','latex')
title('estymowana odpowiedz impulsowa $\hat{g_n}$','Interpreter','latex')
sgtitle("wzor (2) estymaty odpowiedzi dla danych " +system,'Interpreter','latex')
grid on
saveas(plot_gh11,"Kor2"+system,'jpg')



%% Odpowiedzi czasowe, analiza czasowa estymowanych przebiegów
close(plot_gh11);
close(plot_gh10);
t_vec10 = 0:Tp:(length(h_hat10)-1)*Tp;


plot_h11 = figure('Position',[0 0 1200 1200]);
plot(t_vec10,h_hat10,'LineWidth',1.5);
xlabel('czas [s]','Interpreter','latex','FontSize',17);
set(gca,'TickLabelInterpreter','latex')
grid on
title("przebieg $\hat{h}(nT_p)$ czasowy odpowiedzi skokowej Wzor (1) i (3) dla danych " + system,'Interpreter','latex',...
    'FontSize',13);

K = h_hat10(end);
s = tf('s');
u_sim = ones(1,length(t_vec10));
if j ==1
    T50 = 0.18;
    T90 = 0.37;
    disp("Dane "+system);
    fprintf("T90/T50 = %.2f \n",(T90/T50))
    fprintf("Wzmocnienie statyczne K = %.2f \n", K)
    fprintf("Estymowany rząd dynamiki p = 3 \n")
    fprintf("------------------------------- \n")
    T = 0.07;
    G_est = K/((1+s*T)^3);
    y_sim = lsim(G_est,u_sim,t_vec10,'foh');
    porownanie = figure('Position',[0 0 900 400]);
    plot(t_vec10,h_hat10,'LineWidth',1.5);
    hold on
    plot(t_vec10,y_sim,'LineWidth',1.5)
    xlabel('czas [s]','Interpreter','latex','FontSize',17);
    set(gca,'TickLabelInterpreter','latex')
    grid on
    title("Porownanie przebiegow odpowiedzi skokowych dla danych " + system,'Interpreter','latex',...
        'FontSize',15);
    legend("$\hat{h}(nT_p)$","$\hat{h_o}(nT_p)$",'interpreter','latex','fontsize',14)
    saveas(porownanie,"czas"+system,'jpg')
end
if j == 2
    T50 = 0.18;
    T90 = 0.37;
    disp("Dane "+system);
    fprintf("NIE ANALIZOWANY \n")
    fprintf("-------------------------- \n")
end
if j == 3
    T50 = 0.16;
    T90 = 0.35;
    disp("Dane "+system);
    fprintf("T90/T50 = %.2f \n",(T90/T50))
    fprintf("Wzmocnienie statyczne K = %.2f \n", K)
    fprintf("Estymowany rząd dynamiki p = 2 \n")
    fprintf("-------------------------- \n")
    T = 0.1;
    G_est = K/((1+s*T)^2);
    y_sim = lsim(G_est,u_sim,t_vec10,'foh');
    porownanie = figure('Position',[0 0 900 400]);
    plot(t_vec10,h_hat10,'LineWidth',1.5);
    hold on
    plot(t_vec10,y_sim,'LineWidth',1.5)
    xlabel('czas [s]','Interpreter','latex','FontSize',17);
    set(gca,'TickLabelInterpreter','latex')
    grid on
    title("Porownanie przebiegow odpowiedzi skokowych dla danych " + system,'Interpreter','latex',...
        'FontSize',15);
    legend("$\hat{h}(nT_p)$","$\hat{h_o}(nT_p)$",'interpreter','latex','fontsize',14)
    saveas(porownanie,"czas"+system,'jpg')
end




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


