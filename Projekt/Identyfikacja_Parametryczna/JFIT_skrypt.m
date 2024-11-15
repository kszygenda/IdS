clc; 

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