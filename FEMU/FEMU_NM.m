function [p_Model] = FEMU_NM(p_Model,Params_FEMU)

[p_Model,fval,exitflag,output]  = fminsearch(@(p_Model)Residual_FEMU_NM(p_Model,Params_FEMU),p_Model,...
                  optimset('PlotFcns','optimplotfval','Display','Iter','MaxIter',30));