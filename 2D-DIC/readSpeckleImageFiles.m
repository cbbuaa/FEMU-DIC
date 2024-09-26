function Params = readSpeckleImageFiles()
% first select the refenrence image, and deformed image. The file names are
% selected in Params

% [refFile, imgPath]   = uigetfile({'*.bmp;*.tiff;*.tif'},'Select reference image');
% Params.fileDef_All{1}   = refFile;
% [dataFileAllTemp, imgPath] = uigetfile({'*.bmp;*.tiff;*.tif'},'MultiSelect','on',...
%     'Select deformed images');
% if ~iscell(dataFileAllTemp)
%     Params.fileDef_All{2} = dataFileAllTemp;
% else
%     for i = 1:length(dataFileAllTemp)
%         Params.fileDef_All{i+1} =  dataFileAllTemp{i};
%     end
% end
% Params.Folder        = imgPath;





[dataFileAllTemp, imgPath] = uigetfile({'*.bmp;*.tiff;*.tif;*.png'},'MultiSelect','on',...
    'Select deformed images');

for i = 1:length(dataFileAllTemp)
    Params.fileDef_All{i} =  dataFileAllTemp{i};
end
Params.Folder        = imgPath;
