function varargout = SVIM(varargin)
% SVIM is the program of Seismic Vulnerability Index of Microtremor for
% microtremor data processing based on Quasi-Transfer Spectra (QTS) method 
% also called Horizontal to Vertical Spectral Ratio method (HVSR) that was 
% popularized by Nakamura (1989). The program provides seismic vulnerability
% index (Kg) calculation and seismic vulnerability index map (SVIM-Map)
% program which is integrated in one program.
%
% The package you need:
%
% rdmseed : To read mini-SEED data (created by Fran�ois Beauducel)
%
% You can download the rdmseed package from website:
% https://www.mathworks.com/matlabcentral/fileexchange/28803-rdmseed-and-mkmseed-read-and-write-miniseed-files
%
% See guide book for the SVIM program operation
%
% Created by: 
% Aulia Khalqillah, S.Si., M.Si
% Prof. Dr. Muksin, S.Si., M.Si., M.Phil
% Tsunami and Disaster Mitigation Research Center (TDMRC)
% UPT. Mitigasi Bencana
% Universitas Syiah Kuala, Banda Aceh
% Email: auliakhalqillah@usk.ac.id or auliakhalqillah.mail@gmail.com

% Edit the above text to modify the response to help SVIM

% Last Modified by GUIDE v2.5 20-Apr-2021 10:32:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SVIM_OpeningFcn, ...
                   'gui_OutputFcn',  @SVIM_OutputFcn, ...
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


% --- Executes just before SVIM is made visible.
function SVIM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SVIM (see VARARGIN)

% Choose default command line output for SVIM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SVIM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SVIM_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function filemenu_Callback(hObject, eventdata, handles)
% hObject    handle to filemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function helpmenu_Callback(hObject, eventdata, handles)
% hObject    handle to helpmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function aboutmenu_Callback(hObject, eventdata, handles)
% hObject    handle to aboutmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function insertrawmenu_Callback(hObject, eventdata, handles)
% hObject    handle to insertrawmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% OPEN FILE MSEED
[filename,pathname]=uigetfile({
    '*.bhe;*.bhn;*.bhz','Mini-Seed(*.bhe,*.bhn,*.bhz)';...
    '*.she;*.shn;*.shz','Mini-Seed(*.she,*.shn,*.shz)';...
    '*.pri1;*.pri2;*.pri0','Mini-Seed(*.pri1,*.pri2,*.pri0)';...
    '*.*',  'All Files (*.*)'}, ...
    'Pick a file', ...
    'MultiSelect', 'on');

if isequal(filename, 0)
   disp('User selected Cancel')
   return;
end

%% READ AND PLOT RAW DATA
filename = cellstr(filename);
n = length(filename);

[X{1},~] = rdmseed(fullfile(pathname, filename{1}));
t{1} = cat(1,X{1}.t);
d{1} = cat(1,X{1}.d);
samprate{1} = cat(1,X{1}.SampleRate);
dt = 1/mean(samprate{1});
x{1}=(0:dt:(size(d{1},1)-1)*dt);

[X{2},~] = rdmseed(fullfile(pathname, filename{2}));
t{2} = cat(1,X{2}.t);
d{2} = cat(1,X{2}.d);
samprate{2} = cat(1,X{2}.SampleRate);
dt = 1/mean(samprate{1});
x{2}=(0:dt:(size(d{2},1)-1)*dt);


[X{3},~] = rdmseed(fullfile(pathname, filename{3}));
t{3} = cat(1,X{3}.t);
d{3} = cat(1,X{3}.d);
samprate{3} = cat(1,X{3}.SampleRate);
dt = 1/mean(samprate{3});
x{3}=(0:dt:(size(d{3},1)-1)*dt);

set(handles.dtbox,'string',num2str(dt));

axes(handles.eastsignal)
plot(x{1},d{1})
grid minor
ylabel('E')
axis([min(x{1}) max(x{1}) min(d{1}) max(d{1})])

axes(handles.northsignal)
plot(x{2},d{2})
grid minor
ylabel('N')
axis([min(x{2}) max(x{2}) min(d{2}) max(d{2})])

axes(handles.verticalsignal)
plot(x{3},d{3})
grid minor
ylabel('V')
xlabel('Time (Second)')
axis([min(x{3}) max(x{3}) min(d{3}) max(d{3})])

set(handles.rawdata,'Title','Raw Data');

file = filename{1};
lengthfile = length(file);
file_name = file(1:lengthfile-4);
set(handles.filenamebox, 'String', file_name);
set(handles.pathnamebox,'String',pathname);
set(handles.info,'string',' Data has been loaded...');

handles.d{1} = d{1};
handles.d{2} = d{2};
handles.d{3} = d{3};
handles.x{1} = x{1};
handles.x{2} = x{2};
handles.x{3} = x{3};
handles.filename = filename;
handles.file_name = file_name;
handles.n = n;
handles.dt = dt;
guidata(hObject, handles);

% --------------------------------------------------------------------
function savegraphmenu_Callback(hObject, ~, handles)
% hObject    handle to savegraphmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Frequency = handles.Frequency;
frr = handles.frr;
newR = handles.newR;
y = handles.y;
minstd = handles.minstd;
maxstd = handles.maxstd;
minfr = str2double(get(handles.minfreq, 'string'));
maxfr = str2double(get(handles.maxfreq, 'string'));
file_name = handles.file_name;
FrequencyMin = handles.FrequencyMin;
FrequencyMax = handles.FrequencyMax;

fig = figure('visible','off');
xfm = FrequencyMin;
xfp = FrequencyMax;
yfm = -1000;
yfp = 1000;
xfpatch = [xfm xfp xfp xfm];
xypatch = [yfm yfm yfp yfp];

