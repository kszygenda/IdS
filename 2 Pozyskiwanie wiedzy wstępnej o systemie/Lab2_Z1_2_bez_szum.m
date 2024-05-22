clc; clear variables; close all;
load("ProcessStepResponse.mat")
%%Wstępne dane wraz z wykresem odpowiedzi skokowej
t=S(:,1)';
h=S(:,2)';
g=[0];
for i = 2:length(h)
    buf = ( h(i) - h(i-1) ) / ( t(i) - t(i-1) );
    g=[g buf];
end

Wykres1=figure('Position',[0 0 1200 800]);
plot(t,h,'LineWidth',3)
hold on
plot(t,g,'LineWidth',3)
set(gca,"FontSize",12)
xlabel("czas [s]","FontSize",19,"Interpreter","latex")
ylabel("wartosc odpowiedzi $h(t)$ i $g(t)$","FontSize",19,"Interpreter","latex")
title("Odpowiedz skokowa obiektu","FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
grid on

%% Szacowanie parametrów modelu
K_est = h(end)/1;
[ag,indeks] = max(g);
yg = h(indeks);
tg = t(indeks);
% ze wzorów sg = yg = h(tg)
T0 = (ag*tg - yg)/ag;
T = 1*K_est/ag;

% Model
s = tf('s');
G_est = K_est / (T*s + 1) *exp(-s*T0);
% odpowiedzi modelu
u = ones(1,length(t));
% Odpowiedź skokowa
h_est = lsim(G_est,u,t);
% Odpowiedź impulsowa
[g_est,~] = impulse(G_est,t);

Wykres2=figure('Position',[0 0 1200 800]);
plot(t,h,'LineWidth',3)
hold on
plot(t,h_est,'LineWidth',3,'LineStyle','--')
set(gca,"FontSize",12)
xlabel("czas [s]","FontSize",19,"Interpreter","latex")
ylabel("wartosc odpowiedzi $h(t)$ oraz $\hat{h}(t)$","FontSize",19,"Interpreter","latex")
title("Odpowiedz skokowa obiektu","FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
lgd = legend('$h(t)$','$\hat{h}(t)$','Interpreter','Latex');
fontsize(lgd,14,"points")
grid on

Wykres3=figure('Position',[0 0 1200 800]);
plot(t,g,'LineWidth',3)
hold on
plot(t,g_est,'LineWidth',3,'LineStyle','--')
set(gca,"FontSize",12)
xlabel("czas [s]","FontSize",19,"Interpreter","latex")
ylabel("wartosc odpowiedzi $g(t)$ oraz $\hat{g}(t)$","FontSize",19,"Interpreter","latex")
title("Odpowiedz impulsowa obiektu","FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
lgd = legend('$g(t)$','$\hat{g}(t)$','Interpreter','Latex');
fontsize(lgd,14,"points")
grid on