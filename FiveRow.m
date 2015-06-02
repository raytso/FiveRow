function varargout = FiveRow(varargin)
% FIVEROW MATLAB code for FiveRow.fig
%      FIVEROW, by itself, creates a new FIVEROW or raises the existing
%      singleton*.
%
%      H = FIVEROW returns the handle to a new FIVEROW or the handle to
%      the existing singleton*.
%
%      FIVEROW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIVEROW.M with the given input arguments.
%
%      FIVEROW('Property','Value',...) creates a new FIVEROW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FiveRow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FiveRow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FiveRow

% Last Modified by GUIDE v2.5 13-May-2015 19:49:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FiveRow_OpeningFcn, ...
                   'gui_OutputFcn',  @FiveRow_OutputFcn, ...
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


% --- Executes just before FiveRow is made visible.
function FiveRow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FiveRow (see VARARGIN)

% Choose default command line output for FiveRow
handles.output = hObject;

% UIWAIT makes FiveRow wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Create the 15x15 board with assigned matrix
axes('Units','pixels','Position',[50,150,600 ,600]);
handles.board_matrix = zeros(15,15);

% Board background image
im = imread('board.jpg');
imageHandle = image(im);
axis off;

% Set first user
handles.user = 1;

% Set callback function for image when clicked
set(imageHandle, 'ButtonDownFcn', @ImageClickCallback);

% Update handles structure
guidata(hObject, handles);





function ImageClickCallback(objectHandle, hObject, handles)
% Get the users mouse coordinates when clicked
axesHandle  = get(objectHandle,'Parent');
coordinates = get(axesHandle,'CurrentPoint'); 
coordinates = coordinates(1,1:2);

% Round up user mouse inputs to the nearast integar point
x1 = round((coordinates(1)-20)/50);
y1 = round((coordinates(2)-25)/50);
handles.board_matrix(x1, y1) = handles.user;
guidata(handles);







% --- Outputs from this function are returned to the command line.
function varargout = FiveRow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function inputUserData(hObject, handles, x1, y1)

if handles.user == 1
    handles.board_matrix(y1, x1) = 1;
    handles.user = 2;
else
    handles.board_matrix(y1, x1) = -1;
    handles.user = 1;
end

% Update handles structure
guidata(hObject, handles);




% % --- Executes when figure1 is resized.
% function figure1_ResizeFcn(hObject, eventdata, handles)
% % hObject    handle to figure1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Get the figure size and position
% Figure_Size = get(hObject, 'Position');
% % Set the figure's original size in character units
% Original_Size = [ 0 0 90 90];
% % If the resized figure is smaller than the 
% % original figure size then compensate
% if (Figure_Size(3)<Original_Size(3)) | (Figure_Size(4) ~= Original_Size(4))
%     if Figure_Size(3) < Original_Size(3)
%         % If the width is too small then reset to origianl width
%         set(hObject, 'Position',...
%     [Figure_Size(1) Figure_Size(2) Original_Size(3) Original_Size(4)])
%         Figure_Size = get(hObject, 'Position');
%     end 
% end
% % % Adjust the size of the Contact Name text box
% % % Set the units of the Contact Name field to 'Normalized'
% set(handles.axes1,'units','normalized')
% % % Get its Position
% C_N_pos = get(handles.axes1,'Position');
% % % Reset it so that it's width remains normalized relative to figure
% set(handles.axes1,'Position',...
%      [C_N_pos(1) C_N_pos(2)  0.789 C_N_pos(4)])
% % % Return the units to 'Characters'
% set(handles.axes1,'units','characters')
% % % Reposition GUI on screen
% movegui(hObject, 'onscreen')