semilogx([Frequency,Frequency],[-1000,1000],'b','linewidth',1)
hold on
ppp=patch(xfpatch,xypatch,'b');
set(ppp,'FaceAlpha',0.2)
hold on
semilogx(frr,newR,'color',[0.5 0.5 0.7])
hold on
semilogx(frr,y, 'r','linewidth',2)
hold on
semilogx(frr,minstd,'k--','linewidth',0.5)
hold on
semilogx(frr,maxstd,'m--','linewidth',0.5)
hold on

title(sprintf('Curve of Amplification: %s',file_name), 'fontsize',12)
xlim([minfr maxfr])
ylim([min(minstd)-0.5 max(maxstd)+0.5])
xlabel('Frequency (Hz)','fontsize',10)
ylabel('H/V','fontsize',10)
legend('F0','F0 std','Raw H/V','Smoothed H/V','Min Std','Max Std','Location','best')
grid minor

% AxesPos = get(handles.hvplot, 'Position');
% fig = getframe(gca, [-35 -45 AxesPos(3)*600 AxesPos(4)*480]);
% Image = frame2im(fig);

[filename,pathname] = uiputfile({'*.png','PNG';...
    '*.jpeg','JPEG'},...
    'Save H/V Graph');
format_image = filename(1:length(filename)-4);
if isequal([filename,pathname],[0,0])
    return
end

file = fullfile(pathname,filename);
% print(fig,file,'-dpng')
% saveas(fig,file,'png')
fmt = "png";
if format_image == fmt
%     imwrite(Image,file, 'XResolution',0.05, 'YResolution', 0.05)
    print(fig, '-dpng',file);
else
%     imwrite(Image,file)
    print(fig, '-djpeg',file);
end

close(fig)

set(handles.info,'string',' H/V graph has been saved...','ForegroundColor','Blue');
guidata(hObject,handles);
% --------------------------------------------------------------------
function resetmenu_Callback(~, ~, handles)
% hObject    handle to resetmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p
user_response = questdlg('Do You Want to Reset the Workspace?','SVIM: Reset','OK','OK');
switch user_response
    case 'OK'
        p.data = [];
        set(handles.filenamebox,'string','');
        set(handles.pathnamebox,'string','');
        set(handles.longitudebox,'string','');
        set(handles.latitudebox,'string','');
        set(handles.dtbox,'string','');
        set(handles.ordebox,'string',num2str(1));
        set(handles.bandpassradio,'value',0);
        set(handles.lowbpbox,'string','');
        set(handles.lowbpbox,'enable','off');
        set(handles.highbpbox,'string','');
        set(handles.highbpbox,'enable','off');
        set(handles.highpassradio,'value',0);
        set(handles.highbox,'string','');
        set(handles.highbox,'enable','off');
        set(handles.lowpassradio,'value',0);
        set(handles.lowbox,'string','');
        set(handles.lowbox,'enable','off');
        set(handles.stabox,'string',num2str(1));
        set(handles.ltabox,'string',num2str(30));
        set(handles.minthresbox,'string',num2str(0.2));
        set(handles.maxthresbox,'string',num2str(2.0));
        set(handles.windowlengthbox,'string',num2str(25));
        set(handles.outputsvim,'Data',[]);
        set(handles.nsamplepop,'value',1);
        set(handles.smoothbandpop,'value',1);
        set(handles.rawdata,'title','Raw Data');
        set(handles.info,'string','');
        set(handles.hvplot,'XMinorGrid','on');
        set(handles.hvplot,'XMinorTick','on');
        set(handles.hvplot,'YMinorGrid','on');
        set(handles.hvplot,'YMinorTick','on');
        legend(handles.hvplot,'hide');
        cla(handles.hvplot,'reset');
        set(handles.hvplot,'XMinorGrid','on');
        set(handles.hvplot,'XMinorTick','on');
        set(handles.hvplot,'YMinorGrid','on');
        set(handles.hvplot,'YMinorTick','on');
        cla(handles.eastsignal,'reset');
        cla(handles.northsignal,'reset');
        cla(handles.verticalsignal,'reset');
        set(handles.eastsignal,'XMinorGrid','on');
        set(handles.eastsignal,'XMinorTick','on');
        set(handles.eastsignal,'YMinorGrid','on');
        set(handles.eastsignal,'YMinorTick','on');
        set(handles.northsignal,'XMinorGrid','on');
        set(handles.northsignal,'XMinorTick','on');
        set(handles.northsignal,'YMinorGrid','on');
        set(handles.northsignal,'YMinorTick','on');
        set(handles.verticalsignal,'XMinorGrid','on');
        set(handles.verticalsignal,'XMinorTick','on');
        set(handles.verticalsignal,'YMinorGrid','on');
        set(handles.verticalsignal,'YMinorTick','on');
        set(handles.info,'BackgroundColor','Cyan');
    case ''
        return
end

function filenamebox_Callback(hObject, eventdata, handles)
% hObject    handle to filenamebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filenamebox as text
%        str2double(get(hObject,'String')) returns contents of filenamebox as a double


% --- Executes during object creation, after setting all properties.
function filenamebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenamebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pathnamebox_Callback(hObject, eventdata, handles)
% hObject    handle to pathnamebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathnamebox as text
%        str2double(get(hObject,'String')) returns contents of pathnamebox as a double


% --- Executes during object creation, after setting all properties.
function pathnamebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathnamebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function longitudebox_Callback(hObject, eventdata, handles)
% hObject    handle to latitudebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of latitudebox as text
%        str2double(get(hObject,'String')) returns contents of latitudebox as a double


% --- Executes during object creation, after setting all properties.
function longitudebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to latitudebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function latitudebox_Callback(hObject, eventdata, handles)
% hObject    handle to latitudebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of latitudebox as text
%        str2double(get(hObject,'String')) returns contents of latitudebox as a double


