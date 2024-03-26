function [p_Model] = FEMU_GN(p_Model,p_FEA,Params_FEMU)

% Gaussian-Newton algorithm
incrementRatio = 1/100;
deltaP = p_Model;
Threshold = 0.001;

% Iteration
i = 0;
file_log = fullfile(Params_FEMU.folder_Model,'log.txt');
fid=fopen(file_log,'a');
date = datetime('now');
fprintf(fid,'Time: %s\n', date);
for i_params = 1:numel(p_Model)
    fprintf(fid,'%15s',Params_FEMU.p_Model_NAME{i_params});
end
fprintf(fid,'\n');

while i<20 && max(abs(deltaP./p_Model))>Threshold
    
    i = i+1;
    fprintf('Iteration: %d...\n', i);
    % Save results to log file
    for i_params = 1:numel(p_Model)
        fprintf(fid,'%15.5g',p_Model(i_params));
    end
    fprintf(fid,'\n');
    
    % Plot all results
    for j = 1:length(p_Model)
        figure(j+1)
        plot(i,p_Model(j),'ko','MarkerSize',3,'MarkerFaceColor','k'),
        ylabel(Params_FEMU.p_Model_NAME{j});
        xlabel('Iteration number')
        set(gca,'fontsize',16);
        set(gcf,'color','w')
        hold on,
    end
    
    %% optimization
    for j = 1 : numel(p_Model)+1
        P_temp    = [p_Model;p_FEA];
        if j <= numel(p_Model)
            P_temp(j) = (1+incrementRatio)*P_temp(j);
        end
        
        % calcualte the residual
        residual_j_Param = [];
        Params_FEMU = callComsol(Params_FEMU,P_temp);
        Strain_mess = Params_FEMU.Strain;
        Disp_mess   = Params_FEMU.Disp;
        
        for i_File = 1:length(Params_FEMU.fileDef_All)
            
            DIC_data_file      = Params_FEMU.fileDef_All{i_File};
            
            Strain_mess_i_File = Strain_mess(:,[1,2,i_File*3,i_File*3+1,i_File*2]);
            Disp_mess_i_File   = Disp_mess(:,[1,2,i_File*2+1,i_File*2+2]);
%             load(Params_FEMU.file_params_DIC);
            
            [Disp_FEA,Disp_DIC,Strain_DIC,Params_FEMU] = ...
                CostFunction(Strain_mess_i_File,Disp_mess_i_File,DIC_data_file,Params_FEMU);
            [Disp_error,strain_error]  = ....
                strain_Error(Disp_FEA,Disp_DIC,Params_FEMU.Is_indPtInROI,Params_FEMU.file_params_DIC);
            
            % calculate the residual
            switch Params_FEMU.costFun
                case 'FEMU-εFN'
                    % Strain-based cost function
                    strain_error      = strain_error(find(~isnan(strain_error(:,1))),:);
                    strain_error_norm = strain_error./max(abs(Strain_DIC));
                    residual{j}       = [strain_error_norm(:)];
            end
            residual_j_Param = [residual_j_Param;residual{j}];
            
        end
        residual_all{j} = residual_j_Param;
    end
    
    for j = 1 : numel(p_Model)
        J(:,j) = [residual_all{j}-residual_all{numel(p_Model)+1}]./(incrementRatio);
    end
    
    deltaP = -(J'*J)^-1*J'*residual_all{numel(p_Model)+1}.*p_Model;
    p_Model = p_Model + deltaP;
end
fprintf(fid,'\n');
fclose(fid);
