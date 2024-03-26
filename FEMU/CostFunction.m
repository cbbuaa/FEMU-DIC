function [Disp_FEA,Disp_DIC,Strain_DIC,Params_FEMU] = ...
               CostFunction(Strain_mess,Disp_mess,DIC_data_file,Params_FEMU)


load(DIC_data_file);
Disp_DIC  = Disp;
Strain_DIC = Strain;
clear Disp Strain

%% read mesh
[Nodes_mesh, Elements] = read_nastran_mesh(Params_FEMU.meshFile);

%% The data in the results and mesh is meshed up. Here we sort the resutls
Nodes_result_mess  = Strain_mess(:,[1,2]);
% the axis is also switched
Strain_mess        = Strain_mess(:,[3:5]);
Disp_mess          = Disp_mess(:,[3,4]);

Disp               = sortNode(Elements,Nodes_result_mess,Nodes_mesh,Disp_mess,0);
% Disp
Disp_pixel         = Disp(:,[2,1])*Params_FEMU.SCALE;
Disp_pixel(:,1)    = - Disp_pixel(:,1);

%% change the coordinate system for the results
% Nodes
Nodes_mesh_mm      = Nodes_mesh(:,[2,1]);
Nodes_mesh_mm(:,1) = -Nodes_mesh_mm(:,1);
Nodes_mesh_pixel   = Nodes_mesh_mm*Params_FEMU.SCALE+Params_FEMU.offset;


%% Interp the FEA disp from FEA mesh to all DIC calculation points
Params_FEMU.Is_indPtInROI = Is_indPtInROI;

T                  = triangulation(Elements,Nodes_mesh_pixel);
[ti,bc]            = pointLocation(T,comptPoints(find(Is_indPtInROI(:)),1),comptPoints(find(Is_indPtInROI),2));
indx_inROI         = find(~isnan(ti));

Disp_FEA           = nan(length(ti),2);
for i = 1:size(Disp_pixel,2)
    u        = Disp_pixel(:,i);
    triVals  = u(T(ti(indx_inROI),:));
    Disp_interp(:,i)       = dot(bc(indx_inROI,:)',triVals')';
    Disp_FEA(indx_inROI,i) = Disp_interp(:,i);
end
Params_FEMU.Is_indPtInROI = Is_indPtInROI;
Params_FEMU.comptPoints   = comptPoints;


