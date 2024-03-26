function [invH,Jacobian,H] = calHessian(localSub,nablaf)
% Estimate the Hessian matrix for first order shape function;
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-05

Jacobian    = [nablaf(:,1), localSub(:,1).*nablaf(:,1), localSub(:,2).*nablaf(:,1),...
               nablaf(:,2), localSub(:,1).*nablaf(:,2), localSub(:,2).*nablaf(:,2)];
H           = Jacobian'*Jacobian;
invH        = inv(H);


    