% --- Executes during object creation, after setting all properties.
function latitudebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to latitudebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dtbox_Callback(hObject, eventdata, handles)
% hObject    handle to dtbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dtbox as text
%        str2double(get(hObject,'String')) returns contents of dtbox as a double


% --- Executes during object creation, after setting all properties.
function dtbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dtbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bandpassradio.
function bandpassradio_Callback(hObject, eventdata, handles)
% hObject    handle to bandpassradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bandpassradio

% Bandpass On
bpfon = get(handles.bandpassradio,'Value');
if bpfon == 1
    set(handles.lowbpbox,'Enable','on');
    set(handles.highbpbox,'Enable','on');
    set(handles.text11, 'Enable','on');
    set(handles.text12, 'Enable','on');
else
    set(handles.lowbpbox,'Enable','off');
    set(handles.highbpbox,'Enable','off');
    set(handles.text11, 'Enable','off');
    set(handles.text12, 'Enable','off');
    set(handles.bandpassradio,'Value',0);
end

% Highpass and Lowpass Off
set(handles.highpassradio,'Value',0);
set(handles.highbox,'Enable','off');
set(handles.lowpassradio,'Value',0);
set(handles.lowbox,'Enable','off');


function lowbpbox_Callback(hObject, eventdata, handles)
% hObject    handle to lowbpbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowbpbox as text
%        str2double(get(hObject,'String')) returns contents of lowbpbox as a double


% --- Executes during object creation, after setting all properties.
function lowbpbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowbpbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function highbpbox_Callback(hObject, eventdata, handles)
% hObject    handle to highbpbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of highbpbox as text
%        str2double(get(hObject,'String')) returns contents of highbpbox as a double


% --- Executes during object creation, after setting all properties.
function highbpbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to highbpbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in highpassradio.
function highpassradio_Callback(hObject, eventdata, handles)
% hObject    handle to highpassradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of highpassradio

% Highpass On
highfon = get(handles.highpassradio,'Value');
if highfon == 1
    set(handles.highbox,'Enable','on');
else
    set(handles.highbox,'Enable','off');
    set(handles.highpassradio,'Value',0);
end

% Bandpass and Lowpass Off
set(handles.bandpassradio,'Value',0)
set(handles.lowbpbox,'Enable','off');
set(handles.highbpbox,'Enable','off');
set(handles.lowpassradio,'Value',0);
set(handles.lowbox,'Enable','off');
set(handles.text11, 'Enable','off');
set(handles.text12, 'Enable','off');


function highbox_Callback(hObject, eventdata, handles)
% hObject    handle to highbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of highbox as text
%        str2double(get(hObject,'String')) returns contents of highbox as a double


% --- Executes during object creation, after setting all properties.
function highbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to highbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lowpassradio.
function lowpassradio_Callback(hObject, eventdata, handles)
% hObject    handle to lowpassradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lowpassradio

% Lowpass On
lowfon = get(handles.lowpassradio,'Value');
if lowfon == 1
    set(handles.lowbox,'Enable','on');
else
    set(handles.lowbox,'Enable','off');
    set(handles.lowpassradio,'Value',0);
end

% Bandpass and Highpass Off
set(handles.bandpassradio,'Value',0);
set(handles.lowbpbox,'Enable','off');
set(handles.highbpbox,'Enable','off');
set(handles.highpassradio,'Value',0);
set(handles.highbox,'Enable','off');
set(handles.text11, 'Enable','off');
set(handles.text12, 'Enable','off');


function lowbox_Callback(hObject, eventdata, handles)
% hObject    handle to lowbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowbox as text
%        str2double(get(hObject,'String')) returns contents of lowbox as a double


% --- Executes during object creation, after setting all properties.
function lowbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stabox_Callback(hObject, eventdata, handles)
% hObject    handle to stabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stabox as text
%        str2double(get(hObject,'String')) returns contents of stabox as a double


% --- Executes during object creation, after setting all properties.
function stabox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ltabox_Callback(hObject, eventdata, handles)
% hObject    handle to ltabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ltabox as text
%        str2double(get(hObject,'String')) returns contents of ltabox as a double


% --- Executes during object creation, after setting all properties.
function ltabox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ltabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minthresbox_Callback(hObject, eventdata, handles)
% hObject    handle to minthresbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minthresbox as text
%        str2double(get(hObject,'String')) returns contents of minthresbox as a double


% --- Executes during object creation, after setting all properties.
function minthresbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minthresbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxthresbox_Callback(hObject, eventdata, handles)
% hObject    handle to maxthresbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxthresbox as text
%        str2double(get(hObject,'String')) returns contents of maxthresbox as a double


% --- Executes during object creation, after setting all properties.
function maxthresbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxthresbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowlengthbox_Callback(hObject, eventdata, handles)
% hObject    handle to windowlengthbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowlengthbox as text
%        str2double(get(hObject,'String')) returns contents of windowlengthbox as a double


% --- Executes during object creation, after setting all properties.
function windowlengthbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowlengthbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nsamplepop.
function nsamplepop_Callback(hObject, eventdata, handles)
% hObject    handle to nsamplepop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nsamplepop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nsamplepop


% --- Executes during object creation, after setting all properties.
function nsamplepop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nsamplepop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in smoothbandpop.
function smoothbandpop_Callback(hObject, eventdata, handles)
% hObject    handle to smoothbandpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns smoothbandpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from smoothbandpop


% --- Executes during object creation, after setting all properties.
function smoothbandpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothbandpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ordebox_Callback(hObject, eventdata, handles)
% hObject    handle to ordebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ordebox as text
%        str2double(get(hObject,'String')) returns contents of ordebox as a double


