function varargout = mapsvim(varargin)
% MAPSVIM MATLAB code for mapsvim.fig
%      MAPSVIM, by itself, creates a new MAPSVIM or raises the existing
%      singleton*.
%
%      H = MAPSVIM returns the handle to a new MAPSVIM or the handle to
%      the existing singleton*.
%
%      MAPSVIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAPSVIM.M with the given input arguments.
%
%      MAPSVIM('Property','Value',...) creates a new MAPSVIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mapsvim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mapsvim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mapsvim

% Last Modified by GUIDE v2.5 27-Mar-2019 17:48:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mapsvim_OpeningFcn, ...
                   'gui_OutputFcn',  @mapsvim_OutputFcn, ...
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


% --- Executes just before mapsvim is made visible.
function mapsvim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mapsvim (see VARARGIN)

set(handles.freqmap, 'value', 0);
set(handles.ampmap, 'value', 0);
set(handles.kgmap, 'value', 0);

% Choose default command line output for mapsvim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mapsvim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mapsvim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function mapfilename_Callback(hObject, eventdata, handles)
% hObject    handle to mapfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapfilename as text
%        str2double(get(hObject,'String')) returns contents of mapfilename as a double


% --- Executes during object creation, after setting all properties.
function mapfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mapdirectory_Callback(hObject, eventdata, handles)
% hObject    handle to mapdirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapdirectory as text
%        str2double(get(hObject,'String')) returns contents of mapdirectory as a double


% --- Executes during object creation, after setting all properties.
function mapdirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapdirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browsebutton.
function browsebutton_Callback(hObject, eventdata, handles)
% hObject    handle to browsebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.txt','TXT';...
    '*.dat','DAT'},...
    'Load SVIM Data');
 
if isequal([filename,pathname],[0,0])
    return
end

set(handles.mapfilename,'string',filename);
set(handles.mapdirectory,'string',pathname);
data = readtable(fullfile(pathname,filename));

% store to table
handles.svimtbl.Data = [table2cell(data(:,1)) table2cell(data(:,2)) table2cell(data(:,3)) table2cell(data(:,4)) table2cell(data(:,5)) table2cell(data(:,6)) table2cell(data(:,7)) table2cell(data(:,8)) table2cell(data(:,9)) table2cell(data(:,10))];
set(handles.info,'string',' SVIM data has been loaded...','ForegroundColor','Blue');
% convert table2struct for acessing to plot
ndata = table2struct(data);

% Take the field of struct
namefile = data.Station;
long = [ndata(1:end).LONG];
lat = [ndata(1:end).LAT];
win = [ndata(1:end).WIN];
freq = [ndata(1:end).F0];
amp = [ndata(1:end).A0];
kg = [ndata(1:end).Kg];

handles.namefile = namefile;
handles.long = long;
handles.lat = lat;
handles.win = win;
handles.freq = freq;
handles.amp = amp;
handles.kg = kg;

guidata(hObject,handles);

% --- Executes on button press in resetbutton.
function resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mapfilename,'string','');
set(handles.mapdirectory,'string','');
set(handles.info,'string','');
set(handles.panelmap,'title','SVIM MAP');
set(handles.svimtbl,'Data',[]);
set(handles.griddata,'Data',[],'ColumnName',{'Longitude','Latitude','Parameter'});
cla(handles.mapplot,'reset');
colorbar(handles.mapplot,'hide');
set(handles.show,'value',0);
set(handles.spacec,'value',1);
set(handles.gridc,'value',1);
set(handles.freqmap,'value',0);
set(handles.kgmap,'value',0);
set(handles.ampmap,'value',0);


% --- Executes on button press in savemapbutton.
function savemapbutton_Callback(hObject, eventdata, handles)
% hObject    handle to savemapbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% namefile = handles.namefile;
% long = handles.long;
% lat = handles.lat;
mapdata = get(handles.svimtbl,'data');
namefile = mapdata(:,1);
long = cell2mat(mapdata(:,2));
lat = cell2mat(mapdata(:,3));
space = handles.space;
kg = handles.kg;
amp = handles.amp;
freq = handles.freq;
X = handles.X;
Y = handles.Y;
Z = handles.Z;
kmap = get(handles.kgmap,'value');
amap = get(handles.ampmap,'value');
fmap = get(handles.freqmap,'value');
shw = get(handles.show,'value');

lstat = cellfun('length',namefile);
for i = 1:length(namefile)
    nstat(i,:) = namefile(i,:);
end

if kmap == 1
    fig = figure('visible','off');
    [C,h] = contourf(X,Y,Z,space);
    if shw == 1
        hold on
        plot(long,lat,'vk','markerfacecolor','g','markersize',8); % coordinate
        hold on
        text(long,lat,nstat,'FontSize',7,'Color','k')
    end 
    colormap(cool)
    c = colorbar;
    clabel(C,h,kg);
    xlabel('Longitude')
    ylabel('Latitude')
    ylabel(c,'Seismic Vulnerability Index (Kg)');
    axis([min(long)-0.004 max(long)+0.004 min(lat)-0.002 max(lat)+0.002])
    
    [filename,pathname] = uiputfile({'*.png','PNG'},...
        'Save Seismic Vulnerability Index Map');
    
    if isequal([filename,pathname],[0,0])
        return
    end
    
    file = fullfile(pathname,filename);
    
    print(fig, '-dpng',file);
    close(fig)
