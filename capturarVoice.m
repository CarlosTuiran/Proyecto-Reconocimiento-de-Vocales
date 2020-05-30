%Configuración de la tarjeta de sonido para la adquisición de audio

duration=1; %Tiempo duración de grabación
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
    y = v.getaudiodata();
    
    input('Grabacion Finalizada enter para continuar');
 %...
 %<PROCESADO DE LOS DATOS>
 %...
 %Guardar archivo
 archivo=['dataVoice\' ...
num2str(n) '_' num2str(s) '.wav'];
 audiowrite(archivo,y,Fs);
 end
end
 delete(v); clear v;