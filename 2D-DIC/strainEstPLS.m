function strain = strainEstPLS(Disp,Params)
% Calculate the strain fields based on the displacement based on pointwise
% least-squares.

% Ref: B. Pan, Full-field strain measurement using a two-dimensional
% Savitzky-Golay digital differentiator in digital image correlation,
% Opt. Eng. 46 (2007) 033601.

% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-04

order         = 1;
strainWinSize = Params.strainWin;
X             = Params.comptPoints;

ROIsize       = [Params.Lx,Params.Ly];
switch order
    case 1
    A             = NaN(prod(ROIsize),3);
    case 2
    A             = NaN(prod(ROIsize),6);  
end

B             = A;
halfWsize     = floor(strainWinSize/2);

x = reshape(X(:,1),ROIsize);    y = reshape(X(:,2),ROIsize);
u = reshape(Disp(:,1),ROIsize); v = reshape(Disp(:,2),ROIsize);

GS_filter_x = 3/((strainWinSize(1))^2*(halfWsize(1)+1)*halfWsize(1)*Params.Step).*...
    repmat([-halfWsize(1):halfWsize(1)]',1,strainWinSize(1));

GS_filter_y = GS_filter_x';
% GS_filter_x = GS_filter_x(:);
% GS_filter_y = GS_filter_y(:);
% ux = filter2(GS_filter_x,u,'same');
% uy = filter2(GS_filter_y,u,'same');
% vx = filter2(GS_filter_x,v,'same');
% vy = filter2(GS_filter_y,v,'same');
% surf(ux),shading interp,axis tight, axis equal, view([0,90]);
% 
% exx = ux(:);
% eyy = vy(:);
% exy  = (uy(:)+vx(:))/2;
% strain0 = [exx,eyy,exy];

% tic
[xWin,yWin]     = ndgrid(Params.Step.*[-halfWsize(1):halfWsize(1)],...
    Params.Step.*[-halfWsize(1):halfWsize(1)]);
deltax          = xWin(:);
deltay          = yWin(:);
coeff0           = [ones(numel(deltax),1),deltax,deltay]';
coeffMat0        = (coeff0*coeff0')^-1*coeff0;

for i = 1 : ROIsize(1)
    for j = 1 : ROIsize(2)
        if ~isnan(u(i,j))
            xVec            = max(1,i-halfWsize) : min(ROIsize(1),i+halfWsize);
            yVec            = max(1,j-halfWsize) : min(ROIsize(2),j+halfWsize);

            uWin            = u(xVec,yVec);
            vWin            = v(xVec,yVec);
            %             wWin            = w(xVec,yVec);
            indNan          = find(isnan(uWin(:)));
         
    %         coeff           = [ones(numel(uWin),1),deltax,deltay,deltax.^2,deltax.*deltay,deltay.^2]';
            if isempty(indNan) && (length(uWin(:)) == size(coeffMat0,2))
                A((j-1)*ROIsize(1)+i,2) = sum(sum(GS_filter_x.*uWin));
                A((j-1)*ROIsize(1)+i,3) = sum(sum(GS_filter_y.*uWin));
                B((j-1)*ROIsize(1)+i,2) = sum(sum(GS_filter_x.*vWin));
                B((j-1)*ROIsize(1)+i,3) = sum(sum(GS_filter_y.*vWin));
                
                
%                 A((j-1)*ROIsize(1)+i,:) = coeffMat0*uWin(:);
%                 B((j-1)*ROIsize(1)+i,:) = coeffMat0*vWin(:);
            else
                xCen            = x(i,j);
                yCen            = y(i,j);
                uWin(indNan)    = [];
                vWin(indNan)    = [];
                xWin            = x(xVec,yVec);
                yWin            = y(xVec,yVec);
                deltax          = xWin(:)-xCen;
                deltay          = yWin(:)-yCen;
                              
                
                deltax(indNan)  = [];
                deltay(indNan)  = [];
                coeff           = [ones(numel(deltax),1),deltax,deltay]';
                coeffMat        = (coeff*coeff')^-1;
                A((j-1)*ROIsize(1)+i,:) = coeffMat*(coeff*uWin');
                B((j-1)*ROIsize(1)+i,:) = coeffMat*(coeff*vWin');
                
            end
        end
    end
end
% toc
% output the strain
exx      = A(:,2);
eyy      = B(:,3);
exy      = (A(:,3)+B(:,2))/2;
strain   = [exx,eyy,exy];
% surf(reshape(exx(:,1),ROIsize)),shading interp,axis tight, axis equal, view([0,90]);
% std(exx)
% std(eyy)