clc; clear variables; close all;
load("IdentWsadowaDyn.mat");
s = tf('s');
n = 1; %rząd filtru
Tp = 0.01;
TF = 50*Tp;
G_SVF_1 = 1/((1 + s*TF)^n);
G_SVF_2 = s/((1 + s*TF)^n);
%Oryginalne parametry systemu
ko = 2.0;
To=0.5;
N=4001;
% Dane ZEST
M = 2000; % liczebnosc danych ZEST
y_zest = DaneDynW(1:M,2);
u_zest = DaneDynW(1:M,1);

t_sim = 0:Tp:(length(y_zest)-1)*Tp;
y_F = lsim(G_SVF_1,y_zest,t_sim,'foh');
u_F = lsim(G_SVF_1,u_zest,t_sim,'foh');
y_PF = lsim(G_SVF_2,y_zest,t_sim,'foh');
phi = [-y_F u_F];

phat_LS = (phi'*phi)^(-1)*phi'*y_PF;


To_hat = 1/phat_LS(1);
ko_hat = phat_LS(2)/phat_LS(1);

%Parametry symulacyjne 
t_vec = 0:Tp:(N-1)*Tp;
Go = ko/(To*s+1);
Go_hat = ko_hat/(To_hat*s+1);
y_o = lsim(Go,DaneDynW(:,1),t_vec,'foh');
y_hat = lsim(Go_hat,DaneDynW(:,1),t_vec,'foh');
wykres = figure('Position',[0 0 1200 800]);
plot(t_vec,y_o,'LineWidth',2)
hold on
plot(t_vec,y_hat,'LineWidth',2);
plot(t_vec,DaneDynW(:,2),'LineWidth',2);
xlabel('czas [s]','Interpreter','Latex','FontSize',14)
ylabel('wartosc wyjscia systemu')
title('porownanie przebiegow oryginalu i estymaty','Interpreter','latex','FontSize',14)
legend('$y_o$','$\hat{y}_o$','$y_o + e(t)$','interpreter','latex','FontSize',14)
grid on


%Porownanie
fprintf("Oryginalne To = %.2f, Aproksymowane To = %.2f \n",To,To_hat)
fprintf("Oryginalne ko = %.2f, Aproksymowane ko = %.2f \n",ko,ko_hat)

%% 3.1.7 Sprawdzić wpływ liczebności i zakresu danych w Zest na jakość identyfikacji.
M_vec = [500 1000 2000 2500 3000];
for i = 1:length(M_vec)
M = M_vec(i); % liczebnosc danych ZEST
y_zest = DaneDynW(1:M,2);
u_zest = DaneDynW(1:M,1);

t_sim = 0:Tp:(length(y_zest)-1)*Tp;
y_F = lsim(G_SVF_1,y_zest,t_sim,'foh');
u_F = lsim(G_SVF_1,u_zest,t_sim,'foh');
y_PF = lsim(G_SVF_2,y_zest,t_sim,'foh');
phi = [-y_F u_F];

phat_LS = (phi'*phi)^(-1)*phi'*y_PF;

To_hat = 1/phat_LS(1);
ko_hat = phat_LS(2)/phat_LS(1);
%Porownanie
disp('------------------------------------------------------------------')
fprintf("Dla parametrów Tp = %.2f, M = %.2f,TF = %.2f,n = %.2f \n",Tp,M,TF,n)
fprintf("Oryginalne To = %.2f, Aproksymowane To = %.2f \n",To,To_hat)
fprintf("Oryginalne ko = %.2f, Aproksymowane ko = %.2f \n",ko,ko_hat)
end

%% 3.1.8 Sprawdzić wpływ wartości TF na jakość identyfikacji.
TF_vec = [5 50 500];
for i = 1:length(TF_vec)
n = 1; %rząd filtru
Tp = 0.01;
TF = TF_vec(i)*Tp;
G_SVF_1 = 1/((1 + s*TF)^n);
G_SVF_2 = s/((1 + s*TF)^n);
%Oryginalne parametry systemu
ko = 2.0;
To=0.5;
% Dane ZEST
M = 2000; % liczebnosc danych ZEST
y_zest = DaneDynW(1:M,2);
u_zest = DaneDynW(1:M,1);

t_sim = 0:Tp:(length(y_zest)-1)*Tp;
y_F = lsim(G_SVF_1,y_zest,t_sim,'foh');
u_F = lsim(G_SVF_1,u_zest,t_sim,'foh');
y_PF = lsim(G_SVF_2,y_zest,t_sim,'foh');
phi = [-y_F u_F];

phat_LS = (phi'*phi)^(-1)*phi'*y_PF;
To_hat = 1/phat_LS(1);
ko_hat = phat_LS(2)/phat_LS(1);

disp('------------------------------------------------------------------')
fprintf("Dla parametrów Tp = %.2f, M = %.2f,TF = %.2f,n = %.2f \n",Tp,M,TF,n)
fprintf("Oryginalne To = %.2f, Aproksymowane To = %.2f \n",To,To_hat)
fprintf("Oryginalne ko = %.2f, Aproksymowane ko = %.2f \n",ko,ko_hat)
end

%% 3.1.9

n_vec = [1 2 3];
for i = 1:length(n_vec)
n = n_vec(i); %rząd filtru
Tp = 0.01;
TF = 50*Tp;
G_SVF_1 = 1/((1 + s*TF)^n);
G_SVF_2 = s/((1 + s*TF)^n);
%Oryginalne parametry systemu
ko = 2.0;
To=0.5;
% Dane ZEST
M = 2000; % liczebnosc danych ZEST
y_zest = DaneDynW(1:M,2);
u_zest = DaneDynW(1:M,1);

t_sim = 0:Tp:(length(y_zest)-1)*Tp;
y_F = lsim(G_SVF_1,y_zest,t_sim,'foh');
u_F = lsim(G_SVF_1,u_zest,t_sim,'foh');
y_PF = lsim(G_SVF_2,y_zest,t_sim,'foh');
phi = [-y_F u_F];

phat_LS = (phi'*phi)^(-1)*phi'*y_PF;
To_hat = 1/phat_LS(1);
ko_hat = phat_LS(2)/phat_LS(1);

disp('------------------------------------------------------------------')
fprintf("Dla parametrów Tp = %.2f, M = %.2f,TF = %.2f,n = %.2f \n",Tp,M,TF,n)
fprintf("Oryginalne To = %.2f, Aproksymowane To = %.2f \n",To,To_hat)
fprintf("Oryginalne ko = %.2f, Aproksymowane ko = %.2f \n",ko,ko_hat)
end

%% 3.1.10 Porównać jakość identyfikacji uzyskiwaną dla dwóch alternatywnych postaci regresji liniowej modelu – biorąc za umowne wyjście Y , y(1)F lub Y , yF .
% Jakosc identyfikacji dla Y = y_f
n = 1; %rząd filtru
Tp = 0.01;
TF = 50*Tp;
G_SVF_1 = 1/((1 + s*TF)^n);
G_SVF_2 = s/((1 + s*TF)^n);
%Oryginalne parametry systemu
ko = 2.0;
To=0.5;
% Dane ZEST
M = 2000; % liczebnosc danych ZEST
y_zest = DaneDynW(1:M,2);
u_zest = DaneDynW(1:M,1);

t_sim = 0:Tp:(length(y_zest)-1)*Tp;
y_F = lsim(G_SVF_1,y_zest,t_sim,'foh');
u_F = lsim(G_SVF_1,u_zest,t_sim,'foh');
y_PF = lsim(G_SVF_2,y_zest,t_sim,'foh');
% Definiujemy wektor Y zgodnie z wyprowadzeniem w załączniku 3.3

phi = [-y_PF u_F];

phat_LS = (phi'*phi)^(-1)*phi'*y_F;

To_hat = phat_LS(1);
ko_hat = phat_LS(2);

disp('------------------------------------------------------------------')
fprintf("Dla parametrów Tp = %.2f, M = %.2f,TF = %.2f,n = %.2f \n",Tp,M,TF,n)
fprintf("Oryginalne To = %.2f, Aproksymowane To = %.2f \n",To,To_hat)
fprintf("Oryginalne ko = %.2f, Aproksymowane ko = %.2f \n",ko,ko_hat)