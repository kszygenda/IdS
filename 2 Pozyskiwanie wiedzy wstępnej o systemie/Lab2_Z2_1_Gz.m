clc; clear variables; close all;
% Simulink Data for simulation
Tp = 1;
tend = 1500;
G_trans_z = tf(2,[1 -0.7],Tp);
wektor_var = [0 0.001 0.01 0.1];
for j = 1:length(wektor_var)
sigma2v = wektor_var(j);
N=1001;
sim("AKident.mdl");

u = Zdata(1:N-1,1);
y = Zdata(1:N-1,2);
t = Zdata(1:N-1,3);

if j == 1
[g_org,~] = impulse(G_trans_z,t);
Wykres1=figure('Position',[0 0 1200 800]);
plot(t,u,'LineWidth',3)
hold on
plot(t,y,'LineWidth',3)
set(gca,"FontSize",12)
xlabel("probka [n]","FontSize",19,"Interpreter","latex")
ylabel("wartosc sygnalow $u(n)$ i $y(n)$","FontSize",19,"Interpreter","latex")
title("Sygnaly symulacji $u(n)$ i $y(n)$","FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
lgd = legend('$u(n)$','$y(n)$','Interpreter','Latex');
fontsize(lgd,14,"points")
grid on
end
% 2.1.3 Wzory (10) oraz (11) 
M = 20;
%Wzor (10) - obliczenia korelacji
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

%Estymaty odpowiedzi systemu
ghat_10 = pinv(R_uu)*r_yu';
%Wzor (11)
ghat_11 = r_yu/r_uu(1);
if j == 1
Wykres2=figure('Position',[0 0 1600 1000]);
end
subplot(2,2,j)
plot(0:M-1,ghat_10,'LineWidth',3)
hold on
plot(0:M-1,ghat_11,'LineWidth',3)
plot(0:M-1,g_org(1:M),'LineWidth',3)
set(gca,"FontSize",12)
xlabel("probka [n]","FontSize",19,"Interpreter","latex")
ylabel("wartosc estymaty","FontSize",19,"Interpreter","latex")
title("Estymata odpowiedzi systemu dla $\sigma^2$ = " + num2str(sigma2v),"FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
lgd = legend('$\hat{g_{10}}(n)$','$\hat{g_{11}}(n)$',"$g(n)$",'Interpreter','Latex');
fontsize(lgd,14,"points")
grid on
end
