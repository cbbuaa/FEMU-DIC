function [Params]=calcuPt(Params)
% this function is used for generate a set of calculation points
% and show ROI and subset on the figure
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2023-09-12

% parameters
half_subset  = Params.half_subset;
allRegion    = Params.allRegion;
Step         = Params.Step;

%% get two corner points of ROI, and plot a rectangle
hold on,
for i = 1:length(allRegion)
    if i== 1
        labelROI = 'ROI';
        colorROI = [1 0 0];
    else
        labelROI = '';
        colorROI = [0 0.5 0];
    end
    
    switch allRegion(i)
        %% Rectangular
        case 1
            if 1
                
                roi = drawrectangle('Label',labelROI,'Color',colorROI,...
                    'InteractionsAllowed','none','LineWidth',1);
                x_bound = [roi.Vertices(:,2);roi.Vertices(1,2)];
                y_bound = [roi.Vertices(:,1);roi.Vertices(1,1)];
            end    
        
        %% Plot polygon
        case 2
            if 1
                roi = drawpolygon('Label',labelROI,'Color',colorROI,...
                    'InteractionsAllowed','none','LineWidth',1);;
                
                x_bound = [roi.Position(:,2);roi.Position(1,2)];
                y_bound = [roi.Position(:,1);roi.Position(1,1)];
            end
    end
    x_bound_all{i} = x_bound;
    y_bound_all{i} = y_bound;
end



polyout = polyshape(y_bound_all{1},x_bound_all{1});
if length(x_bound_all)>1
    for i = 2:length(x_bound_all)
        pgon = polyshape(y_bound_all{i},x_bound_all{i});
        %     plot(pgon,'FaceColor','red','FaceAlpha',0);
        polyout = subtract(polyout,pgon);
    end
end
plot(polyout)


x_bound         = round(x_bound_all{1});
y_bound         = round(y_bound_all{1});
boundary        = [x_bound,y_bound];

%% generate a set of calculaiton points with space equal to "step"
calPtX          = (min(x_bound)+half_subset(1)):Step:(max(x_bound)-half_subset(1));
calPtY          = (min(y_bound)+half_subset(2)):Step:(max(y_bound)-half_subset(2));

% number of calculation points
Lx              = length(calPtX); % point number along x direction
Ly              = length(calPtY); % point number along y direction
[refX,refY]     = ndgrid(calPtX,calPtY); % grid of calulation point


isPtInROI       = inpolygon(refX(:),refY(:),...
    polyout.Vertices(:,2),polyout.Vertices(:,1));

indPtInROI      = find(isPtInROI);
comptPoints     = [refX(:),refY(:)]; % the calculation points



% pixels in ROI
[x_pixel,y_pixel] = ndgrid(1:Params.sizeX,1:Params.sizeY);
isPixelInROI      = inpolygon(x_pixel(:),y_pixel(:),...
    polyout.Vertices(:,2),polyout.Vertices(:,1));


isPixelInROI_Mat  = reshape(isPixelInROI,[Params.sizeX,Params.sizeY]);
% indPixelInROI     = find(isPixelInROI);


%% the initial point
if Params.fixed_seedPts
    % the central point is select as the initial point
    x               = Params.sizeX./2;
    y               = Params.sizeY./2;
    dist            = sqrt((refX(:)-x).^2+(refY(:)-y).^2);
    [~,indx]        = min(dist);
    InitP           = [refX(indx(1));refY(indx(1));1];
else
    % manually select an initial point
    [x,y]           = ginput(1);
    dist            = sqrt((refX(:)-y).^2+(refY(:)-x).^2);
    [~,indx]        = min(dist);
    InitP           = [refX(indx(1));refY(indx(1));1];
end
% plot it on the image
plot(InitP(2),InitP(1),'r*','MarkerSize',12);
drawnow;
hold on


Is_indPtInROI = zeros(Lx * Ly,1);
Is_indPtInROI(indPtInROI) = 1;

% save all points into structure: Params.
Params.Lx          = Lx;
Params.Ly          = Ly;
Params.InitP       = InitP;
Params.IndxInitP   = indx;
Params.calPtX      = calPtX;
Params.calPtY      = calPtY;
Params.NumCalPt    = Lx * Ly;
Params.comptPoints = comptPoints;
Params.indPtInROI  = indPtInROI;
Params.boundary    = boundary;
Params.x_bound_all = x_bound_all;
Params.y_bound_all = y_bound_all;
Params.Is_indPtInROI = Is_indPtInROI;
Params.isPixelInROI_Mat = isPixelInROI_Mat;
Params.NumCalPixel = (length(calPtX)+1)*(length(calPtY)+1);
