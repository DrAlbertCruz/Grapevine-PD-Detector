function varargout = pd_detector(varargin)
% PD_DETECTOR MATLAB code for pd_detector.fig
%      PD_DETECTOR, by itself, creates a new PD_DETECTOR or raises the existing
%      singleton*.
%
%      H = PD_DETECTOR returns the handle to a new PD_DETECTOR or the handle to
%      the existing singleton*.
%
%      PD_DETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PD_DETECTOR.M with the given input arguments.
%
%      PD_DETECTOR('Property','Value',...) creates a new PD_DETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pd_detector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pd_detector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pd_detector

% Last Modified by GUIDE v2.5 05-Mar-2018 15:08:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pd_detector_OpeningFcn, ...
                   'gui_OutputFcn',  @pd_detector_OutputFcn, ...
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


% --- Executes just before pd_detector is made visible.
function pd_detector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pd_detector (see VARARGIN)

% Choose default command line output for pd_detector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initialize panes
im_blank = [1];
im_blank_cv = ones(10,100);
imshow( im_blank, [], 'parent', handles.pane_preview );
imshow( im_blank_cv, [], 'parent', handles.cv_control );
imshow( im_blank_cv, [], 'parent', handles.cv_pd );
imshow( im_blank_cv, [], 'parent', handles.cv_blackrot );
imshow( im_blank_cv, [], 'parent', handles.cv_esca );
imshow( im_blank_cv, [], 'parent', handles.cv_leafspot );


% --- Outputs from this function are returned to the command line.
function varargout = pd_detector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_analyzeImage_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile( ...
    { '*.jpg;*.jpeg;*.JPG;*.JPEG', 'Joint Photographic Experts Group (*.jpg, *.jpeg, *.JPG, *.JPEG' } );


% --------------------------------------------------------------------
function menu_quit_Callback(hObject, eventdata, handles)
close all force
