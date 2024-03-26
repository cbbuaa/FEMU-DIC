function [Disp,strain,ZNCC,outIter] = DICmatch_RG(ImRef,ImDef,pCoord,p,Params,outP)
% Match image with reliabity guided strategy
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-05

Lx                   = Params.Lx;
Ly                   = Params.Ly;
comptPoints          = Params.comptPoints;
indPtInROI           = Params.indPtInROI;
ZNCC                 = nan(Params.NumCalPt,1);
ZNCC(indPtInROI)     = 0;
outIter              = zeros(Params.NumCalPt,1);  
m                    = 1;
queue                = [];
% used to find the four neighbored point in reliability guided strategy.
neighborLocal        = [-1, 0, 1, 0;
                        0,-1, 0, 1];
                    
Disp                 = nan(Params.NumCalPt,2);
                    
tic,
fprintf('Processing finished :         ')
while length(queue)>0 || m<=2
    
    if m==1
        Params.thre               = 1e-10;
        [p,Czncc,Iter,disp]       = corrIter(ImRef,ImDef,pCoord,p,Params);
        ZNCC(Params.IndxInitP,:)  = Czncc;
        outP(Params.IndxInitP,:)  = p;
        Disp(Params.IndxInitP,:)  = disp;
        
        % Save the initial points.
        Params.defRefInitPt = disp';
        outIter(Params.IndxInitP,1) = Iter;
        m                   = m+1;
        [s,t]               = ind2sub([Lx,Ly],Params.IndxInitP);
        queue               = [queue;s,t,Czncc];
        pInit               = p;
        Params.thre      = 1e-3;
    end
    % check the neighoring four points
    for iNeighbor = 1:4
        ii   = neighborLocal(1,iNeighbor);
        jj   = neighborLocal(2,iNeighbor);        
        i    = s+ii;
        j    = t+jj;
     % if point (i,j) has been estimated before,
        if i<1||j<1||i>Lx||j>Ly||ZNCC((j-1)*Lx+i,1) ~=0
            continue
        else
            pointsIndx            = (j-1)*Lx+i;
            % pass initial value to next point
            p                     = pInit';
            
            p(1)                  = p(1)+p(2)*Params.Step*ii...
                                   +p(3)*Params.Step*jj;
            midTerm               = 1+length(p)/2;
            p(midTerm)            = p(midTerm)+p(midTerm+1)*Params.Step*ii...
                                   +p(midTerm+2)*Params.Step*jj;
            pCoord                = [comptPoints(pointsIndx,:)'; 1];
            [p,Czncc,Iter,disp]   = corrIter(ImRef,ImDef,pCoord,p,Params);
            ZNCC(pointsIndx,:)    = Czncc;
            outP(pointsIndx,:)    = p;
            Disp(pointsIndx,:)    = disp;
            outIter(pointsIndx,1) = Iter;
           %% (i, j) is the point to be calculated in next iteration
            queue                 = [queue;i,j,Czncc];
            m                     = m+1;
        end
    end

    %  (s, t) is the index of a point with best Czncc. In next loop, we
    %  will match its neighbored four points.
    [~,znccindx]      = sort(queue(:,3),'descend');
    queue             = queue(znccindx,:);
    s                 = queue(1,1);
    t                 = queue(1,2);
    pInit             = outP((t-1)*Lx+s,:);
    queue(1,:)        = [];
    
    % printf
    Num = floor(m/length(indPtInROI)*100);
    if rem(Num,10)==0
        fprintf(repmat('\b',1,length(num2str(Num))+6));
        fprintf('%d %% ...',Num);
    end
    
end
t = toc;
fprintf('\nSpeed: %.3d points/s',m/t)
fprintf('\nCompleted in %.3f seconds\n',t);
fprintf('Mean iteration: %0.2f\n',mean(outIter))

% Strain estimation
strain  = strainEstPLS(Disp,Params);
