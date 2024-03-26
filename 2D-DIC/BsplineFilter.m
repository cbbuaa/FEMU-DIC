function Img = BsplineFilter(Img)
% Filt the image for subsequent interpolation is bicubic B-spline
% iterpolation is applied.
% Ref: ﻿[1] M. Unser, Splines: A perfect fit for signal processing,
% Eur. Signal Process. Conf. 2015-March (2000).

% Author: Bin Chen
% Contact: 
% Update: 2021/06/05

[M,N] = size(Img);
Img0  = double(uint8(Img));
z1    = -2 + 3^0.5;

% B-spline filter along y direction
C1   = zeros(M,N);
C2   = zeros(M,N);
C1( :,1) = C1(:,1) + sum(Img0.*repmat(z1.^[0:N-1],M,1),2);
for k = 2:N
    C1(:,k) = Img0(:,k) + z1* C1(:,k-1);
end
C2(:,N) = (z1/(1-z1^2))*(C1(:,N) + z1*C1(:,N-1));
for l = N-1:-1:1
    C2(:,l) = z1*( C2(:,l+1) - C1(:,l));
end
C   = 6*C2;


% B-spline fiter along x direction
C1  = zeros(M,N);
C2  = zeros(M,N);
C1(1,:) = C1(1,:) + sum(C.*repmat(z1.^[0:M-1]',1,N),1);
for k = 2:M
    C1(k,:) = C(k,:)+z1*C1(k-1,:);
end
C2(M,:) = (z1/(1-z1^2))*(C1(M,:) + z1*C1(M-1,:));
for l = M-1:-1:1
    C2(l,:) = z1*( C2(l+1,:)- C1(l,:));
end
Img = 6*C2;