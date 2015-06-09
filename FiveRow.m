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

% Last Modified by GUIDE v2.5 07-Jun-2015 18:02:01

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

% Set scrollbars
% set(gcf,'visible','off')
% jScrollPane_blackbox = findjobj(handles.black_history_edittext);
% set(jScrollPane_blackbox, 'VerticalScrollBarPolicy',20);
% jScrollPane_whitebox = findjobj(handles.white_history_edittext);
% set(jScrollPane_whitebox, 'VerticalScrollBarPolicy',20);
% set(gcf,'visible','on')


% UIWAIT makes FiveRow wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Create the 15x15 board with assigned matrix
% axes('Units','pixels','Position',[ 10, 150, 800, 800 ]);
% axis off;

% Board background image and other stuff
im = imread('board.png');
[im_black, map, blackchess_alpha] = imread('chess_black.png');
[im_white, map, whitechess_alpha] = imread('chess_white.png');
[black_player_pointer, map, black_player_pointer_alpha] = imread('illuminum.png');
[white_player_pointer, map, white_player_pointer_alpha] = imread('illuminum.png');

imageHandle = imshow(im, 'Parent', handles.axes2);
axis off;

% Set "Now Playing" black chess icon
black_chess = image(im_black);
set(black_chess,'Parent', handles.axes3, 'AlphaData', blackchess_alpha);
axis off

% Set "Now Playing" white chess icon
white_chess = image(im_white);
set(white_chess,'Parent', handles.axes4, 'AlphaData', whitechess_alpha);
axis off

% Set illuminated light for "Now playing" black player
black_player_pointer_light = image(black_player_pointer);
set(black_player_pointer_light,'Parent', handles.axes6, 'AlphaData', black_player_pointer_alpha);
axis off

% Set illuminated light for "Now playing" white player
white_player_pointer_light = image(white_player_pointer);
set(white_player_pointer_light,'Parent', handles.axes5, 'AlphaData', white_player_pointer_alpha);
set(get(handles.axes6,'children'),'visible','off') %hide the current axes contents
axis off

% Set 21X21 board_matrix (with 0 on borders)
handles.board_matrix = zeros(21);

% Set first user
handles.user = 1;

% Set win
handles.win = 0;

% Set round
handles.play_round = 0;

% Set number of clicks
handles.clicks = 0;

% handles.initstring = '';

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
handles.black_initstring = '';
handles.white_initstring = '';

if win_check == 0 
    % Increment this round and save back to handles.
    playround = playround + 1;
%     click = click + 1;
    handles.play_round = playround;
%     handles.clicks = click;
    
    % Get the users mouse coordinates when clicked
    axesHandle  = get(imageHandle,'Parent');
    coordinates = get(axesHandle,'CurrentPoint'); 
    coordinates = coordinates(1,1:2);

    % Round up user mouse inputs to the nearast integar for matrix indexing
    handles.x(playround) = round((coordinates(1)-15)/51.5) + 2;
    handles.y(playround) = round((coordinates(2)-17)/51.5) + 2;
    
    % x2, y2 is for image pinpoints
    x2 = (handles.x(playround)-2)*51.5*0.8888 + 15;
    y2 = 835 - (handles.y(playround)-2)*51.5*0.89;
    
    % Get board_matrix data and load into local variable
    M = handles.board_matrix;
    cache = M(handles.y(playround), handles.x(playround));
    pointx = num2str(handles.x(playround));
    pointy = num2str(handles.y(playround));
    point = strcat('<',pointx,',',pointy,'>');
    handles.cell{playround} = point;
    
    % input data to matrix
    if cache ~= 0    
    else
        if handles.user == 1
            set(handles.play_round_data_text, 'String', round(playround/2));
            black_axes = axes('Units','pixels','Position',[ x2, y2, 25, 25 ]);
            [black, map, blackchess_alpha] = imread('chess_black.png');
            handles.black_chess(round(playround/2)) = image(black);
            set(handles.black_chess(round(playround/2)), 'AlphaData', blackchess_alpha);
            axis off;
            for i = 1:2:playround
                handles.black_initstring = [handles.black_initstring handles.cell(i)];
            end
            set(handles.black_history_edittext, 'String', handles.black_initstring);
            set(handles.black_history_edittext, 'Value', round(playround/2));

        else
            white_axes = axes('Units','pixels','Position',[ x2, y2, 25, 25 ]);
            [white, map, whitechess_alpha] = imread('chess_white.png');
            handles.white_chess(round(playround/2)) = image(white);
            set(handles.white_chess(round(playround/2)), 'AlphaData', whitechess_alpha);
            axis off;
            for i = 2:2:playround
                handles.white_initstring = [handles.white_initstring handles.cell(i)];
            end
            set(handles.white_history_edittext, 'String', handles.white_initstring);
            set(handles.white_history_edittext, 'Value', round(playround/2));
        end

        M(handles.y(playround), handles.x(playround)) = handles.user;
        handles.board_matrix = M;
        % check if 5 in a row
        handles.win = check_if_win(M, handles.y(playround), handles.x(playround));
        if handles.win == 1
            winner  = handles.user;
            win_dialog();
            set(handles.oops_button,'Enable','off');
            set(handles.forfeit_button,'Enable','off');
        else
            %continue
        end

        % switch user
        if handles.user == 1
            handles.user = -1;
