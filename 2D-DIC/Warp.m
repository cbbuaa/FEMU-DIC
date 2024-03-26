function warP = Warp(p)
% warp function
% convert vertor p to a warp matrix
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-04

if length(p) == 6
    % First order case
    % warp
    warP = [1+p(2) p(3)    p(1);
            p(5)   1+p(6)  p(4);
            0      0       1];
else
    % Second order case
    s1            = 2*p(2)+p(2)^2+p(1)*p(4);
    s2            = 2*p(1)*p(5)+2*(1+p(2))*p(3);
    s3            = p(3)^2+p(1)*p(6);
    s4            = 2*p(1)*(1+p(2));
    s5            = 2*p(1)*p(3);
    s6            = p(1)^2;
    s7            = 1/2*(p(7)*p(4)+2*(1+p(2))*p(8)+p(1)*p(10));
    s8            = p(3)*p(8)+p(2)*p(9)+p(7)*p(5)+p(1)*p(11)+p(9)+p(2);
    s9            = 1/2*(p(7)*p(6)+2*(1+p(9))*p(3)+p(1)*p(12));
    s10           = p(7)+p(7)*p(2)+p(1)*p(8);
    s11           = p(1)+p(7)*p(3)+p(1)*p(9);
    s12           = p(1)*p(7);
    s13           = p(8)^2+p(7)*p(10);
    s14           = 2*p(7)*p(11)+2*p(8)*(1+p(9));
    s15           = 2*p(9)+p(9)^2+p(7)*p(12);
    s16           = 2*p(7)*p(8);
    s17           = 2*p(7)*(1+p(9));
    s18           = p(7)^2;

    % warp
    warP = [     1+s1,    s2,        s3,     s4,     s5,   s6;
                   s7,  1+s8,        s9,    s10,    s11,  s12;
                  s13,   s14,     1+s15,    s16,    s17,  s18;
             1/2*p(4),  p(5),  1/2*p(6), 1+p(2),   p(3), p(1);
            1/2*p(10), p(11), 1/2*p(12),   p(8), 1+p(9), p(7);
                    0,     0,         0,      0,      0,    1];
end