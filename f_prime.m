function y=f_prime(F,x)
% Cálculo de derivada de la función no lineal
% y: derivada de la función con x
% F: tipo de de la función
% 0 --> logsig
% 1 --> tansig
if F==0
y=logsig(x).*(1-logsig(x));
elseif F==1
y=(tansig(x)+1).*(1-tansig(x));
else
y=[];
end