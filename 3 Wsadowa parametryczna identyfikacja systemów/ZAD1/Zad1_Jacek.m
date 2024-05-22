close all; clear all; clc;
%% Parametry
load IdentWsadowaStat.mat;
% Szum biały
u_white = DaneStatW(:,1);
y_white = DaneStatW(:,2);

% Szum kolorowy
u_color = DaneStatC(:,1);
y_color = DaneStatC(:,2);

%% ZADANIE 1.1.2
%% SZUM BIAŁY 
N_w = size(u_white,1);
Phi = [ones(N_w,1), (1./u_white), (1./(u_white.^2)), (1./(u_white.^3))];
% Phi = [(1./u_white), (1./(u_white.^2)), (1./(u_white.^3))];
phat = pinv(Phi) * y_white;
yhat = Phi*phat;

%% SZUM KOLOROWY
N_c = size(u_color,1);
Phi_c = [ones(N_c,1), (1./u_color), (1./(u_color.^2)), (1./(u_color.^3))];
phat_c = pinv(Phi_c) * y_color;
yhat_c = Phi_c*phat_c;

%% ZADANIE 1.1.3 PLOTS

wykres1=figure('Position',[0 0 1300 800]);
subplot(2,1,1)
plot(u_white, y_white,'o');
hold on
plot(u_white, yhat, 'r-','LineWidth', 2);
hold off
grid on;
legend('$(u_w,y_w)$','$\hat{y}_w = f(u,p)$','interpreter','latex','fontsize',12);
xlabel("$u$",'Interpreter','latex','FontSize',16);
ylabel("y",'Interpreter','latex','FontSize',16);
title('White Noise (LS)', 'Interpreter','latex','FontSize',15);

subplot(2,1,2)
plot(u_color, y_color,'o');
hold on
plot(u_color, yhat_c, 'r-','LineWidth', 2);
hold off
grid on;
legend('$(u_c,y_c)$','$\hat{y}_c = f(u,p)$','interpreter','latex','fontsize',12);
xlabel("$u$",'Interpreter','latex','FontSize',16);
ylabel("y",'Interpreter','latex','FontSize',16);
title('Color Noise (LS)', 'Interpreter','latex','FontSize',15);

%% ZADANIE 1.1.4 
N = 100;

%% SZUM BIAŁY co N-ta próbka
new_u_white = u_white(1:N:end);
new_y_white = y_white(1:N:end);

N_w = size(new_u_white,1);
Phi_N = [ones(N_w,1), (1./new_u_white), (1./(new_u_white.^2)), (1./(new_u_white.^3))];
phat_N = pinv(Phi_N) * new_y_white;
yhat_N = Phi_N*phat_N;

%% SZUM KOLOROWY co N-ta próbka
new_u_color = u_color(1:N:end);
new_y_color = y_color(1:N:end);

N_c = size(new_u_color,1);
Phi_c = [ones(N_c,1), (1./new_u_color), (1./(new_u_color.^2)), (1./(new_u_color.^3))];
phat_c = pinv(Phi_c) * new_y_color;
yhat_c = Phi_c*phat_c;

%% ZADANIE 1.1.4 PLOTS

wykres2=figure('Position',[0 0 1300 800]);
subplot(2,1,1)
plot(new_u_white, new_y_white,'o');
hold on
plot(new_u_white, yhat_N, 'r-','LineWidth', 2);
hold off
grid on;
legend('$(u_w,y_w)$','$\hat{y}_w = f(u,p)$','interpreter','latex','fontsize',12);
xlabel("$u$",'Interpreter','latex','FontSize',16);
ylabel("y",'Interpreter','latex','FontSize',16);
title('White Noise', 'Interpreter','latex','FontSize',15);

subplot(2,1,2)
plot(new_u_color, new_y_color,'o');
hold on
plot(new_u_color, yhat_c, 'r-','LineWidth', 2);
hold off
grid on;
legend('$(u_c,y_c)$','$\hat{y}_c = f(u,p)$','interpreter','latex','fontsize',12);
xlabel("$u$",'Interpreter','latex','FontSize',16);
ylabel("y",'Interpreter','latex','FontSize',16);
title('Color Noise', 'Interpreter','latex','FontSize',15);

%% ZADANIE 1.1.5 (Macierz kowariancji)
sigma2hat = sum((y_white - yhat).^2)/(2501-4);
PN = sigma2hat*pinv(Phi'*Phi);

% Przedziały ufnosci:
for i=1:length(PN)
PU1 = phat(i) - 1.96*sqrt(PN(i,i));
PU2 = phat(i) + 1.96*sqrt(PN(i,i));
fprintf("PRZEDZIAŁ UFNOŚCI DLA %.2f ESTYMATY",i);
fprintf("(%.2f ; %.2f)\n", round(PU1,2), round(PU2,2));
disp("--------------------------------------------");
end