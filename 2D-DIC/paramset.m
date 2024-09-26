function Params = paramset(Params)
% This function is used for setting all parameters
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-04

%% -------------Check these parameters before usage-------------%%
subset               = 21*[1,1]; % must be odd value
Params.subset        = subset;
if isfield(Params,'Step')
    Step = Params.Step;
else
    Step             = 5;
end
R                    = Step*2.5;
Params.R_Filter      = 2;
Order                = 1;
strainWin            = 11*[1,1]; % must be odd value

IterMethod           = 'IC-GN-RG';
param_Plot           = 'exx'; % select from 'exx', 'eyy', 'exy', 'u', 'v'
allRegion            = [1,2]; % Two number, 1 means rectangular, 2: polygon. 
                              % We can use more thant one number, e.g. [1,2,1]. 
                              % It means adding a rectangular region, 
                              % followed by deleting a rectangular and polygon regions.
fill_boundary        = 1; % 1 or 0 to fill the boundary.
Normalization        = 1; % 1 with normalization, 0 without normalization
maxIter              = 15; % maximum iteration number
thre                 = 1e-3; % theroshold of iteration
fixed_seedPts        = 0; % 0: manually select; 1: fixed to the center point
% InitMethod: 0 denotes no initial value is set,1 denotes corse-to-fine, 
% 2 denotes Fast Fourier Transformation, 3 denotes manually selection
InitMethod           = 2;

%% -------------------------------------------------------------- %%
half_subset          = floor(subset/2);
% local coordinate of a subset
deltaVecX            = -half_subset(1) : half_subset(1);
deltaVecY            = -half_subset(2) : half_subset(2);
[deltax,deltay]      = ndgrid(deltaVecX,deltaVecY);
localSubHom          = [deltax(:)';deltay(:)';ones(1,prod(subset))];

% Local coordinate in subset
localSub             = [localSubHom(1,:)',localSubHom(2,:)'];
% Print the key parameters on the screen.
fprintf('Matching method: %s;\n', IterMethod);
fprintf('Subset size: %d * %d;\n', subset(1),subset(2));
fprintf('Step: %d;\n', Step);


%% Save all results into a structure
Params.frameRate     = 2;
Params.fixed_seedPts = fixed_seedPts;
Params.selectCalcuPt = 1;
Params.thre          = thre;
Params.subset        = subset;
Params.Step          = Step;
Params.maxIter       = maxIter;
Params.half_subset   = half_subset;
Params.localSubHom   = localSubHom;
Params.deltaVecX     = deltaVecX;
Params.deltaVecY     = deltaVecY;
Params.strainWin     = strainWin;
Params.InitMethod    = InitMethod;
Params.IterMethod    = IterMethod;
Params.Normalization = Normalization;
Params.localSub      = localSub;
Params.allRegion     = allRegion;
Params.param_Plot    = param_Plot;
Params.R             = R;
Params.Order         = Order;
Params.fill_boundary = fill_boundary;
