close all, clear, clc,
addpath(genpath(cd));

%% read files
Params = readSpeckleImageFiles;
%% DIC matching
frameRate = 1;
DIC(Params,frameRate)