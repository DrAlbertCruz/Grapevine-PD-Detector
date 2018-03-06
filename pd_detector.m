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

%% Initialization
% Initialize panes
im_blank = [1];
im_blank_cv = ones(10,100);
imshow( im_blank, [], 'parent', handles.pane_preview );
imshow( im_blank_cv, [], 'parent', handles.cv_control );
imshow( im_blank_cv, [], 'parent', handles.cv_pd );
imshow( im_blank_cv, [], 'parent', handles.cv_blackrot );
imshow( im_blank_cv, [], 'parent', handles.cv_esca );
imshow( im_blank_cv, [], 'parent', handles.cv_leafspot );
% Set previous path to this directory
userData.prevPath = cd;
set( handles.menu_analyzeImage, 'UserData', userData );
% Load the neural network, store it in menu_file
net = load( 'alexNet_Grapevine_PD.mat' );
set( handles.menu_file, 'UserData', net );
% Initialize the CSV
data.data = {[]};
data.data(1,1) = {'Filename'};
data.data(1,2) = {'Black rot confidence'};
data.data(1,3) = {'Control confidence'};
data.data(1,4) = {'Esca confidence'};
data.data(1,5) = {'Leaf spot confidence'};
data.data(1,6) = {'PD confidence'};
data.dataCounter = 2;
set( handles.menu_quit, 'UserData', data );



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
% This callback's 'UserData' contains the previous path.
thisUserData = get( hObject, 'UserData' );
% User data is organized as follows
%   thisUserData.prevPath - The previous path
%   thisUserData.image - The image

% Get experimental results from menu_quit
thisExperimentalResults = get( handles.menu_quit, 'UserData' );

[file,path] = uigetfile( fullfile( thisUserData.prevPath, '*.*' ), 'Load an image...' );

if path ~= 0
    thisUserData.prevPath = path; % Save previous path
    
    try
        FILE_NAME = fullfile( path, file );
        image = fun_preprocessImage( FILE_NAME );
    catch e
        error( 'Error when loading the image in menu_analyzeImage callback.' );
    end
    thisUserData.image = image; % Save image
    
    % Display the image in the preview pane
    try
        imshow( image, [], 'Parent', handles.pane_preview );
    catch e
        error( 'Error when attempting to display preview of image.' );
    end
    
    % Get the network from menu_file
    try
        network = get( handles.menu_file, 'UserData' );
        network = network.results.net;
    catch e
        error( 'Error when attempting to get the network data from handles.menu_file' );
    end
    
    % Do classification
    try
        [~,scores] = classify(network,image);
    catch e
        error( 'Error when doing classification' );
    end
    
    % Set the confidence values
    % Order is as follows:
    %   1 - black rot
    %   2 - control
    %   3 - esca
    %   4 - leaf spot
    %   5 - pd
    try
        % Set the filename
        thisExperimentalResults.data(thisExperimentalResults.dataCounter,1) = ...
            {file};
        for i=1:5
            confValues = zeros(10,100);
            thisScore = scores(i);
            thisScoreText = num2str(thisScore,'%.4f');
            confValues(:,...
                1:round(thisScore*100)+1 ) = 1;
            switch i
                case 1
                    imshow( confValues, [], 'parent', handles.cv_blackrot );
                    set( handles.val_blackrot, 'String', thisScoreText );
                    thisExperimentalResults.data(thisExperimentalResults.dataCounter,2) = ...
                        {thisScore};
                case 2
                    imshow( confValues, [], 'parent', handles.cv_control );
                    set( handles.val_control, 'String', thisScoreText );
                    thisExperimentalResults.data(thisExperimentalResults.dataCounter,3) = ...
                        {thisScore};
                case 3
                    imshow( confValues, [], 'parent', handles.cv_esca );
                    set( handles.val_esca, 'String', thisScoreText );
                    thisExperimentalResults.data(thisExperimentalResults.dataCounter,4) = ...
                        {thisScore};
                case 4
                    imshow( confValues, [], 'parent', handles.cv_leafspot );
                    set( handles.val_leafspot, 'String', thisScoreText );
                    thisExperimentalResults.data(thisExperimentalResults.dataCounter,5) = ...
                        {thisScore};
                otherwise
                    imshow( confValues, [], 'parent', handles.cv_pd );
                    set( handles.val_pd, 'String', thisScoreText );
                    thisExperimentalResults.data(thisExperimentalResults.dataCounter,6) = ...
                        {thisScore};
            end
        end
    catch e
        error( 'Error when setting confidence images' );
    end
end

% Save user data
thisExperimentalResults.dataCounter = thisExperimentalResults.dataCounter + 1;
set( hObject, 'UserData', thisUserData );
set( handles.menu_quit, 'UserData', thisExperimentalResults );


% --------------------------------------------------------------------
function menu_quit_Callback(hObject, eventdata, handles)
thisResults = get( hObject, 'UserData' );
x = inputdlg('Enter file name to save experimental results to:',...
             'Filename', [1 50]);
xlswrite( [ cell2mat(x), '.xls' ], thisResults.data );
close all force
