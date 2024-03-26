function [Disp,strain,ZNCC,iterNum] = DICmatch(ImRef,ImDef,pCoord,p0,Params,outP)
% Match image without reliabity guided strategy
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-05

Lx                   = Params.Lx;
Ly                   = Params.Ly;
comptPoints          = Params.comptPoints;

ZNCC                 = zeros(Params.NumCalPt,1);
iterNum              = zeros(Params.NumCalPt,1);  
Disp                 = zeros(Params.NumCalPt,2);
                    
tic
fprintf('Processing finished :         ')
m                    = 0;
for i = 1 : Lx
    for j = 1 : Ly
        pointsIndx          = (j-1)*Lx+i;
        % pass initial value to next point
        p                   = p0;
        pCoord              = [comptPoints(pointsIndx,:)'; 1];
        [p,Czncc,Iter,disp] = corrIter(ImRef,ImDef,pCoord,p,Params);
        ZNCC(pointsIndx,:)  = Czncc;
        outP(pointsIndx,:)  = p;
        Disp(pointsIndx,:)  = disp;
        iterNum(pointsIndx,1) = Iter;
        
        % print the progress on the screen
        m                   = m+1;
        Num = floor(m/Params.NumCalPt*100);
        if rem(Num,10)==0
            fprintf(repmat('\b',1,length(num2str(Num))+6));
            fprintf('%d %% ...',Num);
        end
    end
end
t = toc;
fprintf('\nSpeed: %.3d points/s',m/t)
fprintf('\nCompleted in %.3f seconds\n',t);
fprintf('Mean iteration: %0.2f\n\n',mean(iterNum))

% Strain estimation
strain  = strainEstPLS(Disp,Params);