%             set(handles.axes5,'visible','off') %hide the current axes
            set(get(handles.axes5,'children'),'visible','off') %hide the current axes contents
            axis off;
%             set(handles.axes6,'visible','on') %hide the current axes
            set(get(handles.axes6,'children'),'visible','on') %hide the current axes contents
            axis off;
        else
            handles.user = 1;
%             set(handles.axes6,'visible','off') %hide the current axes
            set(get(handles.axes6,'children'),'visible','off') %hide the current axes contents
            axis off;
%             set(handles.axes5,'visible','on') %hide the current axes
            set(get(handles.axes5,'children'),'visible','on') %hide the current axes contents
            axis off;
            
        end
    end
else
end
handles.black_initstring = '';
handles.white_initstring = '';
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
% click = handles.clicks;
playround = handles.play_round;
% click = click + 1;
% handles.clicks = click;
M(handles.y(playround), handles.x(playround)) = 0;
handles.board_matrix = M;
delete(axes);
handles.cell{playround} = '';
if handles.user == 1
    delete(handles.white_chess(round(playround/2)));
    handles.user = -1;
    for i = 2:2:playround
    handles.white_initstring = [handles.white_initstring handles.cell(i)];
    end
    set(handles.white_history_edittext, 'String', handles.white_initstring);
    set(handles.white_history_edittext, 'Value', (round((playround-1)/2))-1);
    set(get(handles.axes5,'children'),'visible','off') %hide the current axes contents
    axis off;
%             set(handles.axes6,'visible','on') %hide the current axes
    set(get(handles.axes6,'children'),'visible','on') %hide the current axes contents
    axis off;
    
else
    delete(handles.black_chess(round(playround/2)));
    handles.user = 1;
    for i = 1:2:playround
    handles.black_initstring = [handles.black_initstring handles.cell(i)];
    end
    set(handles.black_history_edittext, 'Value', round((playround-1)/2));
    set(handles.black_history_edittext, 'String', handles.black_initstring);
    set(get(handles.axes6,'children'),'visible','off') %hide the current axes contents
    axis off;
%             set(handles.axes5,'visible','on') %hide the current axes
    set(get(handles.axes5,'children'),'visible','on') %hide the current axes contents
    axis off;
    
end

playround = playround - 1;
handles.play_round = playround;
set(handles.play_round_data_text, 'String', round(playround/2));

handles.black_initstring = '';
handles.white_initstring = '';

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
axis off


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4

axis off

% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5
axis off

% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6
axis off



% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7
axis off


% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8
axis off



function black_history_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to black_history_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of black_history_edittext as text
%        str2double(get(hObject,'String')) returns contents of black_history_edittext as a double


% --- Executes during object creation, after setting all properties.
function black_history_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to black_history_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function white_history_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to white_history_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of white_history_edittext as text
%        str2double(get(hObject,'String')) returns contents of white_history_edittext as a double


% --- Executes during object creation, after setting all properties.
function white_history_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to white_history_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
