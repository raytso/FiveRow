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

% Last Modified by GUIDE v2.5 04-Jun-2015 08:16:32

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
% axes('Units','pixels','Position',[ 10, 150, 800, 800 ]);
% axis off;

% Board background image and other stuff
im = imread('board.png');
imageHandle = image(im);
axis off;

M = zeros(21);
global board_matrix;
board_matrix = M;

% Set first user
global user;
user = 1;

global win;
win = 0;

% Set callback function for image when clicked
set(imageHandle, 'ButtonDownFcn', @ImageClickCallback);

% Update handles structure
guidata(hObject, handles);





function ImageClickCallback(objectHandle, eventdata)
    global win;
    global x1;
    global y1;
    global board_matrix;
    global user;
    global blackchess_alpha;
    global whitechess_alpha;

    if win == 0
        % Get the users mouse coordinates when clicked
        axesHandle  = get(objectHandle,'Parent');
        coordinates = get(axesHandle,'CurrentPoint'); 
        coordinates = coordinates(1,1:2);

        % Round up user mouse inputs to the nearast integar point
        x1 = round((coordinates(1)-15)/51.5) + 2;
        y1 = round((coordinates(2)-17)/51.5) + 2;
        x2 = (x1-2)*51.5*0.8861 + 15;
        y2 = 835 - (y1-2)*51.5*0.8861;

        M = board_matrix;
        cache = M(y1, x1);
        % input data to matrix
        if cache ~= 0    
        else
            if user == 1
                axes('Units','pixels','Position',[ x2, y2, 25, 25 ]);
                [black, map, blackchess_alpha] = imread('chess_black.png');
                black_chess = image(black);
                set(black_chess, 'AlphaData', blackchess_alpha);
                axis off;

            else
                axes('Units','pixels','Position',[ x2, y2, 25, 25 ]);
                [white, map, whitechess_alpha] = imread('chess_white.png');
                white_chess = image(white);
                set(white_chess, 'AlphaData', whitechess_alpha);
                axis off;
            end

            M(y1, x1) = user;
            board_matrix = M;
            % check if 5 in a row
            win = check_if_win(M, y1, x1);
            if win == 1
                win_dialog();
            else
                %continue
            end

            % switch user
            if user == 1
                user = -1;
            else
                user = 1;
            end
        end
    else
    end


function [ output ] = check_if_win(M, y, x)
no_streak = 1;
cache = M(y, x);
while(no_streak)
    tic;
    % left
    for a = 1:4
        steps_left_leftright = 5 - a;
        compare = M(y, x-a);
        if compare == cache
            if a == 4
                output = 1;
                no_streak = 0;

            end
        else
            break; 
        end
    end
    if no_streak == 0
        break;
    end

    % right
    for e = 1:steps_left_leftright
        if M(y, x+e) == cache
            if e == steps_left_leftright
                output = 1;
                no_streak = 0;
            end
        else
            break; 
        end
    end
    if no_streak == 0
        break;
    end
    
    % left-up
    for b = 1:4
        steps_left_leftuprightdown = 5 - b;
        if M(y-b, x-b) == cache
            if b == 4
                output = 1;
                no_streak = 0;
            end
        else
            break; 
        end
    end
    if no_streak == 0
        break;
    end
    
    % right-down
    for f = 1:steps_left_leftuprightdown
        if M(y+f, x+f) == cache
            if f == steps_left_leftuprightdown
                output = 1;
                no_streak = 0;
            end
        else
            break; 
        end
    end
    if no_streak == 0
        break;
    end

    % up
    for c = 1:4
        steps_left_updown = 5 - c;
        if M(y-c, x) == cache
            if c == 4
                output = 1;
                no_streak = 0;
            end
        else
            break; 
        end
    end
    if no_streak == 0
        break;
    end
    
    % down
    for g = 1:steps_left_updown
        if M(y+g, x) == cache
            if g == steps_left_updown
                output = 1;
                no_streak = 0;
            end
            
        else
            break; 
        end
    end
    if no_streak == 0
        break;
    end


    % up-right
    for d = 1:4
        steps_left_uprightleftdown = 5 - d;
        if M(y-d, x+d) == cache
            if d == 4
                output = 1;
                no_streak = 0;
            end
        else
            break; 
        end
    end
    if no_streak == 0
        break;
    end

    
    % down-left
    for i = 1:steps_left_uprightleftdown
        if M(y+i, x-i) == cache
            if i == steps_left_uprightleftdown
                output = 1;
                no_streak = 0;
            end
        else
            output = 0;
            no_streak = 0;
            break; 
        end
    end
    toc;
end


% --- Outputs from this function are returned to the command line.
function varargout = FiveRow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = 5;

% Get default command line output from handles structure
varargout{1} = handles.output;




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


% --- Executes on button press in oops_button.
function oops_button_Callback(hObject, eventdata, handles)
% hObject    handle to oops_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the users mouse coordinates when clicked



% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
out = exit_dialog();
switch out 
    case 'Yes'
         close(handles.figure1);
         menu_selection();
    case 'No'
    return 
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over exit_button.
function exit_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over oops_button.
function oops_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to oops_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x1;
global y1;
global board_matrix;

M = board_matrix;
M(y1, x1) = 0;
