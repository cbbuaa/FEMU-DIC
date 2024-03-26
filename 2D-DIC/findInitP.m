function [InitMatP] = findInitP(ImRef,ImDef,Params,InitP,InitPDef)
% This function is used for estimate the initial point for later
% calculation;
% Params.InitMethod
% 0: without initial estimation;
% 1: corse-to-fine;
% 2: FFT;
% 3: Manually select;

% ImRef: Reference image
% ImDeform: deform image
InitMethod   = Params.InitMethod;
half_subset  = Params.half_subset;
deltaVecX    = Params.deltaVecX;
deltaVecY    = Params.deltaVecY;
subset       = Params.subset;
sizeX        = Params.sizeX;
sizeY        = Params.sizeY;

if isfield(Params,'InitMatP')
    InitP0 = round(Params.InitMatP);
else
    InitP0 = InitP;
end
    
    
%%  -------------------------without initial estimation----------------------
if InitMethod == 0
    InitMatP = InitP0(1:2,:);
end
%%  ------------------------ initial using corse-to-fine----------------------------

if InitMethod == 1
    if prod(InitP0(1:2) == fix(InitP0(1:2)))
        fSubset   = ImRef(InitP0(1)+deltaVecX,InitP0(2)+deltaVecY);
    else
        [x,y]     = ndgrid(InitP0(1)+deltaVecX,InitP0(2)+deltaVecY);
        fSubIntp  = [x(:)';y(:)';ones(1,prod(subset))];
        ImRef     = BsplineFilter(ImRef);
        fSubset   = BicubicBsplineInterp(ImRef,fSubIntp);
    end
    deltaf        = std(fSubset(:));
    deltafSub     = reshape(fSubset-mean(fSubset(:)),subset(1),subset(2));
    
    stepInitEst   = 3;
    indRange(1,1) = floor(min(2*half_subset(1),InitP0(1))/stepInitEst);
    indRange(1,2) = ceil(min(2*half_subset(1),sizeX-InitP0(1))/stepInitEst);
    indRange(2,1) = floor(min(2*half_subset(2),InitP0(2))/stepInitEst);
    indRange(2,2) = ceil(min(2*half_subset(2),sizeY-InitP0(2))/stepInitEst);
    
    InitMatP      = searchInitRegion(ImDef,round(InitPDef),deltafSub,deltaf,subset,...
        indRange,deltaVecX,deltaVecY,stepInitEst);
    stepInitEst   = 1;
    InitPupdate   = round(InitMatP);
    InitMatP      = searchInitRegion(ImDef,InitPupdate,deltafSub,deltaf,subset,...
        indRange,deltaVecX,deltaVecY,stepInitEst);
    InitMatP      = InitMatP(1:2,:);
end

%%  ---------------------Initial using FFT------------------------
if InitMethod == 2
    
    fSubset       = ImRef(InitP0(1)+deltaVecX,InitP0(2)+deltaVecY);

    xRange        = -half_subset(1)*3:half_subset(1)*3;
    yRange        = -half_subset(2)*3:half_subset(2)*3;
    lenX          = length(xRange);
    lenY          = length(yRange);
    for defIndx   = xRange
        for defIndy = yRange
            i       = defIndx-xRange(1)+1;
            j       = defIndy-yRange(1)+1;
            defIntp = ImDef(InitP0(1)+defIndx+deltaVecX,InitP0(2)+defIndy+deltaVecY);
            Ff      = fft2(fSubset);
            Fg      = fft2(defIntp);
            FCross  = exp(1i*(angle(Ff)-angle(Fg)));
            FPhase  = real(ifft2(FCross));
            R       = sum(FPhase,3);
%             mesh(R)
            Coef(i,j,:) = [1,defIndx,defIndy,defIndx*defIndy,defIndx^2,defIndy^2]';
            MaxR    = max(R(:));
            P(i,j)  = MaxR;          
        end
    end
    InitMatP    = quadSurFit(P,Coef,InitP0);
    if isfield(Params,'InitMatP') 
        InitMatP    = InitMatP-InitP0+Params.InitMatP;
    else
        InitMatP    = InitMatP;
    end
    % further plus the displacement of the reference states 
end

