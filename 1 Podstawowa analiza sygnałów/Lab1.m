clc; clear variables; close all;
%% Variables
Tp = 1;
N = 1000;
% %% Zadanie 1.1
% sim("NoiseComparison.mdl");
% t = NoiseSig(:,1); % Czas
% e = NoiseSig(:,2); % Szum biały
% v = NoiseSig(:,3); % Szum kolorowy
%% Zadanie 1.2 
load("StochasticProcess.mat");
SP = StochasticProcess;
Tp_vec = SP(1,:);
pr1 = SP(21,:);
pr2 = SP(37,:);
pr3 = SP(300,:);
pr4 = SP(500,:);
m1=mean(pr1);
s1=std(pr1,1);
%% SREDNIA PO CZASIE
wykres1 = figure('Position',[10 10 1200 800]);
subplot(2,2,1)
plot(Tp_vec,pr1);

title("realizacja 1");
grid on
subplot(2,2,2)
plot(Tp_vec,pr2);
title("realizacja 2");
grid on
subplot(2,2,3)
plot(Tp_vec,pr3);
title("realizacja 3");
grid on
subplot(2,2,4)
plot(Tp_vec,pr4);
title("realizacja 4");
grid on


%% SREDNIA PO REALIZACJACH
rel1 = SP(2:end,51);
rel2 = SP(2:end,151);
wykres2 = figure('Position',[10 10 1200 800]);
title("Kolumny, estymaty po realizacjach")
subplot(2,1,1)
plot(1:500,rel1)
grid on
title("Kolumny, estymaty po realizacji 50")
subplot(2,1,2)
plot(1:500,rel2)
grid on
title("Kolumny, estymaty po realizacji 150")
sr1 = mean(rel1)
std1 = std(rel1,1)

%% 
S = StochasticProcess(2:end,:);

M = size(S,1);
N = size(S,2);

mr = zeros(1,N);
mc = zeros(1,M);

%Srednia po realizacjach 
for i = 1:N
mr(i) = 1/M*(sum(S(:,i)));
end
%Dla danej realizacji, srednia po czasie
for j = 1:M
mc(j) = 1/N*(sum(S(j,:)));
end

wykres3 = figure('Position',[10 10 1200 800]);
plot(Tp_vec,mr);
hold on
plot(1:length(mc),mc);
grid on
legend('po realizacjach','po czasie');
title('estymaty wartosci oczekiwanych');


% Wariancja dla danego czasu i realizacji
vr = zeros(1,N);
vc = zeros(1,M);
% War dla realizacji
for n = 1:N
vr(n) = 1/M*(sum(S(:,n) - mr(n)).^2 );
end

% War dla czasu
for i = 1:M
vc(i) = 1/N*(sum(S(i,:) - mc(i)).^2 );
end

wykres4 = figure('Position',[10 10 1200 800]);
plot(Tp_vec,vr);
hold on
plot(1:length(mc),vc);
grid on
legend('po realizacjach','po czasie');
title('estymaty Wariancji');