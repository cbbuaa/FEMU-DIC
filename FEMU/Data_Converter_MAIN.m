close all, clear, clc, warning off,
addpath(genpath('..'));

software = 'VIC';
% software = 'MatchID';

switch software
    case 'VIC'
        folderName = '/Users/binchen/Desktop/FEMU-DIC/Demo/VirtualImageVIC';
        scale = 1; 
        dataformat = 'mat';
        ConvertVICData(folderName,dataformat,scale)
    case 'MatchID'
        folderName = '/Users/binchen/Desktop/FEMU-DIC/Demo/VirtualImageMatchID';
        scale = 40; 
        dataformat = 'csv';
        ConvertMatchIDData(folderName,dataformat,scale)
end