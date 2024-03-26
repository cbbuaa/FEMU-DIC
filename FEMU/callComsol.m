function [Params_FEMU] = callComsol(Params_FEMU,p)
%% Run the model
Params_FEMU.Ex = p(1);
Params_FEMU.Ey = p(2);
Params_FEMU.vxy = p(3);
Params_FEMU.Gxy = p(4);
Params_FEMU.R = p(5);

Params_FEMU.theta = p(6);
Params_FEMU.L = p(7);
Orthotropic_model_demo(Params_FEMU);
%% read the data file
path_save = Params_FEMU.folder_Model_results;
Strain  = csvread(fullfile(path_save,'Strain.csv'),9,0);
Disp    = csvread(fullfile(path_save,'Disp.csv'),9,0);

Params_FEMU.Strain = Strain;
Params_FEMU.Disp   = Disp;
