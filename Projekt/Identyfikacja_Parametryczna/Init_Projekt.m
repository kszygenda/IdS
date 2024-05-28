clear variables; clc; close all;

Tp = 0.01;
N = 3000;
tend = Tp * N;
ro = 10;


%% Pokazanie danych
% Dane A
load("IdentDataA.mat");
szum_stalyA = mean(y(1:150));
y(1:150) = y(1:150) - szum_stalyA;
u_a = u;
y_a = y;
t_a = t;
to_simA = timeseries([u, y],t, 'Name', 'to_simA');
% Dane B
load("IdentDataB.mat");
szum_stalyB = mean(y(1:150));
y(1:150) = y(1:150) - szum_stalyB;
u_b = u;
y_b = y;
t_b = t;
to_simB = timeseries([u, y],t, 'Name', 'to_simB');
% Dane C
load("IdentDataC.mat");
szum_stalyC = mean(y(1:150));
u_c = u;
y_c = y;
t_c = t;
y(1:150) = y(1:150) - szum_stalyC;
to_simC = timeseries([u, y],t, 'Name', 'to_simC');

%% Inicjalizacja dla danych A
global p_parAM1_1 P_macAM1_1 V_macAM1;
global p_parAM2_1 P_macAM2_1 V_macAM2;
global p_parAM3_1 P_macAM3_1 V_macAM3;
%
sigmaA = 10^(0);
p_parAM1_1 = zeros(3,1);
V_macAM1 = diag([1,1,1]*sigmaA);
P_macAM1_1 = ro*eye(3,3);

p_parAM2_1 = zeros(4,1);
V_macAM2 = diag([1 1 1 1]*sigmaA);
P_macAM2_1 = ro*eye(4,4);

p_parAM3_1 = zeros(5,1);
V_macAM3 = diag([1 1 1 1 1]*sigmaA);
P_macAM3_1 = ro*eye(5,5);
%% Inicjalizacja dla danych B
global p_parBM1_1 P_macBM1_1 V_macBM1;
global p_parBM2_1 P_macBM2_1 V_macBM2;
global p_parBM3_1 P_macBM3_1 V_macBM3;
sigmaB = 10^(-1);
p_parBM1_1 = zeros(3,1);
V_macBM1 = diag([1,0,0]*sigmaB);
P_macBM1_1 = ro*eye(3,3);

p_parBM2_1 = zeros(4,1);
V_macBM2 = diag([1 0 0 0]*sigmaB);
P_macBM2_1 = ro*eye(4,4);

p_parBM3_1 = zeros(5,1);
V_macBM3 = diag([1 0 0 0 0]*sigmaB);
P_macBM3_1 = ro*eye(5,5);

%% Inicjalizacja dla danych C
global p_parCM1_1 P_macCM1_1 V_macCM1;
global p_parCM2_1 P_macCM2_1 V_macCM2;
global p_parCM3_1 P_macCM3_1 V_macCM3;

sigmaC = 10^(-2);
p_parCM1_1 = zeros(3,1);
V_macCM1 = diag([1,1,1]*sigmaC);
P_macCM1_1 = ro*eye(3,3);

p_parCM2_1 = zeros(4,1);
V_macCM2 = diag([1 1 1 1]*sigmaC);
P_macCM2_1 = ro*eye(4,4);

p_parCM3_1 = zeros(5,1);
V_macCM3 = diag([1 1 1 1 1]*sigmaC);
P_macCM3_1 = ro*eye(5,5);

%% Symulacja
sim("Identyfikacja.mdl")

% --------- Wykresy wyjściowe ----------
t_vec = 0:Tp:(length(yc)-1)*Tp;

% Dane A
wykres_A = figure('Position',[0 0 1600 800]);
plot(t_vec,ya,'LineWidth',1.5);
hold on
plot(t_vec,yAM1,'--','LineWidth',1.5);
plot(t_vec,yAM2,"-.",'LineWidth',1.5);
plot(t_vec,yAM3,":",'LineWidth',1.5);
grid on
set(gca,'TickLabelInterpreter','latex','FontSize',12);
title("Porownanie wyjscia systemu z wyjsciem modeli, dane A",'Interpreter','latex','FontSize',18)
xlabel('probki $[n]$','FontSize',15,'Interpreter','latex');
legend("$y_s(n)$","$\mathcal{M}_1 : y_m(n)$","$\mathcal{M}_2 : y_m(n)$","$\mathcal{M}_3 : y_m(n)$",'fontsize',14,'Interpreter','latex');

