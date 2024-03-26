function [p,Czncc,Iter,disp] = corrIter(ImRef,ImDef,pCoord,p,Params)
% Using this function, we can choose a correlation method;
% the input Method control the used method;
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-05

switch Params.IterMethod
    case {'IC-GN','IC-GN-RG'}
        [p,Czncc,Iter,disp] = iterICGN(ImRef,ImDef,pCoord,p,Params);
    case {'IC-LM','IC-LM-RG'}
        [p,Czncc,Iter,disp] = iterICLM(ImRef,ImDef,pCoord,p,Params);
    case {'IC-GN2','IC-GN2-RG'}
        [p,Czncc,Iter,disp] = iterICGN2(ImRef,ImDef,pCoord,p,Params);
    case {'IC-LM2','IC-LM2-RG'}
        [p,Czncc,Iter,disp] = iterICLM2(ImRef,ImDef,pCoord,p,Params);
end