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

% Last Modified by GUIDE v2.5 05-Jun-2015 16:26:02

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
[im_black, map, blackchess_alpha] = imread('chess_black.png');
[im_white, map, whitechess_alpha] = imread('chess_white.png');

imageHandle = imshow(im, 'Parent', handles.axes2);
axis off;

black_chess = image(im_black);
set(black_chess,'Parent', handles.axes3, 'AlphaData', blackchess_alpha);
axis off;

white_chess = image(im_white);
set(white_chess,'Parent', handles.axes4, 'AlphaData', whitechess_alpha);
axis off;


handles.board_matrix = zeros(21);

% Set first user
handles.user = 1;

% Set win
handles.win = 0;

% Set round
handles.play_round = 0;

% Set winner
global winner;
winner = 0;

% Set callback function for image when clicked
set(imageHandle, 'ButtonDownFcn', {@ImageClickCallback, hObject, handles});

% Update handles structure
guidata(hObject, handles);


function ImageClickCallback(imageHandle, eventdata, hObject, handles)
handles = guidata(hObject);
global winner;
% enable the "oops" button
set(handles.oops_button,'Enable','on');
% Copy handles.* variables
win_check = handles.win;
playround = handles.play_round;

if win_check == 0 
    % Increment this round and save back to handles.
    playround = playround + 1;
    handles.play_round = playround;
    
    % Get the users mouse coordinates when clicked
    axesHandle  = get(imageHandle,'Parent');
    coordinates = get(axesHandle,'CurrentPoint'); 
    coordinates = coordinates(1,1:2);

    % Round up user mouse inputs to the nearast integar for matrix indexing
    handles.x(playround) = round((coordinates(1)-15)/51.5) + 2;
    handles.y(playround) = round((coordinates(2)-17)/51.5) + 2;
    
    % x2, y2 is for image pinpoints
    x2 = (handles.x(playround)-2)*51.5*0.8861 + 15;
    y2 = 835 - (handles.y(playround)-2)*51.5*0.8861;
    
    % Get board_matrix data and load into local variable
    M = handles.board_matrix;
    cache = M(handles.y(playround), handles.x(playround));
    
    % input data to matrix
    if cache ~= 0    
    else
        if handles.user == 1
            black_axes = axes('Units','pixels','Position',[ x2, y2, 25, 25 ]);
%             handles.black_chess(playround) = black_axes;
            [black, map, blackchess_alpha] = imread('chess_black.png');
            handles.black_chess(playround) = image(black);
            set(handles.black_chess(playround), 'AlphaData', blackchess_alpha);
            axis off;

        else
            white_axes = axes('Units','pixels','Position',[ x2, y2, 25, 25 ]);
%             handles.white_chess = white_axes;
            [white, map, whitechess_alpha] = imread('chess_white.png');
            handles.white_chess(playround) = image(white);
            set(handles.white_chess(playround), 'AlphaData', whitechess_alpha);
            axis off;
        end

        M(handles.y(playround), handles.x(playround)) = handles.user;
        handles.board_matrix = M;
        % check if 5 in a row
        handles.win = check_if_win(M, handles.y(playround), handles.x(playround));
        if handles.win == 1
            winner  = handles.user;
            win_dialog();
            set(handles.oops_button,'Enable','off');
        else
            %continue
        end

        % switch user
        if handles.user == 1
            handles.user = -1;
        else
            handles.user = 1;
        end
    end
else
end
guidata(hObject, handles);


function [ output ] = check_if_win(M, y, x)
no_streak = 1;
cache = M(y, x);
while(no_streak)
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
end


% --- Outputs from this function are returned to the command line.
function varargout = FiveRow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
M = handles.board_matrix;
playround = handles.play_round;
M(handles.y(playround), handles.x(playround)) = 0;
handles.board_matrix = M;
delete(axes);
if handles.user == 1
    delete(handles.white_chess(playround));
    handles.user = -1;
else
    delete(handles.black_chess(playround));
    handles.user = 1;
end
playround = playround - 1;
handles.play_round = playround;
guidata(hObject, handles);



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
         delete(handles.figure1);
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


% --- Executes on button press in forfeit_button.
function forfeit_button_Callback(hObject, eventdata, handles)
% hObject    handle to forfeit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
out = forfeit_dialog();
global winner;
switch out 
    case 'Yes'
        if handles.user == 1
            handles.user = -1;
            winner = handles.user;
            win_dialog();
            set(handles.forfeit_button,'Enable','off');
            set(handles.oops_button,'Enable','off');
        else
            handles.user = 1;
            winner = handles.user;
            win_dialog();
            set(handles.forfeit_button,'Enable','off');
            set(handles.oops_button,'Enable','off');
        end
    case 'No'
    return 
end


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3

