clc; clear variables; close all;
load("IdentWsadowaStat.mat");
%DaneStatW - nieskorelowany szum
%DaneStatC - skorelowany szum
%% Zapisanie modelu w formie regresji liniowej.
syms u p1 p2 p3 p4
F1 = 1/u;
F2 = 1/(u^2);
F3 = 1/(u^3);
PHI = [1 F1 F2 F3].';
P = [p1 p2 p3 p4].';
% f(u,p)
fup = transpose(PHI)*P;
pretty(fup)

%% Obliczenie macierzy regresji liniowej dla dwóch przypadków
u_e = DaneStatC(:,1);
y_e = DaneStatC(:,2);
u_v = DaneStatW(:,1);
y_v = DaneStatW(:,2);
%Prealokacja (przyspieszenie dzialania skryptu)
phi_matrix_e = zeros(length(DaneStatC(:,1)),length(PHI));
phi_matrix_v = zeros(length(DaneStatW(:,1)),length(PHI));
%phi - macierz wektorow regresji

for i = 1:length(u_e)
PHI_e_i = subs(PHI,u,u_e(i));
PHI_v_i = subs(PHI,u,u_v(i));
phi_matrix_e(i,:) = PHI_e_i;
phi_matrix_v(i,:) = PHI_v_i;
end

