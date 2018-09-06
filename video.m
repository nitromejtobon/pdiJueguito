vid = videoinput('winvideo', 1, 'YUY2_640x480');
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;

preview(vid);
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
    b=imread('Guitarra.png');b=imresize(b,[fill,col]);
    b = (b*1.5)+(cdt2*0.8); 
   
    imshow(b);
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
        r = rectangle('Position',p,'EdgeColor','b','LineWidth',2);%Se dibuja el
        %Cuadrado correspondiente al objeto del jugador
        
    end 
end