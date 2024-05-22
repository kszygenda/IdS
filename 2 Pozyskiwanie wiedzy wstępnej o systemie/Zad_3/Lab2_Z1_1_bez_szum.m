clc; clear variables; close all;
load("ProcessStepResponse.mat")
%%Wstępne dane wraz z wykresem odpowiedzi skokowej
t=S(:,1)';
h=S(:,2)';

Wykres1=figure('Position',[0 0 1200 800]);
plot(t,h,'LineWidth',3)
set(gca,"FontSize",12)
xlabel("czas [s]","FontSize",19,"Interpreter","latex")
ylabel("wartosc odpowiedzi skokowej $h(t)$","FontSize",19,"Interpreter","latex")
title("Odpowiedz skokowa obiektu","FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
grid on

%% Szacowanie parametrów modelu

K_est = h(end)/1;
T50 = 11.5;
T90 = 22.7;
T_iloraz = T90/T50;
disp(["T90/T50=" T_iloraz]);
% Z otrzymanej wartości oszacowano rząd dynamiki p=3
p=3;
% Z kolumny trzeciej tabeli aproksymacji
T_k3 = T90/5.32;
% Z kolumny trzeciej tabeli aproksymacji
T_k2 = T50/2.67;


s = tf('s');
% Dwie transmitancje, z roznymi estymatami stałej czasowej 
G_k2 = K_est / ((T_k2 * s + 1)^p) ;
G_k3 = K_est / ((T_k3 * s + 1)^p) ;

% Odpowiedzi czasowe obiektu
u = ones(1,length(t));

% odpowiedzi skokowe
h_Gk2 = lsim(G_k2,u,t);
h_Gk3 = lsim(G_k3,u,t);
% Odpowiedzi impulsowe
[g_Gk2,~] = impulse(G_k2,t);
[g_Gk3,~] = impulse(G_k3,t);
% oszacowanie odpowiedzi impulsowej obiektu
g=[0];
for i = 2:length(h)
    buf = ( h(i) - h(i-1) ) / ( t(i) - t(i-1) );
    g=[g buf];
end

Wykres2=figure('Position',[0 0 1200 800]);
plot(t,h,'LineWidth',3)
hold on
plot(t,h_Gk2,"LineWidth",3,'LineStyle','--')
plot(t,h_Gk3,"LineWidth",3,'LineStyle','--')
set(gca,"FontSize",12)
xlabel("czas [s]","FontSize",19,"Interpreter","latex")
ylabel("wartosc odpowiedzi skokowej $h(t)$","FontSize",19,"Interpreter","latex")
title("Odpowiedz skokowe obiektow","FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
lgd = legend('$h(t)$','$h_{Gk2}(t)$','$h_{Gk3}(t)$','Interpreter','Latex');
fontsize(lgd,14,"points")
grid on

Wykres3=figure('Position',[0 0 1200 800]);
plot(t,g,'LineWidth',3)
hold on
plot(t,g_Gk2,"LineWidth",3,'LineStyle','--')
plot(t,g_Gk3,"LineWidth",3,'LineStyle','--')
set(gca,"FontSize",12)
xlabel("czas [s]","FontSize",19,"Interpreter","latex")
ylabel("wartosc odpowiedzi skokowej $h(t)$","FontSize",19,"Interpreter","latex")
title("Odpowiedz impulsowe obiektow","FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
lgd = legend('$g(t)$','$g_{Gk2}(t)$','$g_{Gk3}(t)$','Interpreter','Latex');
fontsize(lgd,14,"points")
grid on