
close all, clear, clc, warning off,
addpath(genpath('..'));
tic

%% Set all parameters below
Params_FEMU.folder_Model = '/Users/binchen/Desktop/FEMU-DIC/Demo';
% Params_FEMU.file_params_DIC  = '/Users/binchen/Desktop/FEMU-DIC/Demo/VirtualImageMatchID/formatVICData/Params.mat';
Params_FEMU.file_params_DIC  = '/Users/binchen/Desktop/FEMU-DIC/Demo/VirtualImageVIC/formatVICData/Params.mat';
% Params_FEMU.file_params_DIC  = '/Users/binchen/Desktop/FEMU-DIC/Demo/VirtualImage/Params.mat';

Params_FEMU.optim_method = 'NM'; % 'GN' or 'NM'
Params_FEMU.costFun      = 'FEMU-εFN';
% other parameters
Params_FEMU.meshFile     = '/Users/binchen/Desktop/FEMU-DIC/Demo/Mesh.nas';
Params_FEMU.folder_Model_results = fullfile(Params_FEMU.folder_Model,'FEA_results');

% Params_FEMU.fileDef_All{1} = '/Users/binchen/Desktop/FEMU-DIC/Demo/VirtualImage/Img_Simu_0001.mat';
Params_FEMU.fileDef_All{1} = '/Users/binchen/Desktop/FEMU-DIC/Demo/VirtualImageVIC/formatVICData/Img_Simu_0001.mat';
% Params_FEMU.fileDef_All{1} = '/Users/binchen/Desktop/FEMU-DIC/Demo/VirtualImageMatchID/formatVICData/Img_Simu_0001.bmp 1.mat';
%% Get some DIC parameters
load(Params_FEMU.file_params_DIC);
Params_FEMU.indx_x_DIC = [1,Params.Lx];
Params_FEMU.indx_y_DIC = [1,Params.Ly];
Params_FEMU.ROISize    = [Params.Lx,Params.Ly];

%% Set parameters
Params_FEMU.SCALE       = 40; % the scale between mm and pixel
Params_FEMU.offset      = [751,301]; % The offset between two coordinate frames
R        = 1.65; % Radius in the open hole.
theta    = 7*pi/12; % Angle of the material
L        = 17; % Length of the sample

p_FEA    = [R;theta;L]; % parameters for FEA

%% set the intial guess for the parameters
Params_FEMU.p_Model_NAME  = {'Ex','Ey','Nu','Gxy'}; % The name of the parameters
Ex = 13.9e9;
Ey = 5e9;
vxy = 0.1;
Gxy = 2e9;
p_Model  = [Ex;Ey;vxy;Gxy]*0.9; % model parameters needing to be determined

% Call FEMU optimization
switch Params_FEMU.optim_method
    case 'GN'
        p_Model_optimum = FEMU_GN(p_Model,p_FEA,Params_FEMU);
    case 'NM'
        p_Model_optimum = FEMU_NM(p_Model,p_FEA,Params_FEMU);
end
display(p_Model_optimum),
toc