elseif amap == 1;
    fig = figure('visible','off');
    [C,h] = contourf(X,Y,Z,space);
    if shw == 1;
        hold on
        plot(long,lat,'vk','markerfacecolor','g','markersize',8); % coordinate
        hold on
        text(long,lat,nstat,'FontSize',7,'Color','k')
    end 
    colormap(cool)
    c = colorbar;
    clabel(C,h,amp);
    xlabel('Longitude')
    ylabel('Latitude')
    ylabel(c,'Amplification');
    axis([min(long)-0.004 max(long)+0.004 min(lat)-0.002 max(lat)+0.002])
    
    [filename,pathname] = uiputfile({'*.png','PNG'},...
        'Save Amplification Map');
    
    if isequal([filename,pathname],[0,0])
        return
    end
    
    file = fullfile(pathname,filename);
    
    print(fig, '-dpng',file);
    close(fig)
elseif fmap == 1;
    fig = figure('visible','off');
    [C,h] = contourf(X,Y,Z,space);
    if shw == 1;
        hold on
        plot(long,lat,'vk','markerfacecolor','g','markersize',8); % coordinate
        hold on
        text(long,lat,nstat,'FontSize',7,'Color','k')
    end 
    colormap(cool)
    c = colorbar;
    clabel(C,h,freq);
    xlabel('Longitude')
    ylabel('Latitude')
    ylabel(c,'Frequency Dominant (Hz)');
    axis([min(long)-0.004 max(long)+0.004 min(lat)-0.002 max(lat)+0.002])
    
    [filename,pathname] = uiputfile({'*.png','PNG'},...
        'Save Frequency Dominant Map');
    
    if isequal([filename,pathname],[0,0])
        return
    end
    
    file = fullfile(pathname,filename);
    
    print(fig, '-dpng',file);
    close(fig)
end


% --- Executes on button press in exitbutton.
function exitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_response = questdlg('Do You Want to Close SVIM-Map?','SVIM-Map: Exit','OK','OK');
switch user_response
    case 'OK'
        ck = exist('store.txt','file');
        if ck == 2
            delete store.txt
            close(mapsvim)
        else
            close(mapsvim)
        end
    case ''
        return
end

% --- Executes on button press in kgmap.
function kgmap_Callback(hObject, eventdata, handles)
% hObject    handle to kgmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mapdata = get(handles.svimtbl,'data');
long = cell2mat(mapdata(:,2));
lat = cell2mat(mapdata(:,3));
kg = cell2mat(mapdata(:,10));
spc = get(handles.spacec,'value');
if spc == 2
    space = 10;
elseif spc == 3
    space = 20;
elseif spc == 4
    space = 30;
elseif spc == 5
    space = 40;
elseif spc == 6
    space = 50;
end

grd = get(handles.gridc,'value');
if grd == 2
    grid = 50;
elseif grd == 3
    grid = 100;
elseif grd == 4
    grid = 150;
elseif grd == 5
    grid = 200;
end

% USING IDW FUNCTION
[X,Y,Z,w,d,N] = idw1(long,lat,kg,2,grid);

set(handles.show,'value',0);
set(handles.mapplot,'nextplot','replace');
axes(handles.mapplot);
[C,h] = contourf(X,Y,Z,space);
colormap(cool)
c = colorbar;
clabel(C,h,kg);
xlabel('Longitude')
ylabel('Latitude')
ylabel(c,'Seismic Vulnerability Index (Kg)');
axis([min(long)-0.004 max(long)+0.004 min(lat)-0.002 max(lat)+0.002])

set(handles.info,'string',' Map of Seismic Vulnerability Index has been plotted');
set(handles.panelmap,'title','SVIM MAP: Seismic Vunerability Index');