% --- Executes during object creation, after setting all properties.
function ordebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ordebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function exitmenu_Callback(hObject, eventdata, handles)
% hObject    handle to exitmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_response = questdlg('Do You Want to Close?','SVIM: Exit','OK','OK');
switch user_response
    case 'OK'
        ck = exist('store.txt','file');
        if ck == 2
            delete store.txt
            close(SVIM)
        else
            close(SVIM)
        end
    case ''
        return
end

% --------------------------------------------------------------------
function plotmap_Callback(hObject, eventdata, handles)
% hObject    handle to plotmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mapsvim

% --------------------------------------------------------------------
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d{1} = handles.d{1};
d{2} = handles.d{2};
d{3} = handles.d{3};
x{1} = handles.x{1};
x{2} = handles.x{2};
x{3} = handles.x{3};
% filename = handles.filename;

long = str2double(get(handles.longitudebox,'string'));
lat = str2double(get(handles.latitudebox,'string'));
dt = str2double(get(handles.dtbox,'string'));
orde = str2double(get(handles.ordebox,'string'));
sta = str2double(get(handles.stabox, 'string'));
lta = str2double(get(handles.ltabox, 'string'));
minsta = str2double(get(handles.minthresbox, 'string'));
maxsta = str2double(get(handles.maxthresbox, 'string'));
lwin = str2double(get(handles.windowlengthbox,'string'));
file_name = get(handles.filenamebox,'string');
numsamp = get(handles.nsamplepop, 'Value');
bandsmooth = get(handles.smoothbandpop,'value');
bpfon = get(handles.bandpassradio,'Value');
highfon = get(handles.highpassradio,'Value');
lowfon = get(handles.lowpassradio,'Value');
minfr = str2double(get(handles.minfreq, 'string'));
maxfr = str2double(get(handles.maxfreq, 'string'));

if isempty(long) || isnan(long)
    warndlg('Warning: Longitude is empty','SVIM: Alert','modal');
    return
elseif isempty(lat) || isnan(lat)
    warndlg('Warning: Latitude is empty','SVIM: Alert','modal');
    return
elseif isempty(dt) || isnan(dt)
    warndlg('Warning: Sampling time is empty','SVIM: Alert','modal');
    return
elseif isempty(orde) || isnan(orde)
    warndlg('Warning: Orde is empty','SVIM: Alert','modal');
    return
elseif isempty(sta) || isnan(sta)
    warndlg('Warning: STA window is empty','SVIM: Alert','modal');
    return
elseif isempty(lta) || isnan(lta)
    warndlg('Warning: LTA window is empty','SVIM: Alert','modal');
    return
elseif isempty(minsta) || isnan(minsta)
    warndlg('Warning: Minimum threshold is empty','SVIM: Alert','modal');
    return
elseif isempty(maxsta) || isnan(maxsta)
    warndlg('Warning: Maximum threshold is empty','SVIM: Alert','modal');
    return
elseif isempty(lwin) || isnan(lwin)
    warndlg('Warning: Window length is empty','SVIM: Alert','modal');
    return
elseif numsamp == 1
    warndlg('Warning: Number of sample is empty','SVIM: Alert','modal');
    return
elseif bandsmooth == 1
    warndlg('Warning: Bandwidth for smoothing is empty','SVIM: Alert','modal');
    return
end

set(handles.info,'string',' Process is starting...','ForegroundColor','White','BackgroundColor','Red');
if numsamp == 2
    ns = 512;
elseif numsamp == 3
    ns = 1024;
elseif numsamp == 4
    ns = 2048;
elseif numsamp == 5
    ns = 4096;
end

if bandsmooth == 2
    b = 10;
elseif bandsmooth == 3
    b = 20;
elseif bandsmooth == 4
    b = 30;
elseif bandsmooth == 5
    b = 40;
elseif bandsmooth == 6
    b = 50;
elseif bandsmooth == 7
    b = 60;
end

%% Filter
fs = 1/dt;
nyq = fs/2; % nyquist
if bpfon == 1
    lowf = str2double(get(handles.lowbpbox,'string'));
    highf = str2double(get(handles.highbpbox,'string'));
    fcutlow  = lowf/nyq; %in Hz
    fcuthigh = highf/nyq; %in Hz
    [bb, a]=butter(orde,[fcutlow,fcuthigh]);
    dfilt{1} = filtfilt(bb,a,d{1});
    dfilt{2} = filtfilt(bb,a,d{2});
    dfilt{3} = filtfilt(bb,a,d{3});
    set(handles.rawdata,'Title','Filtered Signal: Bandpass Filter');
elseif highfon == 1
    highf = str2double(get(handles.highbox,'string'));
    fcuthigh = highf/nyq; %in Hz
    [bb, a]=butter(orde,fcuthigh,'high');
    dfilt{1} = filtfilt(bb,a,d{1});
    dfilt{2} = filtfilt(bb,a,d{2});
    dfilt{3} = filtfilt(bb,a,d{3});
    set(handles.rawdata,'Title','Filtred Signal: Highpass Filter');
elseif lowfon == 1
    lowf = str2double(get(handles.lowbox,'string'));
    fcutlow = lowf/nyq; %in Hz
    [bb, a]=butter(orde,fcutlow,'low');
    dfilt{1} = filtfilt(bb,a,d{1});
    dfilt{2} = filtfilt(bb,a,d{2});
    dfilt{3} = filtfilt(bb,a,d{3});
    set(handles.rawdata,'Title','Filtred Signal: Lowpass Filter');
end

% Plot the filtered waveform
axes(handles.eastsignal)
plot(x{1},dfilt{1},'r')
grid minor
ylabel('E')
axis([min(x{1}) max(x{1}) min(dfilt{1}) max(dfilt{1})])

