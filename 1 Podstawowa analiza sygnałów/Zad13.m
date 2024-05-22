clc; clear variables; close all;
%% 1.3.1 Parametry symulacji
Tp=0.001; % okres próbkowania 

N=2000; % liczba próbek (?)

H = tf(0.1,[1 -0.9],Tp); %Transmitancja dyskretna

tn = linspace(0,N-1,N)*Tp; % wektor czasu dyskretnego

std = 1; %Odchylenie standardowe (zakres 0.8-1)

%Sygnały (Zdefiniowane w skrypcie)
e = std * randn(1,N);
x = sin(2*pi*5*tn);
y = sin(2*pi*5*tn) + e;
v = lsim(H,e,tn)';

% Wykres
wykres1=figure('Position',[0 0 1300 800]);
plot(tn,e,'MarkerSize',6);
hold on
plot(tn,x,'MarkerSize',6);
plot(tn,y,'MarkerSize',6);
plot(tn,v,'MarkerSize',6);
lgd = legend('e','x','y','v','interpreter','latex');
grid on
ylabel('wartosci sygnalow','Interpreter','latex','FontSize',18)
xlabel('$nT_p$','FontSize',18,'Interpreter','latex');
title('Przebiegi sygnalow','FontSize',20,'Interpreter','latex');
fontsize(lgd,14,"points")

%% 1.3.2 Korelacje i kowariancje
xkor = []; %Bufory do pętli
ykor = [];
ekor = [];
vkor = [];
for tau = 0:1:N-1
    xkor = [xkor Korelacja([x' x'],tau)];
    ykor = [ykor Korelacja([y' y'],tau)];
    ekor = [ekor Korelacja([e' e'],tau)];
    vkor = [vkor Korelacja([v' v'],tau)];
end
wykres2=figure('Position',[0 0 1300 800]);
plot(tn/Tp,ekor,'Marker','.','LineStyle','none','MarkerSize',6);
hold on
plot(tn/Tp,xkor,'Marker','.','LineStyle','none','MarkerSize',6);
plot(tn/Tp,ykor,'Marker','.','LineStyle','none','MarkerSize',6);
plot(tn/Tp,vkor,'Marker','.','LineStyle','none','MarkerSize',6);
lgd = legend('e kor','x kor','y kor','v kor','interpreter','latex');
grid on
xlabel('$\tau$','FontSize',18,'Interpreter','latex');
ylabel('Wartosci autokorelacji','FontSize',18,'Interpreter','latex');
title('Przebiegi autokorelacji','FontSize',20,'Interpreter','latex');
fontsize(lgd,14,"points")

%% 1.3.2 - 1.3.4 Przebieg estymaty funkcji autokorelacji

xkor = []; %Bufory do pętli
ykor = [];
ekor = [];
vkor = [];
%Obliczanie autokorelacji 
for tau = -(N-1):1:N-1
    xkor = [xkor Korelacja([x' x'],tau)];
    ykor = [ykor Korelacja([y' y'],tau)];
    ekor = [ekor Korelacja([e' e'],tau)];
    vkor = [vkor Korelacja([v' v'],tau)];
end
%Obliczanie autokorelacji obciazonej (?)
xkorob = []; %Bufory do pętli
ykorob = [];
ekorob = [];
vkorob = [];
for tau2 = -(N-1):1:N-1
    xkorob = [xkorob Korelacjaob([x' x'],tau2)];
    ykorob = [ykorob Korelacjaob([y' y'],tau2)];
    ekorob = [ekorob Korelacjaob([e' e'],tau2)];
    vkorob = [vkorob Korelacjaob([v' v'],tau2)];
end

% Wykresy i bufory
Tau_vec = -(N-1):1:N-1;
buf_vec=[xkor;ykor;ekor;vkor];
buf_vec2=[xkorob;ykorob;ekorob;vkorob];
name_vec=["Autokorelacja x" "Autokorelacja y" "Autokorelacja e" "Autokorelacja v"];


%Przedstaw estymator obciazony i nieobciazony
roznica=1; %!!!!!!!!!!!!!!
%Pętla wykresowa
wykres3=figure('Position',[0 0 1300 800]);
for i = 1:4
subplot(2,2,i)
plot(Tau_vec,buf_vec(i,:),'Marker','.','LineStyle','none','MarkerSize',6);
xlabel('$\tau$','FontSize',18,'Interpreter','latex');
ylabel('Wartosci autokorelacji','FontSize',18,'Interpreter','latex');
title(name_vec(i),'FontSize',20,'Interpreter','latex');
grid on
if roznica==1
    hold on
    plot(Tau_vec,buf_vec2(i,:),'Marker','.','LineStyle','none','MarkerSize',6);
    lgd = legend('estymator nieobciazony','estymator obciazony','interpreter','latex');
    fontsize(lgd,10,'points');
end
end

%% 1.3.5
yxkor = [];
yxkorob = [];
for tau3 = -(N-1):1:N-1
    yxkor = [yxkor Korelacja([x' y'],tau3)];
    yxkorob = [yxkorob Korelacjaob([x' y'],tau3)];
end

wykres4=figure('Position',[0 0 1300 800]);
plot(Tau_vec,yxkor,'Marker','.','LineStyle','none','MarkerSize',6);
hold on
plot(Tau_vec,yxkorob,'Marker','.','LineStyle','none','MarkerSize',6);
lgd = legend('estymator nieobciazony','estymator obciazony','interpreter','latex');
fontsize(lgd,12,'points');
xlabel('$\tau$','FontSize',18,'Interpreter','latex');
ylabel('Wartosci korelacji $r_{xy}(\tau)$','FontSize',18,'Interpreter','latex');
title('Przebiegi korelacji $r_{xy}(\tau)$','FontSize',20,'Interpreter','latex');
grid on

yxkor = [];
yxkorob = [];
for tau3 = -(N-1):1:N-1
    yxkor = [yxkor Korelacja([y' x'],tau3)];
    yxkorob = [yxkorob Korelacjaob([y' x'],tau3)];
end

wykres5=figure('Position',[0 0 1300 800]);
plot(Tau_vec,yxkor,'Marker','.','LineStyle','none','MarkerSize',6);
hold on
plot(Tau_vec,yxkorob,'Marker','.','LineStyle','none','MarkerSize',6);
lgd = legend('estymator nieobciazony','estymator obciazony','interpreter','latex');
fontsize(lgd,12,'points');
xlabel('$\tau$','FontSize',18,'Interpreter','latex');
ylabel('Wartosci korelacji $r_{yx}(\tau)$','FontSize',18,'Interpreter','latex');
title('Przebiegi korelacji $r_{yx}(\tau)$','FontSize',20,'Interpreter','latex');
grid on
