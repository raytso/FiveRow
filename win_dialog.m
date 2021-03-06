function varargout = win_dialog(varargin)
% WIN_DIALOG MATLAB code for win_dialog.fig
%      WIN_DIALOG, by itself, creates a new WIN_DIALOG or raises the existing
%      singleton*.
%
%      H = WIN_DIALOG returns the handle to a new WIN_DIALOG or the handle to
%      the existing singleton*.
%
%      WIN_DIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIN_DIALOG.M with the given input arguments.
%
%      WIN_DIALOG('Property','Value',...) creates a new WIN_DIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before win_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to win_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help win_dialog

% Last Modified by GUIDE v2.5 02-Jun-2015 20:23:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @win_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @win_dialog_OutputFcn, ...
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


% --- Executes just before win_dialog is made visible.
function win_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to win_dialog (see VARARGIN)

% Choose default command line output for win_dialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes win_dialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = win_dialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function win_dialog_winner_Callback(hObject, eventdata, handles)
% hObject    handle to win_dialog_winner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of win_dialog_winner as text
%        str2double(get(hObject,'String')) returns contents of win_dialog_winner as a double


% --- Executes during object creation, after setting all properties.
function win_dialog_winner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to win_dialog_winner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global winner;
if winner == 1
    player = 'Black';
else
    player = 'White';
end
set(hObject,'String',player, 'FontSize', 48)