clc; clear variables; close all;
% Simulink Data for simulation
tend = 1500;

G_trans = tf(0.5,[5 11 7 1]);


%% Zmienna wartość Tp
Tp_vec = [2 1 0.5 0.25];
M_vec = [15 30 60 120];
for k = 1:length(Tp_vec)
Tp = Tp_vec(k);
tend = 2001;
sigma2v = 0;
N=1001;
sim("Copy_of_AKident");

u = Zdata(1:N-1,1);
y = Zdata(1:N-1,2);
t = Zdata(1:N-1,3);

%"Oryginalna transmitancja oraz jej odpowiedź"
[g_org,~] = impulse(G_trans,t);

% 2.1.3 Wzory (10) oraz (11) 
M = M_vec(k);
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

%Estymaty odpowiedzi systemu, Wzor (12)
ghat_10 = (1/Tp)*pinv(R_uu)*r_yu';
%Wzor (11) + wzor (12)
ghat_11 = (1/Tp)*r_uu/r_uu(1);

if k == 1
Wykres2=figure('Position',[0 0 1600 1000]);
end
subplot(2,2,k)
plot(0:M-1,ghat_10,'LineWidth',3)
hold on
plot(0:M-1,ghat_11,'LineWidth',3)
plot(0:M-1,g_org(1:M),'LineWidth',3)
set(gca,"FontSize",12)
xlabel("probka [n]","FontSize",19,"Interpreter","latex")
ylabel("wartosc estymaty","FontSize",19,"Interpreter","latex")
title("Estymata odpowiedzi systemu dla $T_p$ = " + num2str(Tp),"FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
lgd = legend('$\hat{g_{10}}(n)$','$\hat{g_{11}}(n)$',"$g(n)$",'Interpreter','Latex');
fontsize(lgd,14,"points")
grid on

end
%% Zmiana wartości wariancji dla Tp = 1
Tp = 1;
wektor_var = [0 0.001 0.01 0.1];
for j = 1:length(wektor_var)
sigma2v = wektor_var(j);
N=1001;
sim("Copy_of_AKident");

u = Zdata(1:N-1,1);
y = Zdata(1:N-1,2);
t = Zdata(1:N-1,3);

[g_org,~] = impulse(G_trans,t);

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

%Estymaty odpowiedzi systemu, Wzor (12)
ghat_10 = (1/Tp)*pinv(R_uu)*r_yu';
%Wzor (11) + wzor (12)
ghat_11 = (1/Tp)*r_uu/r_uu(1);
if j == 1
Wykres3=figure('Position',[0 0 1600 1000]);
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
hold off
end


%% Estymata odpowiedzi skokowej obiektu

Tp = 1;
tend = 2001;
sigma2v = 0;
N=1001;
sim("Copy_of_AKident");

u = Zdata(1:N-1,1);
y = Zdata(1:N-1,2);
t = Zdata(1:N-1,3);


[h_org,~] = step(G_trans,t);
% 2.1.3 Wzory (10) oraz (11) 
M = 30;
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

%Estymaty odpowiedzi systemu, Wzor (12)
ghat_10 = (1/Tp)*pinv(R_uu)*r_yu';
%Wzor (11) + wzor (12)
ghat_11 = (1/Tp)*r_uu/r_uu(1);

h_hat = ghat_10*Tp;
Wykres3=figure('Position',[0 0 1600 1000]);

plot(0:M-1,h_hat,'LineWidth',3)
set(gca,"FontSize",12)
xlabel("probka [n]","FontSize",19,"Interpreter","latex")
ylabel("wartosc estymaty","FontSize",19,"Interpreter","latex")
title("Estymata odpowiedzi skokowej systemu","FontSize",22,"Interpreter","latex")
set(gca,"TickLabelInterpreter","latex")
lgd = legend('$\hat{h}(n)$','Interpreter','Latex');
fontsize(lgd,14,"points")
grid on
hold off