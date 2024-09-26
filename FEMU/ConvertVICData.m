function [] = ConvertVICData(folderName,dataformat,scale)

% this function is used to format the data from VIC-2D to the required
% format.

% Create a subfolder to save the VIC data.
folderName_new = fullfile(folderName,'formatVICData');
mkdir(folderName_new);
fileCleanAll = getAlldataFileName(folderName,dataformat);
% save the data as the same file name but in the subfolder.
for i = 1:length(fileCleanAll)
    
    [~,filename,ext] = fileparts(fileCleanAll(i).name);
    
    data = load(fileCleanAll(i).name);
    dataVIC(i).x = data.x*scale; % coordinate in pixel
    dataVIC(i).y = data.y*scale; % coordinate in pixel

    dataVIC(i).exx = data.exx;
    dataVIC(i).eyy = data.eyy;
    dataVIC(i).exy = -data.exy;

    dataVIC(i).u = data.u*scale;
    dataVIC(i).v = data.v*scale;
    Is_indPtInROI   = (data.gamma~=0);

    
    dataVIC(i).Is_indPtInROI = Is_indPtInROI;
    DIC_data  = dataVIC(i);
    v         = DIC_data.u;
    u         = DIC_data.v;
    eyy       = DIC_data.exx;
    exy       = DIC_data.exy;
    exx       = DIC_data.eyy;
    y         = DIC_data.x;
    x         = DIC_data.y;
    Is_indPtInROI = DIC_data.Is_indPtInROI(:);
    comptPoints  = [x(:),y(:)];
    Disp  = [u(:),v(:)];
    Strain = [exx(:),eyy(:),exy(:)];
    
    % save file
    dataFile = fullfile(folderName_new,[filename,'.mat']);
    save(dataFile,'comptPoints','Disp','Strain','Is_indPtInROI')
    Params.fileDef_All{i} = dataFile;

end

% save some DIC parameters
Params.Step = max(x(2)-x(1),y(2)-y(1));
Params.strainWin = [1,1]*11;
Params.Lx = size(x,1);
Params.Ly = size(x,2);
Params.comptPoints = comptPoints;
Params.ROISize = size(x);
file_Params = fullfile(folderName_new,'Params.mat');
Params.file_params_DIC     = file_Params;
save(file_Params,'Params');



