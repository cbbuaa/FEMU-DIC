function residualScalar =  Residual_FEMU_NM(p_Model,p_FEA,Params_FEMU)

P_temp    = [p_Model;p_FEA];
% calcualte the residual
residual_j_Param = [];
Params_FEMU = callComsol(Params_FEMU,P_temp);

Strain_mess = Params_FEMU.Strain;
Disp_mess   = Params_FEMU.Disp;

for i_File = 1:length(Params_FEMU.fileDef_All)    
    Strain_mess_i_File = Strain_mess(:,[1,2,i_File*3,i_File*3+1,i_File*2]);
    Disp_mess_i_File   = Disp_mess(:,[1,2,i_File*2+1,i_File*2+2]);
    DIC_data_file      = Params_FEMU.fileDef_All{i_File};
    [Disp_FEA,Disp_DIC,Strain_DIC,Params_FEMU] = ...
        CostFunction(Strain_mess_i_File,Disp_mess_i_File,DIC_data_file,Params_FEMU);
    Disp_FEA_all{i_File}   = Disp_FEA;
    Disp_DIC_all{i_File}   = Disp_DIC;
    Strain_DIC_all{i_File} = Strain_DIC;
    Is_indPtInROI_all{i_File}  = Params_FEMU.Is_indPtInROI;
    
    load(Params_FEMU.file_params_DIC);
    Disp_FEA_Full     = nan(length(Params_FEMU.Is_indPtInROI(:)),2);
    for i = 1:size(Disp_DIC,2)
        Disp_FEA_Full(find(Params_FEMU.Is_indPtInROI(:)),i)  = Disp_FEA(:,i);
    end
    strain_FEA      = strainEstPLS(Disp_FEA_Full,Params);
    
end
indx_middle = 1:length(Params.comptPoints(:,1));

for i_File = 1:length(Params_FEMU.fileDef_All)  
    Disp_FEA_Diff   = Disp_FEA_all{i_File};
    Disp_DIC_Diff   = Disp_DIC_all{i_File};
    Strain_DIC_Diff = Strain_DIC_all{i_File};
    Is_indPtInROI   = Is_indPtInROI_all{i_File}.*Is_indPtInROI_all{1};
    
    
    [Disp_error,strain_error]  = ....
        strain_Error(Disp_FEA_Diff,Disp_DIC_Diff,Is_indPtInROI,Params_FEMU.file_params_DIC);  
    
    switch Params_FEMU.costFun
        case 'FEMU-εFN'
            % Strain-based cost function
            indx_notNan       = find(~isnan(strain_error(:,1)));
            indx_Valid        = intersect(indx_notNan,indx_middle);
            strain_error_norm = strain_error./(max(abs(Strain_DIC_Diff)));
            strain_error_norm = strain_error_norm(indx_Valid,:);
            
            residual   = strain_error_norm(:);
    end
    residual_j_Param = [residual_j_Param;residual];  
end
residualScalar = (norm(residual_j_Param))^2;