% Dane B
wykres_B = figure('Position',[0 0 1600 800]);
plot(t_vec,yb,'LineWidth',1.5);
hold on
plot(t_vec,yBM1,'--','LineWidth',1.5);
plot(t_vec,yBM2,"-.",'LineWidth',1.5);
plot(t_vec,yBM3,":",'LineWidth',1.5);
grid on
set(gca,'TickLabelInterpreter','latex','FontSize',12);
title("Porownanie wyjscia systemu z wyjsciem modeli, dane B",'Interpreter','latex','FontSize',18)
xlabel('probki $[n]$','FontSize',15,'Interpreter','latex');
legend("$y_s(n)$","$\mathcal{M}_1 : y_m(n)$","$\mathcal{M}_2 : y_m(n)$","$\mathcal{M}_3 : y_m(n)$",'fontsize',14,'Interpreter','latex');

% Dane C
wykres_C = figure('Position',[0 0 1600 800]);
plot(t_vec,yc,'LineWidth',1.5);
hold on
plot(t_vec,yCM1,'--','LineWidth',1.5);
plot(t_vec,yCM2,"-.",'LineWidth',1.5);
plot(t_vec,yCM3,":",'LineWidth',1.5);
grid on
set(gca,'TickLabelInterpreter','latex','FontSize',12);
title("Porownanie wyjscia systemu z wyjsciem modeli, dane C",'Interpreter','latex','FontSize',18)
xlabel('probki $[n]$','FontSize',15,'Interpreter','latex');
legend("$y_s(n)$","$\mathcal{M}_1 : y_m(n)$","$\mathcal{M}_2 : y_m(n)$","$\mathcal{M}_3 : y_m(n)$",'fontsize',14,'Interpreter','latex');

saveas(wykres_A,"ModeleA",'jpg')
saveas(wykres_B,"ModeleB",'jpg')
saveas(wykres_C,"ModeleC",'jpg')
%% JFIT
%Dane A
m_hat = sum(ya)/length(ya);
JFIT_AM1 = (1 - sum((abs(ya - yAM1)))/sum((abs(ya - m_hat)))) * 100;
JMSE_AM1 = 1/length(ya) * sum((ya - yAM1).^2);
JFIT_AM2 = (1 - sum((abs(ya - yAM2)))/sum((abs(ya - m_hat)))) * 100;
JMSE_AM2 = 1/length(ya) * sum((ya - yAM2).^2);
JFIT_AM3 = (1 - sum((abs(ya - yAM3)))/sum((abs(ya - m_hat)))) * 100;
JMSE_AM3 = 1/length(ya) * sum((ya - yAM3).^2);

%Dane B
m_hat = sum(yb)/length(yb);
JFIT_BM1 = (1 - sum((abs(yb - yBM1)))/sum((abs(yb - m_hat)))) * 100;
JMSE_BM1 = 1/length(yb) * sum((ya - yBM1).^2);
JFIT_BM2 = (1 - sum((abs(yb - yBM2)))/sum((abs(yb - m_hat)))) * 100;
JMSE_BM2 = 1/length(yb) * sum((ya - yBM2).^2);
JFIT_BM3 = (1 - sum((abs(yb - yBM3)))/sum((abs(yb - m_hat)))) * 100;
JMSE_BM3 = 1/length(yb) * sum((yb - yBM3).^2);

%Dane C
m_hat = sum(yc)/length(yc);
JFIT_CM1 = (1 - sum((abs(yc - yCM1)))/sum((abs(yc - m_hat)))) * 100;
JMSE_CM1 = 1/length(yc) * sum((yc - yCM1).^2);
JFIT_CM2 = (1 - sum((abs(yc - yCM2)))/sum((abs(yc - m_hat)))) * 100;
JMSE_CM2 = 1/length(yc) * sum((yc - yCM2).^2);
JFIT_CM3 = (1 - sum((abs(yc - yCM3)))/sum((abs(yc - m_hat)))) * 100;
JMSE_CM3 = 1/length(yc) * sum((yc - yCM3).^2);
% 
fprintf("Dla danych A: \n")
fprintf("MODEL 1, JFIT = %.2f, MSE = %.6f\n",JFIT_AM1,JMSE_AM1)
fprintf("MODEL 2, JFIT = %.2f, MSE = %.6f\n",JFIT_AM2,JMSE_AM2)
fprintf("MODEL 3, JFIT = %.2f, MSE = %.6f\n",JFIT_AM3,JMSE_AM3)
fprintf("----------------------------------------------------\n")
fprintf("Dla danych B:\n")
fprintf("MODEL 1, JFIT = %.2f, MSE = %.6f\n",JFIT_BM1,JMSE_BM1)
fprintf("MODEL 2, JFIT = %.2f, MSE = %.6f\n",JFIT_BM2,JMSE_BM2)
fprintf("MODEL 3, JFIT = %.2f, MSE = %.6f\n",JFIT_BM3,JMSE_BM3)
fprintf("----------------------------------------------------\n")
fprintf("Dla danych C:\n")
fprintf("MODEL 1, JFIT = %.2f, MSE = %.6f\n",JFIT_CM1,JMSE_CM1)
fprintf("MODEL 2, JFIT = %.2f, MSE = %.6f\n",JFIT_CM2,JMSE_CM2)
fprintf("MODEL 3, JFIT = %.2f, MSE = %.6f\n",JFIT_CM3,JMSE_CM3)
fprintf("----------------------------------------------------\n")


