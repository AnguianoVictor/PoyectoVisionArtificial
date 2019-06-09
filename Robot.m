function varargout = Robot(varargin)
% ROBOT MATLAB code for Robot.fig
%      ROBOT, by itself, creates a new ROBOT or raises the existing
%      singleton*.
%
%      H = ROBOT returns the handle to a new ROBOT or the handle to
%      the existing singleton*.
%
%      ROBOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOT.M with the given input arguments.
%
%      ROBOT('Property','Value',...) creates a new ROBOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Robot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Robot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDEs Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Robot

% Last Modified by GUIDE v2.5 09-Jun-2019 10:18:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Robot_OpeningFcn, ...
                   'gui_OutputFcn',  @Robot_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Robot is made visible.
function Robot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Robot (see VARARGIN)

% Choose default command line output for Robot
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Robot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Robot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function cam1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate cam1


% --- Executes on button press in btn_MoodSimulacion.
function btn_MoodSimulacion_Callback(hObject, eventdata, handles)
% hObject    handle to btn_MoodSimulacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btn_MoodSeguimiento,'Value',0);
set(handles.btn_MoodSeguimiento,'Visible','Off');
set(handles.btn_seguir,'Visible','Off');
% Hint: get(hObject,'Value') returns toggle state of btn_MoodSimulacion
%% Verificacion de camaras conectadas y obtencion de imagenes de las camaras. 
try
cam1 = webcam('DroidCam Source 3');
%cam1.AvailableResolutions; cam.Resolution ='000x00'; Cambio de resolucion
preview(cam1);
cam2 = webcam('HP Truevision HD');
preview(cam2);
%% Toma de fotografia
img1 = snapshot(cam1);
img2 = snapshot(cam2);
%% Muestra de fotografia. 
%image(img1);
%figure,image(img2);
%% Cierre de camaras
closePreview(cam1);
closePreview(cam2);
clear cam1 cam2
%% Muestra de imagenes tomadas en axes
axes(handles.cam1)
imshow(img1)
axes(handles.cam2)
imshow(img2)
catch Err
    switch Err.identifier
        case 'MATLAB:webcam:invalidName'
            msgbox('Revisar conexion de las camaras y/o nombres de las camaras en GUI','Error','error')
            warning('The device name specified is invalid. The list of valid devices are {HP Truevision HD, DroidCam Source 3}.');
    end
end


%% Arreglo de coordenadas de objetivo 
Ox = 30;
Oy = 40;
Oz = 10;
%% Arreglo de coordenadas de robot. 
Th1 = 10;
Th2 = 30;
Th3 = 50;

%% Impresion de valores coordenadas y angulos en las cajas de texto. 
set(handles.Obj_x,'String',strcat('Ox = ',num2str(Ox)));
set(handles.Obj_y,'String',strcat('Oy = ',num2str(Oy)));
set(handles.Obj_z,'String',strcat('Oz = ',num2str(Oz)));

set(handles.Theta1,'String',strcat('Theta1 = ',num2str(Th1)));
set(handles.Theta2,'String',strcat('Theta2 = ',num2str(Th2)));
set(handles.Theta3,'String',strcat('Theta3 = ',num2str(Th3)));
% Verificacion de coordenadas alcanzables. 

%% Colocaci�n de objetos en la simulaci�n. 


% --- Executes on button press in btn_simular.
function btn_simular_Callback(hObject, eventdata, handles)
% hObject    handle to btn_simular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ox = str2double(erase((get(handles.Obj_x,'String')),"Ox ="));
Oy = str2double(erase((get(handles.Obj_y,'String')),"Oy ="));
Oz = str2double(erase((get(handles.Obj_z,'String')),"Oz ="));

% Th1 = str2double(get(handles.Theta1,'String'))*pi/180;
% Th2 = str2double(get(handles.Theta2,'String'))*pi/180;
% Th3 = str2double(get(handles.Theta3,'String'))*pi/180;

L1 = 30;
L2 = 50;
L3 = 40;