if InitMethod == 3
    
    hold on,
    [x,y]           = ginput(1);
    InitPDef        = [y;x;1];

    plot(InitPDef(2),InitPDef(1),'r*','MarkerSize',12);
    drawnow;
    hold on

    Params.InitP       = InitP0;
    
    if prod(InitP0(1:2) == fix(InitP0(1:2)))
        fSubset   = ImRef(InitP0(1)+deltaVecX,InitP0(2)+deltaVecY);
    else
        [x,y]     = ndgrid(InitP0(1)+deltaVecX,InitP0(2)+deltaVecY);
        fSubIntp   = [x(:)';y(:)';ones(1,prod(subset))];
        fSubset   = interpSubPixel(ImRef,fSubIntp,'bicubic_Bspline');
    end
    deltaf        = std(fSubset(:));
    deltafSub     = reshape(fSubset-mean(fSubset(:)),subset(1),subset(2));
    
    stepInitEst   = 3;
    indRange(1,1) = floor(min(2*half_subset(1),InitP0(1))/stepInitEst);
    indRange(1,2) = ceil(min(2*half_subset(1),sizeX-InitP0(1))/stepInitEst);
    indRange(2,1) = floor(min(2*half_subset(2),InitP0(2))/stepInitEst);
    indRange(2,2) = ceil(min(2*half_subset(2),sizeY-InitP0(2))/stepInitEst);
    
    InitMatP      = searchInitRegion(ImDef,round(InitPDef),deltafSub,deltaf,subset,...
        indRange,deltaVecX,deltaVecY,stepInitEst);
    stepInitEst   = 1;
    InitPupdate   = round(InitMatP);
    InitMatP      = searchInitRegion(ImDef,InitPupdate,deltafSub,deltaf,subset,...
        indRange,deltaVecX,deltaVecY,stepInitEst);
    InitMatP      = InitMatP(1:2,:);
end



function [InitMatP]=searchInitRegion(ImDef,InitP,deltafSub,deltaf,subset,indRange,deltaVecX,deltaVecY,stepInitEst)

k           = 1;
for defIndx = (-indRange(1,1) : indRange(1,2))*stepInitEst
    for defIndy = (-indRange(2,1) : indRange(2,2))*stepInitEst
        i          = defIndx/stepInitEst+indRange(1,1)+1;
        j          = defIndy/stepInitEst+indRange(2,1)+1;
        centerPt   = [InitP(1)+defIndx,InitP(2)+defIndy];
        if prod(centerPt == fix(centerPt))
            
            degIntp    = ImDef(centerPt(1)+deltaVecX,centerPt(2)+deltaVecY);
        else
            [x,y]     = ndgrid(centerPt(1)+deltaVecX,centerPt(2)+deltaVecY);
            fSubIntp   = [x(:)';y(:)';ones(1,prod(subset))];
            degIntp   = interpSubPixel(ImDef,fSubIntp,'bicubic_Bspline');
        end
        
        deltag     = std(degIntp(:));
        deltagVec  = degIntp-mean(degIntp(:));
        deltagSub  = reshape(deltagVec,subset(1),subset(2));
        Cznssd     = sum(sum((deltafSub/deltaf-deltagSub/deltag).^2))/prod(subset);
        Czncc(i,j)  = 1-0.5*Cznssd;
%         Indx(k,:)  = [defIndx,defIndy];
        Coef(i,j,:) = [1,defIndx,defIndy,defIndx*defIndy,defIndx^2,defIndy^2]';
        k           = k+1;
    end
end
InitMatP = quadSurFit(Czncc,Coef,InitP);



function InitMatP = quadSurFit(Czncc,Coef,InitP)
%% corse finding the location
h             = fspecial('gaussian',3);
znccFilter    = filter2(h,Czncc);
[sizex,sizey] = size(znccFilter);
[~,Indx]      = max(znccFilter(:));
[ii, jj]      = ind2sub(size(Czncc),Indx);
Coefnew       = Coef(max(1,ii-2):min(sizex,ii+2),max(1,jj-2):min(sizey,jj+2),:);
CznccNew      = Czncc(max(1,ii-2):min(sizex,ii+2),max(1,jj-2):min(sizey,jj+2));
A             = reshape(Coefnew,[],6);
b             = CznccNew(:);


%% quadric surface fitting
a     = (A'*A)\(A'*b);
y     = (2*a(3)*a(5)-a(2)*a(4))/(a(4)^2-4*a(5)*a(6));
x     = -1/a(4)*(2*a(6)*y+a(3));
InitMatP  = [x+InitP(1); y+InitP(2)];


