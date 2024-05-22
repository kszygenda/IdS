function val = RMSE(yref,y)
%RMSE Summary of this function goes here
% Root mean square error function
% compare two signals

%   Detailed explanation goes here
buf=0;
if length(yref)==length(y)
for i = 1:length(yref)
    buf = buf + abs((yref(i) - y(i))*(yref(i) - y(i)));
end
disp(["roznica miedzy sygnalami RMSE = " buf])
val = buf;
else
    disp("Sygnały są nierównej długości, zakończono operacje")
    val=0;
end
end

