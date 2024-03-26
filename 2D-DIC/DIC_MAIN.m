close all, clear, clc,
addpath(genpath(cd));

%% read files
Params = readSpeckleImageFiles;
%% DIC matching
DIC(Params)