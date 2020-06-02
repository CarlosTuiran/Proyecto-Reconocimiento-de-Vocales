clear all;
clc
N=15;
% Recuperando el banco de datos %
[a1,fr1]=audioread ('1_1');
[a2,fr2]=audioread ('1_2');
[a3,fr3]=audioread ('1_3');
[e1,fr1]=audioread ('2_1');
[e2,fr2]=audioread ('2_2');
[e3,fr3]=audioread ('2_3');
[i1,fr1]=audioread ('3_1');
[i2,fr2]=audioread ('3_2');
[i3,fr3]=audioread ('3_3');
[o1,fr1]=audioread ('4_1');
[o2,fr2]=audioread ('4_2');
[o3,fr3]=audioread ('4_3');
[u1,fr1]=audioread ('5_1');
[u2,fr2]=audioread ('5_2');
[u3,fr3]=audioread ('5_3');



% Coeficientes en frecuencia de comandos %
[lpca1,ga1]=lpc(a1,N);
[lpca2,ga2]=lpc(a2,N);
[lpca3,ga3]=lpc(a3,N);
[lpce1,ge1]=lpc(e1,N);
[lpce2,ge2]=lpc(e2,N);
[lpce3,ge3]=lpc(e3,N);
[lpci1,gi1]=lpc(i1,N);
[lpci2,gi2]=lpc(i2,N);
[lpci3,gi3]=lpc(i3,N);
[lpco1,go1]=lpc(o1,N);
[lpco2,go2]=lpc(o2,N);
[lpco3,go3]=lpc(o3,N);
[lpcu1,gu1]=lpc(u1,N);
[lpcu2,gu2]=lpc(u2,N);
[lpcu3,gu3]=lpc(u3,N);


t=2:11;
pa1=(abs(lpca1(:,t)));
pa2=(abs(lpca2(:,t)));
pa3=(abs(lpca3(:,t)));
pe1=(abs(lpce1(:,t)));
pe2=(abs(lpce2(:,t)));
pe3=(abs(lpce3(:,t)));
pi1=(abs(lpci1(:,t)));
pi2=(abs(lpci2(:,t)));
pi3=(abs(lpci3(:,t)));
po1=(abs(lpco1(:,t)));
po2=(abs(lpco2(:,t)));
po3=(abs(lpco3(:,t)));
pu1=(abs(lpcu1(:,t)));
pu2=(abs(lpcu2(:,t)));
pu3=(abs(lpcu3(:,t)));



N=16; % neuronas de entrada (incluido el BIAS) %
L=35; % neuronas de la capa oculta (incluido el BIAS) %
M=6; % neuronas de salida %
NT=15; % patrones de entrenamiento %
NI=100000; % # maximo de iteraciones (epochs) %
epsilon=0.005; % error cuadratico medio requerido %
Ws=(2*rand(N,L-1))-1;
Vs=(2*rand(L,M))-1;

% Datos de entrenamiento %
PE=[pa1; pa2; pa2;
pe1; pe2; pe2;
pi1; pi2; pi2;
po1; po2; po2;
pu1; pu2; pu2;];
% Salida deseada de cada uno %
D=[
 1 -1 -1 -1 -1 -1;
 1 -1 -1 -1 -1 -1;
 1 -1 -1 -1 -1 -1;
 -1 1 -1 -1 -1 -1;
 -1 1 -1 -1 -1 -1;
 -1 1 -1 -1 -1 -1;
 -1 -1 1 -1 -1 -1;
 -1 -1 1 -1 -1 -1;
 -1 -1 1 -1 -1 -1;
 -1 -1 -1 1 -1 -1;
 -1 -1 -1 1 -1 -1;
 -1 -1 -1 1 -1 -1;
 -1 -1 -1 -1 1 -1;
 -1 -1 -1 -1 1 -1;
 -1 -1 -1 -1 1 -1;
];
% for principal no. de iteraciones para entrenamiento %
for k=1:NI
	Err=0;
	for i=1:NT;
		if k<=70
			miu=0.3;
		end
		if k>70&k<=200 % Factor de convergencia %
			miu=0.1;
		end
		if k>200
			miu=0.05;
		end
		X=[1.0,PE(i,:)]; %BIAS y patrones de entrenamiento %
		%Calculo de salida de la red %
		U_hat=X*Ws;
		U=[1.0,f_nl(1,U_hat)]; %agrega BIAS %
		Y_hat=U*Vs;
		Y=f_nl(1,Y_hat);
		E=D(i,:)-Y;
		% Adaptación %
		delta1=E.*f_prime(1,Y_hat);
		Vs=Vs+miu*U'*delta1;
		S=Vs*delta1';
		delta2=S(2:L)'.*f_prime(1,U_hat);
		Ws=Ws+miu*X'*delta2;
		Err=Err+E*E';
	end % i
	Err=Err/(NT*M);
	vec_err(1,k)=Err;
	fprintf(1,'Err=%4.9f ==> %d\n',Err,k);
	if Err<epsilon
		break;
	end
end % k
for i=1:NT
	X=[1.0,PE(i,:)];
	U_hat=X*Ws;
	U=[1.0,f_nl(1,U_hat)];
	Y_hat=U*Vs;
	Y=hardlims(f_nl(1,Y_hat));
	fprintf(1,'Salida de la Red: %d %d %d %d %d %d \n\n',Y(1),Y(2),Y(3),Y(4),Y(5),Y(6));
end
%revisar tamaño de Ws y Vs
%disp('Ws');
%disp(Ws);
%disp('Vs');
%disp(Vs);

fidfun=fopen('Wij.dat','w');
fprintf(fidfun,'%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f\n',Ws');
fclose(fidfun);
fidfun=fopen('Vij.dat','w');
fprintf(fidfun,'%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f %6.4f
	%6.4f %6.4f %6.4f %6.4f %6.4f\n',Vs');
fclose(fidfun);