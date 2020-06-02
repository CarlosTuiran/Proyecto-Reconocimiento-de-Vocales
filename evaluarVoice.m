clc
duration=2; %Tiempo duración de grabación
Fs=16000; %Fs=16000Hz Frecuencia
v = audiorecorder(Fs, 24, 1);
v.StartFcn = 'disp(''   iniciando grabación'')';
v.StopFcn = 'disp(''   terminando grabación'')';
input('Enter para Empezar la Grabacion');
recordblocking(v, duration);  %Inicio de adquisición
y = v.getaudiodata();

fr=16000
x=y;
% x2 es la señal normalizada %
mwad=max(x);
mwid=min(x);
x3=x/(max(mwad,mwid));
% Cálculo de potencia %
x2=x3;
gamma=1000/(fr*.2);
E(1)=0.0;
for i=2:length(x2)
	E(i)=(1-gamma)*E(i-1)+gamma*x2(i)*x2(i)/0.00000000052998;
end
% Calculo de inicio y final de la señal de voz %
maxp=max(E);
M=(maxp*.2);
N=(maxp*.9);
er=0;
for i=1: length(E)
	if E(i)>=M
		Id2=i;
		break;
	end
end
for j=Id2:-1:1
	if E(j)<=N
		Id1=j;
		er=er+1;
		break;
	end
	if er==0
	Id1=Id2;
	end
end
elz=0;
for i=length(E):-1:1
	if E(i)>=M
		Id22=i;
		break;
	end
end
for j=Id22:1:length(E)
	if E(j)<=N
		Id11=j;
		elz=elz+1;
		break;
	end
	if elz==0
		Id11=Id22;
	end
end
PX=x2(Id1:Id11); %PX inicio y final de la potencia %
xiyf=x(Id1:Id11); %xin0 señal acotada %
subplot(2,1,1);plot(x);
subplot(2,1,2);plot(PX);

N=15;
c1=xiyf;
[lpcc1,ga2]=lpc(c1,N);
t=2:11;
c11=(abs(lpcc1(:,t)));
N=16; %neuronas de entrada (incluido el BIAS)
L=35; %neuronas de la capa oculta (incluido el BIAS)
M=6; %neuronas de salida
NT=1; %patrones de entrenamiento
epsilon=0.005; %error cuadrático medio requerido
PE=[c11];
fidfun=fopen('Wij.dat','r');
Ws=fscanf(fidfun,'%f',[L-1,inf]);
Ws=Ws';
fclose(fidfun);
fidfun=fopen('Vij.dat','r');
Vs=fscanf(fidfun,'%f',[M,inf]);
Vs=Vs';
fclose(fidfun);
for i=1:1
	X=[1.0,PE(i,:)];
	U_hat=X*Ws;
	U=[1.0,f_nl(1,U_hat)];
	Y_hat=U*Vs;
	Y=hardlims(f_nl(1,Y_hat));
	fprintf(1,'Salida de la Red: %d %d %d %d %d %d \n\n',Y(1),Y(2),Y(3),Y(4),Y(5),Y(6));
end
% Respuestas a la evaluación %
if (Y~=[1 -1 -1 -1 -1 -1])|(Y~=[-1 1 -1 -1 -1 -1] | |(Y~=[-1 -1 1 -1 -1 -1] |(Y~=[-1 -1 -1 1 -1 -1] |(Y~=[-1 -1 -1 -1 1 -1]);
	fprintf('error vocal no identificada');
end
if (Y==[1 -1 -1 -1 -1 -1]);
	fprintf('Vocal A');
end
if (Y==[-1 1 -1 -1 -1 -1]);
	fprintf('Vocal E');
end
if (Y==[-1 -1 1 -1 -1 -1]);
	fprintf('Vocal I');
end
if (Y==[-1 -1 -1 1 -1 -1]);
	fprintf('Vocal O');
end
if (Y==[-1 -1 -1 -1 1 -1]);
	fprintf('Vocal U');
end