axes(handles.northsignal)
plot(x{2},dfilt{2},'r')
grid minor
ylabel('N')
axis([min(x{2}) max(x{2}) min(dfilt{2}) max(dfilt{2})])
axes(handles.verticalsignal)

plot(x{3},dfilt{3},'r')
grid minor
ylabel('V')
xlabel('Time (Second)')
axis([min(x{3}) max(x{3}) min(dfilt{3}) max(dfilt{3})])

%% MAKE SAME LENGTH TO EACH WAVEFORM (ZERO PADDING)
if length(dfilt{1}) == length(dfilt{2})
    residu1_wf = 0;
    residu2_wf = 0;
end

if length(dfilt{1}) == length(dfilt{3})
    residu1_wf = 0;
    residu3_wf = 0;
end

if length(dfilt{2}) == length(dfilt{3})
    residu2_wf = 0;
    residu3_wf = 0;
end

if length(dfilt{1}) > length(dfilt{2})
    residu2_wf = length(dfilt{1}) - length(dfilt{2});
    residu1_wf = 0;
else
    residu1_wf = length(dfilt{2}) - length(dfilt{1});
    residu2_wf = 0;
end

if length(dfilt{1}) > length(dfilt{3})
    residu3_wf = length(dfilt{1}) - length(dfilt{3});
    residu1_wf = 0;
else
    residu1_wf = length(dfilt{3}) - length(dfilt{1});
    residu3_wf = 0;
end

%% WINDOWING WITH ANTRIG FUNCTION
W{1} = [dfilt{1};NaN(residu1_wf,1)];
W{2} = [dfilt{2};NaN(residu2_wf,1)];
W{3} = [dfilt{3};NaN(residu3_wf,1)];

ww = [W{1},W{2},W{3}];
ww = median(transpose(ww));

[rE,~,~,~] = antrig1(W{1},sta,lta,dt,minsta,maxsta,lwin);
[rN,~,~,~] = antrig1(W{2},sta,lta,dt,minsta,maxsta,lwin);
[rZ,~,~,~] = antrig1(W{3},sta,lta,dt,minsta,maxsta,lwin);
[~,time,events,NW] = antrig1(ww,sta,lta,dt,minsta,maxsta,lwin);

iN = 1;
jN = 1;
new_events = [0,0];
while iN <= NW
    if (rE(events(iN,1):events(iN,2)) >= minsta) & (rE(events(iN,1):events(iN,2)) <= maxsta)
        if (rN(events(iN,1):events(iN,2)) >= minsta) & (rN(events(iN,1):events(iN,2)) <= maxsta)
            if (rZ(events(iN,1):events(iN,2)) >= minsta) & (rZ(events(iN,1):events(iN,2)) <= maxsta)
                selectN = iN;
                new_events(jN,:) = [events(selectN,1),events(selectN,2)];
                jN = jN+1;
            end
        end
    end
    iN = iN + 1;
end
NW = jN-1;
events = new_events;

axes(handles.eastsignal)
set(handles.eastsignal, 'NextPlot', 'replace');
colors = patchcolors(NW);
gain = 10000;
for u = 1:NW
%     hold on
    xa = time(events(u:u,1));
    xb = time(events(u:u,2));
    ya = gain*min(ww);
    yb = gain*max(ww);
    xpatch = [xa xb xb xa];
    ypatch = [ya ya yb yb];
    pp=patch(xpatch,ypatch,colors(u,:));
    set(pp,'FaceAlpha',0.5)
end

axes(handles.northsignal)
set(handles.northsignal, 'NextPlot', 'replace');
colors = patchcolors(NW);
for u = 1:NW
%     hold on
    xa = time(events(u:u,1));
    xb = time(events(u:u,2));
    ya = gain*min(ww);
    yb = gain*max(ww);
    xpatch = [xa xb xb xa];
    ypatch = [ya ya yb yb];
    pp=patch(xpatch,ypatch,colors(u,:));
    set(pp,'FaceAlpha',0.5)
end

axes(handles.verticalsignal)
set(handles.verticalsignal, 'NextPlot', 'replace');
colors = patchcolors(NW);
for u = 1:NW
%     hold on
    xa = time(events(u:u,1));
    xb = time(events(u:u,2));
    ya = gain*min(ww);
    yb = gain*max(ww);
    xpatch = [xa xb xb xa];
    ypatch = [ya ya yb yb];
    pp=patch(xpatch,ypatch,colors(u,:));
    set(pp,'FaceAlpha',0.5)
end

%%  cosine window
E = zeros(lwin/dt,NW);
N = zeros(lwin/dt,NW); 
Z = zeros(lwin/dt,NW);

a = 0.5;
ncos = length(E);
coswin = cosinewin(a,ncos);

for index = 1:NW
    E(:,index) = dfilt{1}(events(index,1):events(index,2));
    E(:,index) = E(:,index).*coswin;
    N(:,index) = dfilt{2}(events(index,1):events(index,2));
    N(:,index) = N(:,index).*coswin;
    Z(:,index) = dfilt{3}(events(index,1):events(index,2));
    Z(:,index) = Z(:,index).*coswin;
end

l_d1 = length(W{1});
l_d2 = length(W{2});
l_d3 = length(W{3});

time1 = ((1:l_d1)*dt)'; % Second
time2 = ((1:l_d2)*dt)'; % Second
time3 = ((1:l_d3)*dt)'; % Second
timen = [time1,time2,time3];

