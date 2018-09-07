
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
% set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);
start(vid);
x=100;
%------Posiciones random iniciales de las notas musicales.
yr=randi(300)*-1;
yr1=randi(500)*-1;
yg=randi(300)*-1;
yg1=randi(500)*-1;
yb=randi(300)*-1;
yb1=randi(500)*-1;
%
alto=100;ancho=100;
guitarraRead=imread('Guitarra.png');guitarraRead=imresize(guitarraRead,[480,640]);
[redNoteRead,map1,redTrans]=imread('rojo.png');
[greenNoteRead,map2,greenTrans]=imread('verde.png');
[blueNoteRead,map3,blueTrans]=imread('azul.png');
puntos=20;
while( vid.FramesAcquired <= 10000)       
    cdt0 = getsnapshot(vid);%Capturamos la imagen de la cámara
    cdt = flip(cdt0,2);%Aplicamos la función flip, que nos permite rotar la imagen y así evitar el efecto de espejo
    cdt2 = cdt;%Realizamos una copia de la imagen  
    
    %--------------------get Pajuela
    
    r = cdt(:,:,1);%Obtenemos la capa que contiene el color rojo de la imagen
    g = cdt(:,:,2);%Obtenemos la capa que contiene el color verde de la imagen
    b = cdt(:,:,3);%Obtenemos la capa que contiene el color azul de la imagen
    justGreen = g - b/2 - r/2;%A la capa verde le restamos las capas roja y azul
    %dividas entre 2 cada una, esto con la finalidad de obtener de la
    %imagen el color verde presente en la misma.
    bw = justGreen > 33;%Binarizamos la imagen, obteniendo así los objetos
    %donde el color verde se encuentre presente
    cdt = bwareaopen(bw, 20);%La Funcion bwareaopen elimina todos los 
    %componentes conectados (objetos) que tienen menos de Ppíxeles de la 
    %imagen binaria BW, así obtenemos todos los objetos que cumplan con la
    %mascara
    
    %---------------------------------------
    juego= (guitarraRead*1.5)+(cdt2*0.8); 
   
   figure(1);imshow(juego);
    hitBoxR=[x,yr,ancho,alto];
    hitBoxR1=[x,yr1,ancho,alto];
    hitBoxG=[x+120,yg,ancho,alto];
    hitBoxG1=[x+120,yg1,ancho,alto];
    hitBoxB=[x+240,yb,ancho,alto];
    hitBoxB1=[x+240,yb1,ancho,alto];
    
 
    hold on
    redNote=image(x,yr,redNoteRead);set(redNote, 'AlphaData', redTrans);
    greenNote=image(x+120,yg,greenNoteRead);set(greenNote, 'AlphaData', greenTrans);
    blueNote=image(x+240,yb,blueNoteRead);set(blueNote, 'AlphaData', blueTrans);
    
    redNote1=image(x,yr1,redNoteRead);set(redNote1, 'AlphaData', redTrans);
    greenNote1=image(x+120,yg1,greenNoteRead);set(greenNote1, 'AlphaData', greenTrans);
    blueNote1=image(x+240,yb1,blueNoteRead);set(blueNote1, 'AlphaData', blueTrans);
    hold off
    s  = regionprops(cdt, {'centroid','area'});%Obtenemos las propiedades 'centroide' y 'área' de cada objeto que este blanco en BW
    if isempty(s)%Condicional que se encargará de reconocer si el vector con objetos 
        %que cumplen con la mascara de reconocimiento, se encuentra vacio.
        
    else
        
        [~, id] = max([s.Area]);  %Obtenemos el ID del objeto cuya área sea la mayor en el vector de objetos
        
        xc = s(id).Centroid(1) - 5;%Coordenada en X para el CUADRO que identificará al jugador
        yc = s(id).Centroid(2) - 5;%Coordenada en Y para el CUADRO que identificará al jugador
        p = [xc, 380, 13, 13];%Creación del vector posición para el jugador
        r = rectangle('Position',p,'EdgeColor','b','LineWidth',2);   
        
        if bboxOverlapRatio(p,hitBoxR)>0
         yr = -100;
         puntos=puntos +10;
     end
     if bboxOverlapRatio(p,hitBoxR1)>0
         yr1 = -100;
         puntos=puntos +10;
     end
     if bboxOverlapRatio(p,hitBoxG)>0
         yg = -100;
         puntos=puntos +10;
     end
     if bboxOverlapRatio(p,hitBoxG1)>0
         yg1 = -100;
         puntos=puntos +10;
     end
     
     if bboxOverlapRatio(p,hitBoxB)>0
         yb = -100;
         puntos=puntos +10;
     end
     if bboxOverlapRatio(p,hitBoxB1)>0
         yb1 = -100;
         puntos=puntos +10;
     end
        
    end
     %Analizar colisiones
     
    
    
    
    %Actualización de posición en y de las notas musicales
    if(yr>640)
        yr=randi(150)*-1;
    end
    if(yg>640)
        yg=randi(150)*-1;
    end
    if(yb>640)
        yb=randi(150)*-1;
    end
    if(yr>640)
        yr1=randi(150)*-1;
    end
    if(yg1>640)
        yg1=randi(150)*-1;
    end
    if(yb1>640)
        yb1=randi(150)*-1;
    end
    yr=yr+5;
    yg=yg+5;
    yb=yb+5;
    yr1=yr1+5;
    yg1=yg1+5;
    yb1=yb1+5;
    flushdata(vid,'triggers');
end
close all;
%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------