p_hat_LS_e = (phi_matrix_e.'*phi_matrix_e)^(-1) * phi_matrix_e.' * y_e;
p_hat_LS_v = (phi_matrix_v.'*phi_matrix_v)^(-1) * phi_matrix_v.' * y_v;

%% Obliczenie hat_ym oraz wyswietlenie wynikow
hat_y_e = zeros(length(y_e),1);
hat_y_v = zeros(length(y_v),1);
for i = 1:length(y_e)
hat_y_e(i) = fun_u_p(p_hat_LS_e,u_e(i));
hat_y_v(i) = fun_u_p(p_hat_LS_v,u_v(i));
end
N_vec = 1:length(y_e);

%Wykres dla szumu e
wykres1 = figure('Position',[0 0 1200 800]);
set(gca,"TickLabelInterpreter","latex")
plot(N_vec,y_e,'LineWidth',1.5,'Color',[0 0.4470 0.7410],'LineStyle','none','Marker','o');
hold on
plot(N_vec,hat_y_e,'LineWidth',1.5,'LineStyle','--','Color',[0.6350 0.0780 0.1840])
xlabel("Numer probki [$n$]",'Interpreter','latex','FontSize',14)
ylabel("Wartosc funkcji",'Interpreter','latex','FontSize',14)
title("Porownanie $y$ oraz $\hat{y}_m$ dla szumu e",'Interpreter','latex','FontSize',16)
grid on
legend('$y_o$','$\hat{y}_m$','interpreter','latex','fontsize',12);

%Wykres dla szumu e
wykres2 = figure('Position',[0 0 1200 800]);
set(gca,"TickLabelInterpreter","latex")
plot(N_vec,y_v,'LineWidth',1.5,'Color',[0 0.4470 0.7410],'LineStyle','none','Marker','o');
hold on
plot(N_vec,hat_y_v,'LineWidth',1.5,'LineStyle','--','Color',[0.6350 0.0780 0.1840])
xlabel("Numer probki [$n$]",'Interpreter','latex','FontSize',14)
ylabel("Wartosc funkcji",'Interpreter','latex','FontSize',14)
title("Porownanie $y$ oraz $\hat{y}_m$ dla szumu v",'Interpreter','latex','FontSize',16)
grid on
legend('$y_o$','$\hat{y}_m$','interpreter','latex','fontsize',12);


%% Estymacja dla co J próbkę
J = 1;
% Obliczenie macierzy regresji liniowej dla dwóch przypadków
u_e = DaneStatC(1:J:end,1);
y_e = DaneStatC(1:J:end,2);
u_v = DaneStatW(1:J:end,1);
y_v = DaneStatW(1:J:end,2);
%Prealokacja (przyspieszenie dzialania skryptu)
phi_matrix_e = zeros(length(y_e),length(PHI));
phi_matrix_v = zeros(length(y_v),length(PHI));
%phi - macierz wektorow regresji

for i = 1:length(u_e)
PHI_e_i = subs(PHI,u,u_e(i));
PHI_v_i = subs(PHI,u,u_v(i));
phi_matrix_e(i,:) = PHI_e_i;
phi_matrix_v(i,:) = PHI_v_i;
end

p_hat_LS_e = (phi_matrix_e.'*phi_matrix_e)^(-1) * phi_matrix_e.' * y_e;
p_hat_LS_v = (phi_matrix_v.'*phi_matrix_v)^(-1) * phi_matrix_v.' * y_v;

% Obliczenie hat_ym oraz wyswietlenie wynikow
hat_y_e = zeros(length(y_e),1);
hat_y_v = zeros(length(y_v),1);
for i = 1:length(y_e)
hat_y_e(i) = fun_u_p(p_hat_LS_e,u_e(i));
hat_y_v(i) = fun_u_p(p_hat_LS_v,u_v(i));
end
N_vec = 1:length(y_e);

%Wykres dla szumu e
wykres1 = figure('Position',[0 0 1200 800]);
set(gca,"TickLabelInterpreter","latex")
plot(N_vec,y_e,'LineWidth',1.5,'Color',[0 0.4470 0.7410],'LineStyle','none','Marker','o');
hold on
plot(N_vec,hat_y_e,'LineWidth',1.5,'LineStyle','--','Color',[0.6350 0.0780 0.1840])
xlabel("Numer probki [$n$]",'Interpreter','latex','FontSize',14)
ylabel("Wartosc funkcji",'Interpreter','latex','FontSize',14)
title("Porownanie $y$ oraz $\hat{y}_m$ dla szumu e",'Interpreter','latex','FontSize',16)
grid on
legend('$y_o$','$\hat{y}_m$','interpreter','latex','fontsize',12);

%Wykres dla szumu e
wykres2 = figure('Position',[0 0 1200 800]);
set(gca,"TickLabelInterpreter","latex")
plot(N_vec,y_v,'LineWidth',1.5,'Color',[0 0.4470 0.7410],'LineStyle','none','Marker','o');
hold on
plot(N_vec,hat_y_v,'LineWidth',1.5,'LineStyle','--','Color',[0.6350 0.0780 0.1840])
xlabel("Numer probki [$n$]",'Interpreter','latex','FontSize',14)
ylabel("Wartosc funkcji",'Interpreter','latex','FontSize',14)
title("Porownanie $y$ oraz $\hat{y}_m$ dla szumu v",'Interpreter','latex','FontSize',16)
grid on
legend('$y_o$','$\hat{y}_m$','interpreter','latex','fontsize',12);

%% Oszacowanie Macierzy kowariancji
% UWAGA - przed uruchomieniem tej sekcji nalezy z powrotem ustawić wartość
% J = 1 oraz uruchomić poprzednią sekcję aby zaktualizować wartości y oraz
% y_m
eps = y_e - hat_y_e;

N = length(y_e);
d_p = length(p_hat_LS_e);
sigma2v = 1/(N-d_p) * sum(eps.^2);

Cov_matrix = sigma2v * (phi_matrix_e.' * phi_matrix_e)^(-1);

for i = 1:length(p_hat_LS_e)
dolny = p_hat_LS_e(i) - 1.96*sqrt(Cov_matrix(i,i));
gorny = p_hat_LS_e(i) + 1.96*sqrt(Cov_matrix(i,i));
fprintf("Przedzial ufnosci dla hat_p%.2f" ,i);
fprintf("wynosi (%.2f ; %.2f ) \n",dolny,gorny)
end

