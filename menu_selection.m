function varargout = menu_selection(varargin)
% MENU_SELECTION MATLAB code for menu_selection.fig
%      MENU_SELECTION, by itself, creates a new MENU_SELECTION or raises the existing
%      singleton*.
%
%      H = MENU_SELECTION returns the handle to a new MENU_SELECTION or the handle to
%      the existing singleton*.
%
%      MENU_SELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MENU_SELECTION.M with the given input arguments.
%
%      MENU_SELECTION('Property','Value',...) creates a new MENU_SELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before menu_selection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to menu_selection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help menu_selection

% Last Modified by GUIDE v2.5 09-Jun-2015 13:51:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @menu_selection_OpeningFcn, ...
                   'gui_OutputFcn',  @menu_selection_OutputFcn, ...
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


% --- Executes just before menu_selection is made visible.
function menu_selection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to menu_selection (see VARARGIN)

% Choose default command line output for menu_selection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes menu_selection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = menu_selection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);
FiveRow();



% --- Executes during object creation, after setting all properties.
function start_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over start_button.
function start_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
ha = axes('units','normalized', ...
            'position',[0 0 1 1]);
uistack(ha, 'bottom')
i = imread('sakura_background.jpg');
hi = imagesc(i);
set(ha,'handlevisibility','off', ...
            'visible','off');
axis off;
title = text(0,0.8,'Five Row Chess');
get(title)
set(title,'FontSize',78.0,'color',[0, 1, 1]);
