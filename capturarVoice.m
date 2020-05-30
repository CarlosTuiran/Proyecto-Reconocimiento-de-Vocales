%Configuración de la tarjeta de sonido para la adquisición de audio

duration=2; %Tiempo duración de grabación
Fs=16000; %Fs=16000Hz Frecuencia
v = audiorecorder(Fs, 24, 1);
v.StartFcn = 'disp(''   iniciando grabación'')';
v.StopFcn = 'disp(''   terminando grabación'')';


%---------------Adquisición de datos y base de datos---------------%
n_pal=5; %número letras a pronunciar
n_rep=3; %número de repeticiones
words=cell(1,n_pal); %Matriz de palabras
%---------------------------Grabar datos---------------------------%
for s=1:n_pal
 %...
 %<MATRIZ DE letras SEGÚN SE VAN ADQUIRIENDO>
 %...
 for n=1:n_rep
    input('Enter para Empezar la Grabacion');
    recordblocking(v, duration);  %Inicio de adquisición
    x = v.getaudiodata();
    % x2 es la señal normalizada %
	mwad=max(x);
	mwid=min(x);
	x3=x/(max(mwad,mwid));

	% Cálculo de potencia %
	x2=x3;
	gamma=1000/(Fs*.2);
	E(1)=0.0;
	for i=2:length(x2)
		E(i)=(1-gamma)*E(i-1)+gamma*x2(i)*x2(i)/0.00000000052998;
	end
	% Cálculo de inicio y final de la señal de voz %
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
	% PX inicio y final de la potencia %
	PX=x2(Id1:Id11);

	% Señal acotada %
	signalAcotada=x(Id1:Id11);

	 %...
	 %<PROCESADO DE LOS DATOS>
	 %...
	 %Guardar archivo
	archivo=['dataVoice\' ...
		num2str(n) '_' num2str(s) '.wav'];
	audiowrite(archivo,signalAcotada,Fs);
	subplot(2,1,1);plot(x);
	subplot(2,1,2);plot(PX);
    input('Grabacion Finalizada enter para continuar');

	end
end
 delete(v); clear v;