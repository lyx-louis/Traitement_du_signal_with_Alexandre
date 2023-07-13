function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 10-Jan-2022 18:27:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui2_OpeningFcn, ...
    'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;
Time = handles.time_axis;
plot(Time, randn(1,1024), 'r');
grid(Time,'on');
xlim(Time,[1 1024]);

Freq = handles.freq_axis;
grid(Freq,'on');
xlim(Freq,[-256 256]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function resultDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to resultDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resultDisplay as text
%        str2double(get(hObject,'String')) returns contents of resultDisplay as a double


% --- Executes during object creation, after setting all properties.
function resultDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in processButton.
function processButton_Callback(hObject, eventdata, handles)
% hObject    handle to processButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% method and signal
method = get(handles.MethodButtonGroup, 'SelectedObject');
signal = get(handles.time_axis.Children,'YData');
methodStr = get(method,'String');

if strcmp(methodStr,'Périodogramme')
    method = get(handles.periodogramType, 'SelectedObject');
    methodStr = get(method,'String');
end

% standard output
stdout = handles.resultDisplay;

% parameters
step      = str2double(get(handles.integrationWindowSize, 'String'));
winsize   = str2double(get(handles.windowSize,            'String'));
Nfft      = str2double(get(handles.nfftValue,             'String'));
fmin      = str2double(get(handles.fminValue,             'String'));
fmax      = str2double(get(handles.fmaxValue,             'String'));
n_overlap = str2double(get(handles.windowOverlap,         'String'));
fech      = str2double(get(handles.fechValue,             'String'));

% zero-padding
zeroPaddingObj = get(handles.zeroPaddingGroup, 'SelectedObject');
zeroPaddingVal = get(zeroPaddingObj, 'String');
if strcmp(zeroPaddingVal,'On')
    signal=zeroPad(signal);
end

clearvars zeroPaddingObj zeroPaddingVal;

% values that can be entered in a wrong way
valuesToTest = [
    winsize
    Nfft
    step];

if    testValue(valuesToTest(1),'ERREUR ! La taille de fenêtre doit être positive.')...
        && testValue(valuesToTest(2),'ERREUR ! Nfft doit avoir une valeur positive.')...
        && testValue(valuesToTest(3),"ERREUR ! Le pas d'intégration doit être positif.")
    switch methodStr
        case "Daniell"
            perioSig = daniell(signal, Nfft, winsize);
            newtitle = "Périodogramme de Daniell du signal";
        case "Welch"
            Fen = get(handles.windowSelector,'Value');
            FenNames = ["hamming","hanning","rectwin","triang"];
            
            if isnan(winsize) || winsize==0
                winsize=16;
            end
            if isnan(n_overlap) || n_overlap<=0
                n_overlap=16;
            end
            
            perioSig = welch(signal,winsize,Nfft,n_overlap ,FenNames(Fen));
            newtitle = "Périodogramme de Welch du signal";
        case "Bartlett"
            perioSig = bartlett(signal, winsize, Nfft, fech);
            newtitle = "Périodogramme de Bartlett du signal";
        case "Blackman-Tuckey"
            perioSig = blackmanTuckey(signal, Nfft, fech);
            newtitle = "Périodogramme de Blackman-Tuckey du signal";
        case "Capon"
            perioSig = Capon(signal, Nfft,fech);
            newtitle = "Spectre obtenu par la méthode de Capon";
        case "Spectre de puissance"
            perioSig = spectre(signal, Nfft, fech);
            newtitle = "Spectre de puissance du signal";
    end
    computeType = get(handles.integrationMethod, 'SelectedObject');
    computeTypeStr = get(computeType, 'String');
    power=0; % init
    switch computeTypeStr
        case "Rectangles"
            power = computePowerRect(perioSig, fmin, fmax, step,fech,Nfft);
        case "Trapèzes"
            power = computePowerTrap(perioSig, fmin, fmax, step,fech,Nfft);
            
    end
    stdout.String = num2str(power);
    Freq = handles.freq_axis;
    plot(Freq, -fech/2:fech/length(perioSig):fech/2-1, fftshift(perioSig));
    grid(Freq,'on');
    title(Freq,newtitle);
    
end

% --- Executes on selection change in noiseTypeSlider.
function noiseTypeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to noiseTypeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns noiseTypeSlider contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noiseTypeSlider


% --- Executes during object creation, after setting all properties.
function noiseTypeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseTypeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanValue_Callback(hObject, eventdata, handles)
% hObject    handle to meanValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanValue as text
%        str2double(get(hObject,'String')) returns contents of meanValue as a double


% --- Executes during object creation, after setting all properties.
function meanValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function varianceValue_Callback(hObject, eventdata, handles)
% hObject    handle to varianceValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of varianceValue as text
%        str2double(get(hObject,'String')) returns contents of varianceValue as a double


% --- Executes during object creation, after setting all properties.
function varianceValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varianceValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nbEchValue_Callback(hObject, eventdata, handles)
% hObject    handle to nbEchValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbEchValue as text
%        str2double(get(hObject,'String')) returns contents of nbEchValue as a double


% --- Executes during object creation, after setting all properties.
function nbEchValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbEchValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in generateNoiseButton.
function generateNoiseButton_Callback(hObject, eventdata, handles)
% hObject    handle to generateNoiseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% parameters
noiseType = get(handles.noiseTypeSlider, 'Value');
mean      = str2double(get(handles.meanValue,'String'));
variance  = str2double(get(handles.varianceValue,'String'));
length    = str2double(get(handles.nbEchValue,'String'));

% error correction

if isnan(mean)
    mean=0;
end
if isnan(variance) || variance <= 0
    variance=1;
end
if isnan(length) || length < 1
    length=1024;
end

if rem(length,1)~=0
    msgbox("Attention. Le nombre d'échantillons du bruit va être arrondi à l'entier inférieur.");
    length=floor(length);
end

switch noiseType
    case 1 % AWGN
        sig = generateAWGN(length,mean,variance);
        newtitle = sprintf("Bruit blanc gaussien. (µ=%d, σ²=%d)",mean,variance);
    case 2 % AR
        sig = generateAR(length,mean,variance);
        newtitle = sprintf("Processus autorégressif. (µ=%d, σ²=%d)",mean,variance);
end

plot(handles.time_axis,sig,'r');
title(handles.time_axis,newtitle);
grid(handles.time_axis,'on');
xlim(handles.time_axis, [0 length]);

% --- Executes on button press in addNoiseButton.
function addNoiseButton_Callback(hObject, eventdata, handles)
% hObject    handle to addNoiseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% parameters
noiseType = get(handles.noiseTypeSlider, 'Value');
mean      = str2double(get(handles.meanValue,'String'));
variance  = str2double(get(handles.varianceValue,'String'));
len       = str2double(get(handles.nbEchValue,'String'));

% error correction

if isnan(mean)
    mean=0;
end
if isnan(variance) || variance <= 0
    variance=1;
end
if isnan(len) || len < 1
    len=1024;
end

if rem(len,1)~=0
    msgbox("Attention. Le nombre d'échantillons du bruit va être arrondi à l'entier inférieur.");
    len=floor(len);
end

switch noiseType
    case 1
        sig = generateAWGN(len,mean,variance);
    case 2
        sig = generateAR(len,mean,variance);
end

oldSig = get(handles.time_axis.Children, 'YData');

l1 = length(oldSig);

if l1 ~= len
    if l1 < len
        oldSig = [oldSig zeros(1,len-l1)] + sig;
    else
        oldSig(1:len) = oldSig(1:len) + sig;
    end
else
    oldSig = oldSig + sig;
end



oldtitle = get(handles.time_axis.Title,'String');
plot(handles.time_axis,oldSig,'r');
title(handles.time_axis,oldtitle);
grid(handles.time_axis,'on');
xlim(handles.time_axis, [0 length(oldSig)]);


function filenameDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to filenameDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filenameDisplay as text
%        str2double(get(hObject,'String')) returns contents of filenameDisplay as a double


% --- Executes during object creation, after setting all properties.
function filenameDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenameDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadSignalButton.
function loadSignalButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadSignalButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% loads a .mat file and plots it
[filename, filepath] = uigetfile({'*.*';'*.mat*'},'Search signal to load');
fullname = [filepath filename];
if (size(fullname)==[1,2]) & (fullname==[0,0])
    disp("error aborted");
else
    sig = load(fullname);
    axes(handles.time_axis);
    plot(sig.sig,'r');
    grid on;
    x_axis = get(handles.time_axis.Children,'XData');
    xlim([min(x_axis),max(x_axis)]);
    title(handles.time_axis,filename);
end

% --- Executes on selection change in windowSelector.
function windowSelector_Callback(hObject, eventdata, handles)
% hObject    handle to windowSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns windowSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from windowSelector


% --- Executes during object creation, after setting all properties.
function windowSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowSize_Callback(hObject, eventdata, handles)
% hObject    handle to windowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowSize as text
%        str2double(get(hObject,'String')) returns contents of windowSize as a double


% --- Executes during object creation, after setting all properties.
function windowSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowOverlap_Callback(hObject, eventdata, handles)
% hObject    handle to windowOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowOverlap as text
%        str2double(get(hObject,'String')) returns contents of windowOverlap as a double


% --- Executes during object creation, after setting all properties.
function windowOverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fechValue_Callback(hObject, eventdata, handles)
% hObject    handle to fechValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fechValue as text
%        str2double(get(hObject,'String')) returns contents of fechValue as a double


% --- Executes during object creation, after setting all properties.
function fechValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fechValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nfftValue_Callback(hObject, eventdata, handles)
% hObject    handle to nfftValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfftValue as text
%        str2double(get(hObject,'String')) returns contents of nfftValue as a double


% --- Executes during object creation, after setting all properties.
function nfftValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfftValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function integrationWindowSize_Callback(hObject, eventdata, handles)
% hObject    handle to integrationWindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of integrationWindowSize as text
%        str2double(get(hObject,'String')) returns contents of integrationWindowSize as a double


% --- Executes during object creation, after setting all properties.
function integrationWindowSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to integrationWindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fminValue_Callback(hObject, eventdata, handles)
% hObject    handle to fminValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fminValue as text
%        str2double(get(hObject,'String')) returns contents of fminValue as a double


% --- Executes during object creation, after setting all properties.
function fminValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fminValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fmaxValue_Callback(hObject, eventdata, handles)
% hObject    handle to fmaxValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fmaxValue as text
%        str2double(get(hObject,'String')) returns contents of fmaxValue as a double


% --- Executes during object creation, after setting all properties.
function fmaxValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fmaxValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
