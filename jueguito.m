clear all   % Inicializa todas las variables
close all   % Cierra todas las ventanas, archivos y procesos abiertos
clc         % Limpia la ventana de comandos
objects = imaqfind %find video input objects in memory
delete(objects) %delete a video input object from memory
%--------------------------------------------------------------------------
%-- 2. Configuracion de la captura de video -------------------------------
%-------------------------------------------------------------------------
vid=videoinput('winvideo',1,'YUY2_640x480');% Se captura un stream de video usando videoinput, con argumento
% Se configura las opciones de adquision de video
set(vid,'ReturnedColorSpace','rgb');%la imagen del video se va a tomar en modo RGB
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);
start(vid);
x=100;
yr=randi(300)*-1;
yg=randi(300)*-1;
yb=randi(300)*-1;

alto=100;ancho=100;
guitarraRead=imread('Guitarra.png');guitarraRead=imresize(guitarraRead,[480,640]);
[redNoteRead,map1,redTrans]=imread('rojo.png');
[greenNoteRead,map2,greenTrans]=imread('verde.png');
[blueNoteRead,map3,blueTrans]=imread('azul.png');
while( vid.FramesAcquired <= 10000)       
    cdt0 = getsnapshot(vid);%Capturamos la imagen de la c�mara
    cdt = flip(cdt0,2);%Aplicamos la funci�n flip, que nos permite rotar la imagen y as� evitar el efecto de espejo
    cdt2 = cdt;%Realizamos una copia de la imagen  
    
    juego= (guitarraRead*1.5)+(cdt2*0.8); 
    imshow(juego);
    
    hold on
    redNote=image(x,yr,redNoteRead);set(redNote, 'AlphaData', redTrans);
    greenNote=image(x+120,yg,greenNoteRead);set(greenNote, 'AlphaData', greenTrans);
    blueNote=image(x+240,yb,blueNoteRead);set(blueNote, 'AlphaData', blueTrans);
    if(yr>640)
        yr=randi(150)*-1;
    end
    if(yr>640)
        yg=randi(150)*-1;
    end
    if(yr>640)
        yb=randi(150)*-1;
    end
    yr=yr+5;
    yg=yg+5;
    yb=yb+5;
    
end

%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------