function [] = ConvertMatchIDData(folderName,dataformat,scale)
% this function is used to format the data from MatchID-2D to the required
% format.
% close all, clear, clc, warning off,
% addpath(genpath('..'));

% Create a subfolder to save the VIC data.

folderName_new = fullfile(folderName,'formatVICData');
mkdir(folderName_new);
fileCleanAll = getAlldataFileName(folderName,dataformat);
% scale = 40;

% save the data as the same file name but in the subfolder.
for i = 1:length(fileCleanAll)
    
    [~,filename,ext] = fileparts(fileCleanAll(i).name);
    data = readmatrix(fileCleanAll(i).name);
    dataVIC(i).x = data(:,1)*scale; % coordinate in pixel
    dataVIC(i).y = data(:,2)*scale; % coordinate in pixel
    
    % save some DIC parameters
    dataVIC(i).exx = data(:,5);
    dataVIC(i).eyy = data(:,6);
    dataVIC(i).exy = -data(:,7);

    dataVIC(i).u = data(:,3)*scale;
    dataVIC(i).v = data(:,4)*scale;
    Is_indPtInROI   = find(~isnan(data(:,4)));

    
    dataVIC(i).Is_indPtInROI = Is_indPtInROI;
    DIC_data  = dataVIC(i);
    v         = DIC_data.u;
    u         = DIC_data.v;
    eyy       = DIC_data.exx;
    exy       = DIC_data.exy;
    exx       = DIC_data.eyy;
    y         = DIC_data.x;
    x         = DIC_data.y;

    x_unique = unique(x);
    y_unique = unique(y);
    
    [x_grid,y_grid] = ndgrid(x_unique,y_unique);
    [data_member,indx0] = ismember([x_grid(:),y_grid(:)],[x,y],'rows');
    
    indx1 = find(indx0>0);
    Is_indPtInROI = (indx0>0);
    
    x_new = nan(size(x_grid));
    y_new = nan(size(x_grid));
    u_new = nan(size(x_grid));
    v_new = nan(size(x_grid));
    exx_new = nan(size(x_grid));
    eyy_new = nan(size(x_grid));
    exy_new = nan(size(x_grid));
    

    x_new = x_grid;
    y_new = y_grid;
    u_new(indx1) = u(indx0(indx1));
    v_new(indx1) = v(indx0(indx1));
    exx_new(indx1) = exx(indx0(indx1));
    eyy_new(indx1) = eyy(indx0(indx1));
    exy_new(indx1) = exy(indx0(indx1));

    % Is_indPtInROI = DIC_data.Is_indPtInROI(:);
    comptPoints  = [x_new(:),y_new(:)];
    Disp  = [u_new(:),v_new(:)];
    Strain = [exx_new(:),eyy_new(:),exy_new(:)];
    
    % save file
    dataFile = fullfile(folderName_new,[filename,'.mat']);
    save(dataFile,'comptPoints','Disp','Strain','Is_indPtInROI')
    Params.fileDef_All{i} = dataFile;

end

Params.Step = max(x_new(2)-x_new(1),y_new(2)-y_new(1));
Params.Lx = size(x_new,1);
Params.Ly = size(x_new,2);

Params.strainWin = [1,1]*11;

Params.comptPoints = comptPoints;
Params.ROISize = size(x_new);
file_Params = fullfile(folderName_new,'Params.mat');
Params.file_params_DIC     = file_Params;
save(file_Params,'Params');