XX = reshape(X',[],1);
YY = reshape(Y',[],1);
ZZ = reshape(Z',[],1);
handles.griddata.Data = [XX YY ZZ];
handles.griddata.ColumnName = {'Longitude','Latitude','Kg'};

handles.space = space;
handles.X = X;
handles.Y = Y;
handles.Z = Z;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of kgmap


% --- Executes on button press in ampmap.
function ampmap_Callback(hObject, eventdata, handles)
% hObject    handle to ampmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mapdata = get(handles.svimtbl,'data');
long = cell2mat(mapdata(:,2));
lat = cell2mat(mapdata(:,3));
amp = cell2mat(mapdata(:,9));
spc = get(handles.spacec,'value');
if spc == 2
    space = 10;
elseif spc == 3
    space = 20;
elseif spc == 4
    space = 30;
elseif spc == 5
    space = 40;
elseif spc == 6
    space = 50;
end

grd = get(handles.gridc,'value');
if grd == 2
    grid = 50;
elseif grd == 3
    grid = 100;
elseif grd == 4
    grid = 150;
elseif grd == 5
    grid = 200;
end

% USING IDW FUNCTION
[X,Y,Z,w,d,N] = idw1(long,lat,amp,2,grid);

set(handles.show,'value',0);
set(handles.mapplot,'nextplot','replace');
axes(handles.mapplot);
[C,h] = contourf(X,Y,Z,space);
colormap(cool)
c = colorbar;
clabel(C,h,amp);
xlabel('Longitude')
ylabel('Latitude')
ylabel(c,'Amplification')
axis([min(long)-0.004 max(long)+0.004 min(lat)-0.002 max(lat)+0.002])

set(handles.info,'string',' Map of Amplification has been plotted');
set(handles.panelmap,'title','SVIM MAP: Amplification');

XX = reshape(X',[],1);
YY = reshape(Y',[],1);
ZZ = reshape(Z',[],1);
handles.griddata.Data = [XX YY ZZ];
handles.griddata.ColumnName = {'Longitude','Latitude','Amplification'};

handles.space = space;
handles.X = X;
handles.Y = Y;
handles.Z = Z;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of ampmap


% --- Executes on button press in freqmap.
function freqmap_Callback(hObject, eventdata, handles)
% hObject    handle to freqmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mapdata = get(handles.svimtbl,'data');
long = cell2mat(mapdata(:,2));
lat = cell2mat(mapdata(:,3));
freq = cell2mat(mapdata(:,5));
spc = get(handles.spacec,'value');
if spc == 2
    space = 10;
elseif spc == 3
    space = 20;
elseif spc == 4
    space = 30;
elseif spc == 5
    space = 40;
elseif spc == 6
    space = 50;
end

grd = get(handles.gridc,'value');
if grd == 2
    grid = 50;
elseif grd == 3
    grid = 100;
elseif grd == 4
    grid = 150;
elseif grd == 5
    grid = 200;
end

% USING IDW FUNCTION
[X,Y,Z,w,d,N] = idw1(long,lat,freq,2,grid);

set(handles.show,'value',0);
set(handles.mapplot,'nextplot','replace');
axes(handles.mapplot);
[C,h] = contourf(X,Y,Z,space);
colormap(cool)
c = colorbar;
clabel(C,h,freq);
xlabel('Longitude')
ylabel('Latitude')
ylabel(c,'Frequency Dominant (Hz)')
axis([min(long)-0.004 max(long)+0.004 min(lat)-0.002 max(lat)+0.002])

set(handles.info,'string',' Map of Frequency Dominant has been plotted');
set(handles.panelmap,'title','SVIM MAP: Frequency Dominant');

XX = reshape(X',[],1);
YY = reshape(Y',[],1);
ZZ = reshape(Z',[],1);
handles.griddata.Data = [XX YY ZZ];
handles.griddata.ColumnName = {'Longitude','Latitude','Frequency (Hz)'};

handles.space = space;
handles.X = X;
handles.Y = Y;
handles.Z = Z;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of freqmap


% --- Executes on selection change in spacec.
function spacec_Callback(hObject, eventdata, handles)
% hObject    handle to spacec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spacec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spacec


% --- Executes during object creation, after setting all properties.
function spacec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spacec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mapdata = get(handles.svimtbl,'data');
namefile = mapdata(:,1);
long = cell2mat(mapdata(:,2));
lat = cell2mat(mapdata(:,3));

lstat = cellfun('length',namefile);
for i = 1:length(namefile);
    nstat(i,:) = namefile(i,:);
end

axes(handles.mapplot);
hold on;
p = plot(long,lat,'vk','markerfacecolor','g','markersize',8); % coordinate
set(p,'Tag','p1');
hold on
pp = text(long,lat,nstat,'FontSize',7,'Color','k');
set(pp,'Tag','p2');

stat = get(hObject,'Value');
p = findobj(groot,'Tag','p1');
pp = findobj(groot,'Tag','p2');
if stat == 1
   set(p,'visible','on');
   set(pp,'visible','on');
elseif stat == 0
   set(p,'visible','off');
   delete(pp);
end
% Hint: get(hObject,'Value') returns toggle state of show


% --- Executes on button press in savegrid.
function savegrid_Callback(hObject, eventdata, handles)
% hObject    handle to savegrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
X = handles.X;
Y = handles.Y;
Z = handles.Z;
X = reshape(X',[],1);
Y = reshape(Y',[],1);
Z = reshape(Z',[],1);
datactr = [X Y Z];

[filename,pathname] = uiputfile({'*.txt','TXT';...
    '*.dat','DAT'},...
    'Save Map Data');

if isequal([filename,pathname],[0,0])
    return
end
file = fullfile(pathname,filename);
save(file,'datactr','-ascii');
set(handles.info,'string',' Data map has been saved');


% --- Executes on selection change in gridc.
function gridc_Callback(hObject, eventdata, handles)
% hObject    handle to gridc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns gridc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gridc


% --- Executes during object creation, after setting all properties.
function gridc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
