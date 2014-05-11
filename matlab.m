function varargout = SerialPortCommunication(varargin)
% SERIALPORTCOMMUNICATION M-file for SerialPortCommunication.fig
%      SERIALPORTCOMMUNICATION, by itself, creates a new SERIALPORTCOMMUNICATION or raises the existing
%      singleton*.
%
%      H = SERIALPORTCOMMUNICATION returns the handle to a new SERIALPORTCOMMUNICATION or the handle to
%      the existing singleton*.
%
%      SERIALPORTCOMMUNICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SERIALPORTCOMMUNICATION.M with the given input arguments.
%
%      SERIALPORTCOMMUNICATION('Property','Value',...) creates a new SERIALPORTCOMMUNICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SerialPortCommunication_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SerialPortCommunication_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SerialPortCommunication

% Last Modified by GUIDE v2.5 07-May-2014 08:10:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SerialPortCommunication_OpeningFcn, ...
                   'gui_OutputFcn',  @SerialPortCommunication_OutputFcn, ...
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

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
handles.o_SerialPort=serial('COM1');
%--------------¹Ø±ÕŽ®¿Ú-------------------------------
H_o_SerialPort=handles.o_SerialPort;
if strcmp(H_o_SerialPort.Status,'open')
        fclose(H_o_SerialPort);
end
delete(hObject);

% --- Executes just before SerialPortCommunication is made visible.
function SerialPortCommunication_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SerialPortCommunication (see VARARGIN)

% Choose default command line output for SerialPortCommunication
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SerialPortCommunication wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = SerialPortCommunication_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pb_OpenSerialPort.
function pb_OpenSerialPort_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OpenSerialPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
%______________________________________________
%GUIÈ«ŸÖ±äÁ¿
handles.o_SerialPort=[];
%°ŽÅ¥ÏÔÊŸÇÐ»»ÉèÖÃ
set(hObject,'Visible','off');
set(handles.pb_CloseSerialPort,'Position',get(handles.pb_OpenSerialPort,'Position'));
set(handles.pb_CloseSerialPort,'Visible','on');
%---------------------Ž®¿Ú³õÊŒ»¯-----------------------
%%%COM¶Ë¿Ú³õÊŒ»¯
int_Index_COM=get(handles.pop_SerialPort,'Value');
string_COM=get(handles.pop_SerialPort,'String');
string_Select_COM=string_COM{int_Index_COM};
h_o_SerialPort=serial(string_Select_COM);
handles.o_SerialPort=h_o_SerialPort;
%%%Baud³õÊŒ»¯
int_Index_Baud=get(handles.pop_BaudRate,'Value');
string_Baud=get(handles.pop_BaudRate,'String');
string_Select_Baud=string_Baud{int_Index_Baud};
double_Baud=str2double(string_Select_Baud);
set(h_o_SerialPort,'BaudRate',double_Baud);
%%%ÉèÖÃÊýŸÝ³€¶È
int_Index_DataBit=get(handles.pop_DataBit,'Value');
string_DataBit=get(handles.pop_DataBit,'String');
string_Select_DataBit=string_DataBit(int_Index_DataBit);
double_DataBit=str2double(string_Select_DataBit);
set(h_o_SerialPort,'DataBits',double_DataBit);
%%%ÉèÖÃÍ£Ö¹Î»³€¶È
int_Index_StopBits=get(handles.pop_StopBits,'Value');
string_StopBits=get(handles.pop_StopBits,'String');
string_Select_StopBits=string_StopBits(int_Index_StopBits);
double_StopBits=str2double(string_Select_StopBits);
set(h_o_SerialPort,'StopBits',double_StopBits);
%%%ÉèÖÃÊäÈë»º³åÇøŽóÐ¡Îª1M
set(h_o_SerialPort,'InputBufferSize',1024000);
%%%Ž®¿ÚÊÂŒþ»Øµ÷ÉèÖÃ
        h_o_SerialPort.BytesAvailableFcnMode='byte';
        h_o_SerialPort.BytesAvailableFcnCount=6; 
        h_o_SerialPort.BytesAvailableFcn={@EveBytesAvailableFcn,handles};
% ----------------------Žò¿ªŽ®¿Ú-----------------------
fopen(h_o_SerialPort);

guidata(hObject, handles);
%BytesAvailableFcnÊÂŒþ»Øµ÷º¯Êý
function EveBytesAvailableFcn( t,event,handles )
h_o_SerialPort=handles.o_SerialPort;  
% number=h_o_SerialPort.BytesAvailable;
global number;
global number2;
global data;
data=fread(h_o_SerialPort,6);%ÒÔ¶þœøÖÆ¶ÁÈ¡Ž®¿ÚsÖÐµÄÊýŸÝ²¢ŽæŽ¢ÔÚdatasÖÐ
data=data-48;
data=data';
RH=data(1)*10+data(2)+data(3)*0.1;
TM=data(4)*10+data(5)+data(6)*0.1;
% number=RH;% 
set(handles.edit1,'string',num2str(RH));%ÏÔÊŸÔÚedite1£»
set(handles.edit6,'string',num2str(TM));%ÏÔÊŸÔÚedite6£»
 number=[number RH];
 number2=[number2 TM];
% strNum=double2str(number);
% set(handles.edit1,'String',number);
L=plot(handles.axes_main,1:length(number),number,'r',1:length(number2),number2);

set(L,'LineWidth',1.5);  %œ«ÍŒÖÐµÄÇúÏßŒÓŽÖ£¬1.0±íÊŸÏßµÄŽÖÏž
% legend('Êª¶È','ÎÂ¶È');
% plot(handles.axes_main,1:length(number),number);

% --- Executes on button press in pb_CloseSerialPort.
function pb_CloseSerialPort_Callback(hObject, eventdata, handles)
% hObject    handle to pb_CloseSerialPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%---------------°ŽÅ¥ÏÔÊŸÇÐ»»ÉèÖÃ--------------------
set(hObject,'Visible','off');
set(handles.pb_OpenSerialPort,'Visible','on');
%--------------¹Ø±ÕŽ®¿Ú-------------------------------
H_o_SerialPort=handles.o_SerialPort;
if strcmp(H_o_SerialPort.Status,'open')
        fclose(H_o_SerialPort);
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_StopBits.
function pop_StopBits_Callback(hObject, eventdata, handles)
% hObject    handle to pop_StopBits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pop_StopBits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_StopBits


% --- Executes during object creation, after setting all properties.
function pop_StopBits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_StopBits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_DataBit.
function pop_DataBit_Callback(hObject, eventdata, handles)
% hObject    handle to pop_DataBit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pop_DataBit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_DataBit


% --- Executes during object creation, after setting all properties.
function pop_DataBit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_DataBit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_SerialPort.
function pop_SerialPort_Callback(hObject, eventdata, handles)
% hObject    handle to pop_SerialPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pop_SerialPort contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_SerialPort


% --- Executes during object creation, after setting all properties.
function pop_SerialPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_SerialPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_BaudRate.
function pop_BaudRate_Callback(hObject, eventdata, handles)
% hObject    handle to pop_BaudRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns pop_BaudRate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_BaudRate


% --- Executes during object creation, after setting all properties.
function pop_BaudRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_BaudRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_test_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit_test_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pb_CloseSerialPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_CloseSerialPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
