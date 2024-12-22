function varargout = second(varargin)
%SECOND MATLAB code file for second.fig
%      SECOND, by itself, creates a new SECOND or raises the existing
%      singleton*.
%
%      H = SECOND returns the handle to a new SECOND or the handle to
%      the existing singleton*.
%
%      SECOND('Property','Value',...) creates a new SECOND using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to second_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SECOND('CALLBACK') and SECOND('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SECOND.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help second

% Last Modified by GUIDE v2.5 20-Dec-2024 16:54:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @second_OpeningFcn, ...
                   'gui_OutputFcn',  @second_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before second is made visible.
function second_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
clc
% Choose default command line output for second
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes second wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = second_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
     % Retrieve user inputs
   % Retrieve and validate user inputs, assign defaults if empty or invalid
m = str2double(get(handles.mass, 'String'));
if isnan(m) || isempty(m)
    m = 1.0; % Default mass (kg)
end

k = str2double(get(handles.stiffness, 'String'));
if isnan(k) || isempty(k)
    k = 100.0; % Default stiffness (N/m)
end

c = str2double(get(handles.damping, 'String'));
if isnan(c) || isempty(c)
    c = 0.5; % Default damping (Ns/m)
end

a_0 = str2double(get(handles.acceleration, 'String'));
if isnan(a_0) || isempty(a_0)
    a_0 = 0.2; % Default acceleration amplitude (m/s^2)
end

f = str2double(get(handles.frequency, 'String'));
if isnan(f) || isempty(f)
    f = 1.5; % Default frequency (Hz)
end

    time = 0:0.01:20; % Time vector (s)
    
    % Simulate earthquake acceleration
    earthquake_acc = a_0 * sin(2 * pi * f * time); % m/s^2

    % Initial conditions
    x0 = 0; % Initial displacement (m)
    v0 = 0; % Initial velocity (m/s)

    % Define the differential equation
    ode_fun = @(t, y) [y(2); (-c*y(2) - k*y(1) + m*interp1(time, earthquake_acc, t, 'linear', 0))/m];
    [t, y] = ode45(ode_fun, time, [x0 v0]);

    % Plot displacement over time
    axes(handles.displacement_axes);
    plot(t, y(:,1));
    xlabel('Time (s)');
    ylabel('Displacement (m)');
    title('Displacement of Single-Story Building');

    axes(handles.acc_axis);
    plot(t,earthquake_acc)
    xlabel('Time (s)');
    ylabel('Acceleration (m/s^2)');
    title('Acceleration due to Earthquake');

% Set up animation
axes(handles.animation_axes);
cla; % Clear previous animation
hold on;
xlim([0, 2]);
ylim([0, 1]);
title('Mass-Spring-Damper Animation');
xlabel('Position');
ylabel('Height');

% Parameters for mass
mass_width = 0.2;
mass_height = 0.5;
mass_initial_x = 1;
mass_y = 0.25;

% Vertical positions for spring and damper
spring_y = mass_y + mass_height * 0.75; % 75% up from the bottom of the mass
damper_y = mass_y + mass_height * 0.25; % 25% up from the bottom of the mass

% Initialize mass (rectangle)
mass_rect = rectangle('Position', [mass_initial_x, mass_y, mass_width, mass_height], 'FaceColor', 'b');

% Function to draw spring
drawSpring = @(x_start, x_end, y, coils, amplitude) ...
    plot(x_start + linspace(0, x_end - x_start, 100), ...
         y + amplitude * sin(linspace(0, coils * 2 * pi, 100)), ...
         'k', 'LineWidth', 2);

% Function to draw damper
drawDamper = @(x_start, x_end, y) ...
    plot([x_start, x_end], [y, y], 'g', 'LineWidth', 2);

% Initial spring and damper
spring_line = drawSpring(0, mass_initial_x, spring_y, 10, 0.05);
damper_line = drawDamper(0, mass_initial_x, damper_y);

% Animation loop
for i = 1:length(t)
    % Update mass position
    mass_x = mass_initial_x + y(i, 1); % Adjust this calculation as needed
    set(mass_rect, 'Position', [mass_x, mass_y, mass_width, mass_height]);

    % Update spring position
    delete(spring_line); % Remove the old spring
    spring_line = drawSpring(0, mass_x, spring_y, 10, 0.05);

    % Update damper position
    delete(damper_line); % Remove the old damper
    damper_line = drawDamper(0, mass_x, damper_y);

    % Pause to control animation speed
    pause(0.01);
end





function mass_Callback(hObject, eventdata, handles)
% hObject    handle to mass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mass as text
%        str2double(get(hObject,'String')) returns contents of mass as a double


% --- Executes during object creation, after setting all properties.
function mass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stiffness_Callback(hObject, eventdata, handles)
% hObject    handle to stiffness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stiffness as text
%        str2double(get(hObject,'String')) returns contents of stiffness as a double


% --- Executes during object creation, after setting all properties.
function stiffness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stiffness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function damping_Callback(hObject, eventdata, handles)
% hObject    handle to damping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of damping as text
%        str2double(get(hObject,'String')) returns contents of damping as a double


% --- Executes during object creation, after setting all properties.
function damping_CreateFcn(hObject, eventdata, handles)
% hObject    handle to damping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function acceleration_Callback(hObject, eventdata, handles)
% hObject    handle to acceleration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of acceleration as text
%        str2double(get(hObject,'String')) returns contents of acceleration as a double


% --- Executes during object creation, after setting all properties.
function acceleration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acceleration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency as text
%        str2double(get(hObject,'String')) returns contents of frequency as a double


% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
