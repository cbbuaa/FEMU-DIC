function [] = DIC(Params,frameRate)

file_Params          = fullfile(Params.Folder,'Params.mat');
Params.fileNum       = length(Params.fileDef_All);
Params.fileRef       = Params.fileDef_All{1};

refFile              = Params.fileRef;
subplot(1,2,1);
title(refFile);
if ~isfile (file_Params)
    %% Process the reference image
    Params.defFile0      = refFile;
    Params               = paramset(Params);
    
    
    ImRef                = double(imread(fullfile(Params.Folder,refFile)));
    if length(size(ImRef)) == 3
        ImRef            = double(rgb2gray(uint8(ImRef)));
    end
    h                    = fspecial('gaussian',5,1);
    ImRef                = imfilter(ImRef,h);
    
    Params.ImRef         = ImRef;
    hs                   = imshow(repmat(uint8(Params.ImRef),1,1,3));
    
    Params.sizeX         = size(ImRef,1);
    Params.sizeY         = size(ImRef,2);
    
    % Gradient of reference image, needs noly be calculated once
    [gradxImR, gradyImR] = gradImg(ImRef);
    Params.gradxImR      = gradxImR;
    Params.gradyImR      = gradyImR;
    
    
    % Select calculation points on the reference image
    Params               = calcuPt(Params);
    save(file_Params,'Params');
else
    load(file_Params)
    imshow(repmat(uint8(Params.ImRef),1,1,3));
end
Params.frameRate = 1;
if nargin>=2
    Params.frameRate = frameRate;
    save(file_Params,'Params');
end



%% Match each image
for i = 2:Params.frameRate: Params.fileNum
    %     Params0 = Params;
    Params.fileDef = Params.fileDef_All{i};
    
    [~,filename]  = fileparts(Params.fileDef);
    %     Params.fileDef = ['imDef_numerical_',num2str(i+1,'%02d')];
    fileSave = fullfile(Params.Folder,[filename,'.mat']);
    % if the data files have been generated, skip the matching and load the
    % files
    ImDef = double(imread(fullfile(Params.Folder,Params.fileDef)));
    if length(size(ImDef)) == 3
        ImDef              = double(rgb2gray(uint8(ImDef)));
    end
    if isfile (fileSave)
        continue;
        load(fileSave);
        
    else
        Is_indPtInROI = Params.Is_indPtInROI;
        comptPoints   = Params.comptPoints;
        %% Local DIC
        
        [Disp,Strain,ZNCC,iterNum,Params] = DIC_local(Params.Folder,Params.fileDef,Params.ImRef,Params);
        Params.defFile0 = Params.fileDef;
        %         save('Params0.mat','Params0');
        dataFile   = fullfile(Params.Folder,[filename,'.mat']);
        parsave(dataFile,comptPoints,Disp,Strain,ZNCC,iterNum,boolean(Is_indPtInROI));
    end
    plotOnImg(Params, ImDef,comptPoints, Disp,Strain, Params.param_Plot);
    fprintf('%s is matching...\n',Params.fileDef);
end

