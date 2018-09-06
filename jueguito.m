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
while( vid.FramesAcquired <= 10000)       
%--------------------------------------------------------------------------
%-- 5. Captura de Imagen del video --------------------------------------------
%--------------------------------------------------------------------------
    cdt0 = getsnapshot(vid);%Capturamos la imagen de la c�mara
    cdt = flip(cdt0,2);%Aplicamos la funci�n flip, que nos permite rotar la imagen y as� evitar el efecto de espejo
    cdt2 = cdt;[fill,col,cap]=size(cdt2);%Realizamos una copia de la imagen   
%--------------------------------------------------------------------------
%-- 6. Reconociendo el color VERDE en la imagen ----------------
%--------------------------------------------------------------------------    
    r = cdt(:,:,1);%Obtenemos la capa que contiene el color rojo de la imagen
    g = cdt(:,:,2);%Obtenemos la capa que contiene el color verde de la imagen
    b = cdt(:,:,3);%Obtenemos la capa que contiene el color azul de la imagen
    justGreen = g - b/2 - r/2;%A la capa verde le restamos las capas roja y azul
    %dividas entre 2 cada una, esto con la finalidad de obtener de la
    %imagen el color verde presente en la misma.
    bw = justGreen > 33;%Binarizamos la imagen, obteniendo as� los objetos
    %donde el color verde se encuentre presente
    cdt = bwareaopen(bw, 20);%La Funcion bwareaopen elimina todos los 
    %componentes conectados (objetos) que tienen menos de Pp�xeles de la 
    %imagen binaria BW, as� obtenemos todos los objetos que cumplan con la
    %mascara  
    guitarra=imread('Guitarra.png');guitarra=imresize(guitarra,[fill,col]);
    guitarra = (guitarra*1.5)+(cdt2*0.8); 
   
    imshow(guitarra);
%--------------------------------------------------------------------------
%-- 8. Reconocimiento del objeto interactuante ----------------
%-------------------------------------------------------------------------
    %Centroide del objeto Verde
    s  = regionprops(cdt, {'centroid','area'});%Obtenemos las propiedades 'centroide' y '�rea' de cada objeto que este blanco en BW
    if isempty(s)%Condicional que se encargar� de reconocer si el vector con objetos 
        %que cumplen con la mascara de reconocimiento, se encuentra vacio.
        
    else
        
        [~, id] = max([s.Area]);  %Obtenemos el ID del objeto cuya �rea sea la mayor en el vector de objetos
        hold on%comando para sobre escribir imagenes en pantalla
%--------------------------------------------------------------------------
%-- 9. Visualizaci�n del objeto y los marcadores ----------------
%--------------------------------------------------------------------------
        % Rectangulo.
        x = s(id).Centroid(1) - 5;%Coordenada en X para el CUADRO que identificar� al jugador
        y = s(id).Centroid(2) - 5;%Coordenada en Y para el CUADRO que identificar� al jugador
        p = [x, y, 13, 13];%Creaci�n del vector posici�n para el jugador
        
        %Dibujar rectangulo
        rectangulo = rectangle('Position',p,'EdgeColor','b','LineWidth',2);%Se dibuja el
        %Cuadrado correspondiente al objeto del jugador
        
    end 
end

%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------