%% FFT PROCESS
nfft = 10240;
dim = 2;
East = fft(E',nfft,dim);
North = fft(N',nfft,dim);
Vertical = fft(Z',nfft,dim);

E_spektrum = abs(East);
N_spektrum = abs(North);
V_spektrum = abs(Vertical);
%% SMOOTHING SPECTRUM
samprate = 1/dt;
fspektrum = linspace(minfr,samprate,length(E_spektrum));
[~,ndx] = (min(abs(fspektrum - maxfr)));
% fsmooth = linspace(minfr,maxf,ndx);

E_spek_smooth = zeros(NW,ndx);
N_spek_smooth = zeros(NW,ndx);
V_spek_smooth = zeros(NW,ndx);
for i = 1:NW
    E_spek_smooth(i,:) = kosmooth(E_spektrum(i,1:ndx),b);
    N_spek_smooth(i,:) = kosmooth(N_spektrum(i,1:ndx),b);
    V_spek_smooth(i,:) = kosmooth(V_spektrum(i,1:ndx),b);
end
%% Merging Horizontal Component
AH = sqrt((E_spek_smooth.^2 + N_spek_smooth.^2)/2);
AV= V_spek_smooth;
%% Calculating H/V
if NW == 1
    ratio = ((AH./AV));
    R = ratio;
else
    ratio = ((AH./AV));
    R = median(ratio);
end

% Replace NaN with 0
R(isnan(R)) = 0;
ratio(isnan(ratio)) = 0;
%% RESAMPLE NUMBER OF SAMPLE
newR = interp1(1:length(R),R,linspace(1,length(R),ns));
newallratio = zeros(NW,ns);
for i = 1:NW
    newallratio(i,:) = interp1(1:length(ratio(i,:)),ratio(i,:),linspace(1,length(ratio(i,:)),ns));
end
%% SMOOTHING KONNO-OHMACHI
% [y,~] = kosmooth(R,b);
[y,~] = kosmooth(newR,b);
frr = linspace(minfr,maxfr,ns); % for resample frequency
fr = linspace(minfr,(1/dt),length(R)); % for original frequency
%% STANDARD DEVIATION
nfr = length(frr);
stdr = zeros(size(frr));
for kk = 1:ns
    stdr(:,kk) = sqrt(sum((newallratio(:,kk)-newR(:,kk)).^2)/(nfr));
end
[stdr,~] = kosmooth(stdr,b);
minstd = (y-stdr);
maxstd = (y+stdr);
%% FIND AMPLIFICATION AND FREQUENCY
[Amplification,Index] = max(y);
Frequency = frr(Index);
if Index == length(y)
   [Amplification,Index] = max(y(1:floor(length(y)/2)));
   Frequency = frr(Index);
end
%% KG CALCULATION
SVI = (Amplification.^2/Frequency);
%% FIND STD OF THE FREQUENCY (f0) FROM EACH WINDOW
AmplificationRatio = zeros(NW,1);
IndexRatio = zeros(NW,1);
FrequencyRatio = zeros(NW,1);
yratio = zeros(NW,length(ratio));
yrat = zeros(NW,ns);

for ll = 1:NW
    [yratio(ll,:),~] = kosmooth(ratio(ll,:),b);
    yrat(ll,:) = interp1(1:length(yratio(ll,:)),yratio(ll,:),linspace(1,length(yratio(ll,:)),ns));
    [AmplificationRatio(ll,:),IndexRatio(ll,:)] = max(yrat(ll,:));
    FrequencyRatio(ll,:) = frr(IndexRatio(ll,:));
    if IndexRatio(ll,:) == length(yrat(ll,:))
        [AmplificationRatio(ll,:),IndexRatio(ll,:)] = max(yrat(ll,:));
        FrequencyRatio(ll,:) = frr(IndexRatio(ll,:));
    end
end
stdfreqratio = sqrt(sum((FrequencyRatio-median(FrequencyRatio)).^2)/(NW));
FrequencyMin = Frequency/stdfreqratio;
FrequencyMax = Frequency*stdfreqratio;

% reverse the value of std(f0) if FreqMin > FreqMax
if FrequencyMin > FrequencyMax
    FrequencyMinStore = FrequencyMin;
    FrequencyMin = FrequencyMax;
    FrequencyMax = FrequencyMinStore;
end

% Avoid if FreqMax > Boundary Freq Plot
if FrequencyMax > maxfr
    FrequencyMax = FrequencyMax - (FrequencyMax-maxfr);
end
%% H/V CURVE
xfm = FrequencyMin;
xfp = FrequencyMax;
yfm = -1000;
yfp = 1000;
xfpatch = [xfm xfp xfp xfm];
xypatch = [yfm yfm yfp yfp];

axes(handles.hvplot);
set(handles.hvplot, 'NextPlot', 'replace');

semilogx([Frequency,Frequency],[-10e+3,10e+3],'b','linewidth',1)
hold on
ppp=patch(xfpatch,xypatch,'b');
set(ppp,'FaceAlpha',0.2)
hold on;
semilogx(frr,newR,'color',[0.5 0.5 0.7])
hold on
semilogx(frr,y, 'r','linewidth',2)
hold on
semilogx(frr,minstd,'k--','linewidth',1)
hold on
semilogx(frr,maxstd,'m--','linewidth',1)
title(sprintf('Curve of Amplification: %s',file_name), 'fontsize',12)
axis([minfr maxfr min(minstd)-0.5 max(maxstd)+0.5])
xlabel('Frequency (Hz)','fontsize',10)
ylabel('H/V','fontsize',10)
legend('F0','F0 std','Raw H/V','Smoothed H/V','Min Std','Max Std','Location','best')
grid minor
%% STORE DATA TO TABLE
global p
output = [long,lat,NW,Frequency,stdfreqratio,FrequencyMin,FrequencyMax,Amplification,SVI];
dat = num2cell(output);
p.data = [p.data;[file_name dat]];
set(handles.outputsvim,'data',p.data)

handles.long = long;
handles.lat = lat;
handles.NW = NW;
handles.lwin = lwin;
handles.Frequency = Frequency;
handles.stdfreqratio = stdfreqratio;
handles.FrequencyMin = FrequencyMin;
handles.FrequencyMax = FrequencyMax;
handles.Amplification = Amplification;
handles.SVI = SVI;
handles.output = output;
% handles.data = data;
handles.minfr = minfr;
handles.maxfr = maxfr;
handles.frr = frr;
handles.newR = newR;
handles.y = y;
handles.minstd = minstd;
handles.maxstd = maxstd;
handles.file_name = file_name;
% handles.fname = fname;

set(handles.info,'string',' Process is complete...','ForegroundColor','Black','BackgroundColor','Cyan');

guidata(hObject, handles);

% --------------------------------------------------------------------
function savetablemenu_Callback(hObject, eventdata, handles)
% hObject    handle to savetablemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uiputfile({'*.txt';...
    '*.dat'},...
    'Save Output Data');
if isequal([filename,pathname],[0,0])
    return
else
    file = fullfile(pathname,filename);
    datan = get(handles.outputsvim,'data');
    Station = datan(:,1);
    LONG = datan(:,2);
    LAT = datan(:,3);
    WIN = datan(:,4);
    F0 = datan(:,5);
    STDF0 = datan(:,6);
    F0MIN = datan(:,7);
    F0MAX = datan(:,8);
    A0 = datan(:,9);
    Kg = datan(:,10);
    writetable(table(Station,LONG,LAT,WIN,F0,STDF0,F0MIN,F0MAX,A0,Kg),file);
    set(handles.info,'string',' Output data has been saved...','ForegroundColor','Black');

    handles.Station = Station;
    handles.LONG = LONG;
    handles.LAT = LAT;

    guidata(hObject,handles);
end

% --------------------------------------------------------------------
function menuprocess_Callback(hObject, eventdata, handles)
% hObject    handle to menuprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function savehvmenu_Callback(hObject, eventdata, handles)
% hObject    handle to savehvmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datan = get(handles.outputsvim,'data');
% file_name = handles.file_name;
% long = handles.long;
% lat = handles.lat;
Station = cell2mat(datan(end,1));
LONG = cell2mat(datan(end,2));
LAT = cell2mat(datan(end,3));
frr = (handles.frr);
newR = (handles.newR);
y = (handles.y);
minstd = (handles.minstd);
maxstd = (handles.maxstd);
NW = handles.NW;
lwin = handles.lwin;
Frequency = handles.Frequency;
SVI = handles.SVI;
stdfreqratio = handles.stdfreqratio;
FrequencyMin = handles.FrequencyMin;
FrequencyMax = handles.FrequencyMax;
Amplification = handles.Amplification;


[filename,pathname] = uiputfile({'*.txt','TXT';...
    '*.dat','DAT'},...
    'Save H/V Data');
if isequal([filename,pathname],[0,0])
    return
end

file = fullfile(pathname,filename);
foutHV = fopen(file,'w');

HeadInfo = 'Seismic Vulnerability Index of Microtremor (SVIM) Output';
StatName = 'Station = ';
LongitudeS = 'Longitude = ';
LatitudeS = 'Latitude = ';
WindowInfo = 'Window = ';
LengthWindow = 'Length Window = ';
STDF0Info = 'Standard Deviation (F0) = ';
A0Info = 'A0 = ';
F0Info = 'F0 = ';
KgInfo = 'Kg = ';
FminInfo = 'Fmin = ';
FmaxInfo = 'Fmax = ';
head = 'Freq     H/V      SpecH/V  MinStd   MaxStd';
fprintf(foutHV,'%s\n', HeadInfo);
fprintf(foutHV,'%s %s', StatName,Station);
fprintf(foutHV,'\n%s %f', LongitudeS,LONG);
fprintf(foutHV,'\n%s %f', LatitudeS,LAT);
fprintf(foutHV,'\n%s %d', WindowInfo,NW);
fprintf(foutHV,'\n%s %d', LengthWindow,lwin);
fprintf(foutHV,'\n%s %f', STDF0Info,stdfreqratio);
fprintf(foutHV,'\n%s %f', A0Info,Amplification);
fprintf(foutHV,'\n%s %f', F0Info,Frequency);
fprintf(foutHV,'\n%s %f', KgInfo,SVI);
fprintf(foutHV,'\n%s %f', FminInfo,FrequencyMin);
fprintf(foutHV,'\n%s %f', FmaxInfo,FrequencyMax);
fprintf(foutHV,'\n%s %s %s %s %s', head);
fprintf(foutHV, '\n%f %f %f %f %f', [frr;y;newR;minstd;maxstd]);
fclose(foutHV);
set(handles.info,'string',' H/V data has been saved...','ForegroundColor','Blue');

handles.Frequency = Frequency;
handles.frr = frr;
handles.newR = newR;
handles.y = y;
handles.minstd = minstd;
handles.maxstd = maxstd;
handles.FrequencyMin = FrequencyMin;
handles.FrequencyMax = FrequencyMax;

guidata(hObject,handles);


% --------------------------------------------------------------------
function loadhvdata_Callback(hObject, eventdata, handles)
% hObject    handle to loadhvdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name,pathname] = uigetfile({'*.txt','TXT';...
    '*.dat','DAT'},...
    'Load H/V Data');

if isequal([file_name,pathname],[0,0])
    return
end

set(handles.filenamebox,'string',file_name);
set(handles.pathnamebox,'string',pathname);
data = fullfile(pathname,file_name);
% Read Header
station = file_name(1:end-4);
longitude = dlmread(data,' ',[2 3 2 3]);
latitude = dlmread(data,' ',[3 3 3 3]);
NW = dlmread(data,' ',[4 3 4 3]);
LW = dlmread(data,' ',[5 4 5 4]);
stdf = dlmread(data,' ',[6 5 6 5]);
trace = dlmread(data,' ',13,0);
frr = trace(:,1);
newR = trace(:,2);
y = trace(:,3);
minstd = trace(:,4);
maxstd = trace(:,5);
[~,I] = max(y);
if I == length(y)
    [~,I] = max(y(1:length(y)/2));
end
Amplification = dlmread(data,' ',[7 3 7 3]);
Frequency = dlmread(data,' ',[8 3 8 3]);
stdA = maxstd./y;
Kg = dlmread(data,' ',[9 3 9 3]);
FrequencyMin = dlmread(data,' ',[10 3 10 3]);
FrequencyMax = dlmread(data,' ',[11 3 11 3]);

minfr = min(frr);
maxfr = max(frr);
SVI = (Amplification.^2)/Frequency;
AmplificationS = num2str(Amplification);
FrequencyS = num2str(Frequency);
SVIS = num2str(SVI);
% res = sprintf(' Frequency: %s Hz [%.5f %.5f] | Amplification: %s | Kg: %s', FrequencyS, FrequencyMin,FrequencyMax, AmplificationS, SVIS);
% set(handles.info,'string',res);
res = table(longitude,latitude,NW,Frequency,stdf,FrequencyMin,FrequencyMax,Amplification,Kg);
handles.outputsvim.Data = [station,table2cell(res)];

xfm = FrequencyMin;
xfp = FrequencyMax;
yfm = -1000;
yfp = 1000;
xfpatch = [xfm xfp xfp xfm];
xypatch = [yfm yfm yfp yfp];
axes(handles.hvplot)
set(handles.hvplot, 'NextPlot', 'replace');

% semilogx(frr,newR,'color',[0.5 0.5 0.7])
% hold on
% semilogx(frr,y, 'r','linewidth',2)
% hold on
% semilogx(frr,minstd,'k--','linewidth',0.7)
% hold on
% semilogx(frr,maxstd,'m--','linewidth',0.7)
% hold on
% semilogx([Frequency,Frequency],[-10e+3,10e+3],'b','linewidth',1)
% hold on
% ppp=patch(xfpatch,xypatch,'b');
% set(ppp,'FaceAlpha',0.2)
% title(sprintf('Curve of Amplification: %s',file_name), 'fontsize',12)
% axis([minfr maxfr min(y)-0.5 max(y)+0.5])
% xlabel('Frequency (Hz)','fontsize',15)
% ylabel('H/V','fontsize',15)
% legend('Raw H/V Spectrum','Smoothed H/V Spectrum','Min Std','Max Std','Peak','Location','northwest')
% grid minor


semilogx([Frequency,Frequency],[-1000,1000],'b','linewidth',1)
hold on
ppp=patch(xfpatch,xypatch,'b');
set(ppp,'FaceAlpha',0.2)
hold on
semilogx(frr,newR,'color',[0.5 0.5 0.7])
hold on
semilogx(frr,y, 'r','linewidth',2)
hold on
semilogx(frr,minstd,'k--','linewidth',0.5)
hold on
semilogx(frr,maxstd,'m--','linewidth',0.5)
hold on

title(sprintf('Curve of Amplification: %s',file_name), 'fontsize',12)
xlim([minfr maxfr])
ylim([min(minstd)-0.5 max(maxstd)+0.5])
xlabel('Frequency (Hz)','fontsize',10)
ylabel('H/V','fontsize',10)
legend('F0','F0 std','Raw H/V','Smoothed H/V','Min Std','Max Std','Location','best')
grid minor

handles.Frequency = Frequency;
handles.frr = frr;
handles.newR = newR;
handles.y = y;
handles.minstd = minstd;
handles.maxstd = maxstd;
handles.FrequencyMin = FrequencyMin;
handles.FrequencyMax = FrequencyMax;
handles.maxfr = maxfr;
handles.minfr = minfr;
handles.file_name = file_name;

guidata(hObject,handles);


% --- Executes on button press in importbutton.
function importbutton_Callback(hObject, eventdata, handles)
% hObject    handle to importbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
insertrawmenu_Callback(hObject, eventdata, handles)


% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadhvdata_Callback(hObject, eventdata, handles)


% --- Executes on button press in savegraphbutton.
function savegraphbutton_Callback(hObject, eventdata, handles)
% hObject    handle to savegraphbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savegraphmenu_Callback(hObject, eventdata, handles)


% --- Executes on button press in savedatabutton.
function savedatabutton_Callback(hObject, eventdata, handles)
% hObject    handle to savedatabutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savehvmenu_Callback(hObject, eventdata, handles)


% --- Executes on button press in saveoutputbutton.
function saveoutputbutton_Callback(hObject, eventdata, handles)
% hObject    handle to saveoutputbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savetablemenu_Callback(hObject, eventdata, handles)


% --- Executes on button press in processhvbutton.
function processhvbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processhvbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
process_Callback(hObject, eventdata, handles)


% --- Executes on button press in resetbutton.
function resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resetmenu_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function processhvbutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to processhvbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global p
p.data = [];


% --- Executes on button press in delprev.
function delprev_Callback(hObject, eventdata, handles)
% hObject    handle to delprev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p
p.data(end,:) = [];
handles.outputsvim.Data = p.data;



function minfreq_Callback(hObject, eventdata, handles)
% hObject    handle to minfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minfreq as text
%        str2double(get(hObject,'String')) returns contents of minfreq as a double


% --- Executes during object creation, after setting all properties.
function minfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxfreq_Callback(hObject, eventdata, handles)
% hObject    handle to maxfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxfreq as text
%        str2double(get(hObject,'String')) returns contents of maxfreq as a double


% --- Executes during object creation, after setting all properties.
function maxfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
