function varargout = timezone(varargin)
% TIMEZONE MATLAB code for timezone.fig
%      TIMEZONE, by itself, creates a new TIMEZONE or raises the existing
%      singleton*.
%
%      H = TIMEZONE returns the handle to a new TIMEZONE or the handle to
%      the existing singleton*.
%
%      TIMEZONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMEZONE.M with the given input arguments.
%
%      TIMEZONE('Property','Value',...) creates a new TIMEZONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before timezone_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to timezone_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help timezone

% Last Modified by GUIDE v2.5 30-Jun-2014 16:58:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @timezone_OpeningFcn, ...
                   'gui_OutputFcn',  @timezone_OutputFcn, ...
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


% --- Executes just before timezone is made visible.
function timezone_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to timezone (see VARARGIN)

% Choose default command line output for timezone
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes timezone wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = timezone_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
contents = cellstr(get(handles.timeZone,'String'));
value = contents{get(handles.timeZone,'Value')};
if strcmp(value, 'Time Zone');
    varargout{1} =false;
else
    varargout{1} = value;
end

% The figure can be deleted now
delete(handles.figure1);

% --- Executes on selection change in timeZone.
function timeZone_Callback(hObject, eventdata, handles)
% hObject    handle to timeZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns timeZone contents as cell array
%        contents{get(hObject,'Value')} returns selected item from timeZone


% --- Executes during object creation, after setting all properties.
function timeZone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
