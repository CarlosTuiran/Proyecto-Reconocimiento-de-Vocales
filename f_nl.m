function Y=f_nl(F,X)
%Función no lineal
% F: tipo de función 0--> logsig
% 1--> tansig
% X: datos de entrada
% Y: salida de la función
if F== 0
Y=logsig(X);
elseif F==1
Y=tansig(X);
else
Y=[];
end