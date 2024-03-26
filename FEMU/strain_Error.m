function [Disp_error,strain_error] = ...
    strain_Error(Disp_FEA,Disp_DIC,Is_indPtInROI,file_params_DIC)
% This function is used to calcualte the error vector for displacement and
% strain.

% load DIC data
load(file_params_DIC);

Disp_FEA_Full               = nan(length(Is_indPtInROI(:)),2);

% some DIC data may be outside of the FE mesh, which needs to be considered
for i = 1:size(Disp_DIC,2)
    Disp_FEA_Full(find(Is_indPtInROI(:)),i)  = Disp_FEA(:,i);
end

Disp_error      = Disp_DIC-Disp_FEA_Full; % Disp error
strain_error    = strainEstPLS(Disp_error,Params); % Strain error
% strain_FEA      = strainEstPLS(Disp_FEA_Full,Params); % Strain error