L(1) = Link([0 L1 0 pi/2]);
L(2) = Link([0 0 L2 0]);
L(3) = Link([0 0 L3 0]);

Robot = SerialLink(L);
Robot.name = 'R';

T = [1 0 0 Ox;
     0 1 0 Oy;
     0 0 1 Oz;
     0 0 0 1];

J = Robot.ikine(T,'q0',[0 0 0],'mask', [1 1 1 0 0 0]) * 180/pi;
str_Theta1 = strcat('Theta1 =  ',num2str(floor(J(1))));
str_Theta2 = strcat('Theta2 =  ',num2str(floor(J(2))));
str_Theta3 = strcat('Theta3 =  ',num2str(floor(J(3))));
handles.Theta1.String = str_Theta1;
handles.Theta2.String = str_Theta2;
handles.Theta3.String = str_Theta3;
axes(handles.graph_robot)
Robot.plot(J*pi/180);
hold on
[x,y,z] = sphere;
h = surf(x*10+30,y*10+40,z*10+10,'FaceColor',[1 0 0]);
set(h,'edgecolor','none','facecolor',[0 1 1])

% --- Executes on button press in btn_ejecutar.
function btn_ejecutar_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ejecutar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = arduino('com4','Mega2560');
s = servo(a,'D9');
% Cambiar configuracion
for angle = 0:0.1:1
       %writePosition(s, angle);
       current_pos = readPosition(s);
       current_pos = current_pos*180;
       fprintf('Current motor position is %d degrees\n', current_pos);
       pause(2);
end
clear s a
% --- Executes on button press in btn_MoodSeguimiento.
function btn_MoodSeguimiento_Callback(hObject, eventdata, handles)
% hObject    handle to btn_MoodSeguimiento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.btn_MoodSimulacion,'Value',0);
    set(handles.btn_MoodSimulacion,'Visible','Off');
    set(handles.btn_simular,'Visible','Off');
    set(handles.btn_ejecutar,'Visible','Off')
    global flag_seguir;
    flag_seguir = true;



% Hint: get(hObject,'Value') returns toggle state of btn_MoodSeguimiento


% --- Executes on button press in btn_seguir.
function btn_seguir_Callback(hObject, eventdata, handles)
% hObject    handle to btn_segui r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cam1 = webcam('DroidCam Source 3');
%cam1.AvailableResolutions; cam.Resolution ='000x00'; Cambio de resolucion
%preview(cam1);
cam2 = webcam('HP Truevision HD');
%preview(cam2);

while(flag_seguir)
    try

        %% Toma de fotografia
        img1 = snapshot(cam1);
        img2 = snapshot(cam2);
        %% Muestra de fotografia. 
        %image(img1);
        %figure,image(img2);
        %% Cierre de camaras
        %closePreview(cam1);
        %closePreview(cam2);
        
        %% Muestra de imagenes tomadas en axes
        axes(handles.cam1)
        imshow(img1)
        axes(handles.cam2)
        imshow(img2)

        %% Obtener coordenadas del objetivo

        %% Verificacion alcanzable? 

        %% Arduino conectado?

        %% Enviar datos a arduino. 


    catch Err
        switch Err.identifier
            case 'MATLAB:webcam:invalidName'
                msgbox('Revisar conexion de las camaras y/o nombres de las camaras en GUI','Error','error')
                warning('The device name specified is invalid. The list of valid devices are {HP Truevision HD, DroidCam Source 3}.');
        end 
        end
end


clear cam1 cam2



% --- Executes on button press in btn_stop.
function btn_stop_Callback(hObject, eventdata, handles)
% hObject    handle to btn_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag_seguir;
flag_seguir = false;
cla(handles.graph_robot,'reset');
set(handles.btn_MoodSeguimiento,'Value',0);
set(handles.btn_MoodSimulacion,'Value',0);
set(handles.btn_MoodSeguimiento,'Visible','On');
set(handles.btn_seguir,'Visible','On')
set(handles.btn_MoodSimulacion,'Visible','On');
set(handles.btn_simular,'Visible','On');
set(handles.btn_ejecutar,'Visible','On')
