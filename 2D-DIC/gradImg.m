function [gradxImg, gradyImg] = gradImg(Img)
% Find the gradient along x and y axes of a image, 
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-04
hx              = [1,-8,0,8,-1]'/12;
hy              = [1,-8,0,8,-1]/12;
gradxImg        = filter2(hx,Img,'same');
gradyImg        = filter2(hy,Img,'same');