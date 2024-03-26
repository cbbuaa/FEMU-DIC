function fileCleanAll = getAlldataFileName(folerName,fileExtension)

fileAll = dir(fullfile(folerName,['*.',fileExtension]));
k = 0;
for t = 1:length(fileAll)
    if strcmp(fileAll(t).name(1), '.')
        a = 0;
    else
        k = k+1;
        fileCleanAll(k).name = fullfile(folerName,fileAll(t).name);
    end

end