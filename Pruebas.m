clc, clear, close all

try
cam1 = webcam('DroidCam Source 3')
%cam1.AvailableResolutions; cam.Resolution ='000x00'; Cambio de resolucion
preview(cam1)
cam2 = webcam('HP Truevision HD')
preview(cam2);
%% Toma de fotografia
img1 = snapshot(cam1);
img2 = snapshot(cam2);
%% Muestra de fotografia. 
image(img1);
figure,image(img2);
%% Cierre de camaras
closePreview(cam1);
closePreview(cam2);
clear cam1 cam2
catch Err
    switch Err.identifier
        case 'MATLAB:webcam:invalidName'
            warning('The device name specified is invalid. The list of valid devices are {HP Truevision HD, DroidCam Source 3}.');
    end
end



%% 
clc, clear, close all
[x,y,z] = sphere;
figure
h = surf(x*10-30,y*10-40,z*10-10,'FaceColor',[1 0 0]);
set(h,'edgecolor','none','facecolor',[1 0 .0])
xlim([-100 100])
ylim([-100 100])
zlim([-100 100])