%% Wykorzystanie Modelu 1 z parametrami z danych C do weryfikacji modelu.
% p_hat = p_hat_CM1(end,1:3);
% Finalna transmitancja modelu
% z = tf('z',Tp);
% G_m = (p_hat(3) * z^(-1)) / (z^(-2)*p_hat(2) + z^(-1)*p_hat(1) + 1);
% t_vec = 0:Tp:(N-1)*Tp;
% y_m_a = lsim(G_m,u_a,t_vec);
% y_m_b = lsim(G_m,u_b,t_vec);
% y_m_c = lsim(G_m,u_c,t_vec);
% Modele:
ya_n1 = 0;
ya_n2 = 0;
y_m_a = zeros(1,N);
u_a_n1 = 0;
u_a_n2 = 0;
for i = 1:length(y_m_a)
y_m_a(i) = [-ya_n1 -ya_n2 u_a_n1 u_a_n2]*p_hat_CM1(i,1:4)';
ya_n2 = ya_n1;
ya_n1 = y_m_a(i);
u_a_n2 = u_a_n1;
u_a_n1 = u_a(i);
end

yb_n1 = 0;
yb_n2 = 0;
y_m_b = zeros(1,N);
u_b_n1 = 0;
u_b_n2 = 0;
for i = 1:length(y_m_b)
y_m_b(i) = [-yb_n1 -yb_n2 u_b_n1 u_b_n2]*p_hat_CM1(i,1:4)';
yb_n2 = yb_n1;
yb_n1 = y_m_b(i);
u_b_n2 = u_b_n1;
u_b_n1 = u_b(i);
end

yc_n1 = 0;
yc_n2 = 0;
y_m_c = zeros(1,N);
u_c_n1 = 0;
u_c_n2 = 0;
for i = 1:length(y_m_c)
y_m_c(i) = [-yc_n1 -yc_n2 u_c_n1 u_c_n2]*p_hat_CM1(i,1:4)';
yc_n2 = yc_n1;
yc_n1 = y_m_c(i);
u_c_n2 = u_c_n1;
u_c_n1 = u_c(i);
end


% Porównanie modelu do danych A
WykresA = figure('Position',[0 0 1300 700]);
plot(t_a,y_a,'LineWidth',1.5,'Color','#999999');
hold on
plot(t_a,y_m_a,'.-','LineWidth',1.5,'Color','#000000');
grid on
xlabel('probki [n]','FontSize',15,'Interpreter','latex')
legend('$y_s(n)$','$y_m(n)$','FontSize',14,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',12);
title("Porownanie modelu do danych A",'FontSize',16,'Interpreter','latex');

% Porównanie modelu do danych B
WykresB = figure('Position',[0 0 1300 700]);
plot(t_b,y_b,'LineWidth',1.5,'Color','#999999');
hold on
plot(t_b,y_m_b,'.-','LineWidth',1.5,'Color','#000000');
grid on
xlabel('probki [n]','FontSize',15,'Interpreter','latex')
legend('$y_s(n)$','$y_m(n)$','FontSize',14,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',12);
title("Porownanie modelu do danych B",'FontSize',16,'Interpreter','latex');

% Porównanie modelu do danych C
WykresC = figure('Position',[0 0 1300 700]);
plot(t_c,y_c,'LineWidth',1.5,'Color','#999999');
hold on
plot(t_c,y_m_c,'.-','LineWidth',1.5,'Color','#000000');
grid on
xlabel('probki [n]','FontSize',15,'Interpreter','latex')
legend('$y_s(n)$','$y_m(n)$','FontSize',14,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',12);
title("Porownanie modelu do danych C",'FontSize',16,'Interpreter','latex');

