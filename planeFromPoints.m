% 2016. 11. 17. made by Jongwon Lee and Soree Choi.
% Hanyang Uni. Last project for graduation.
% url: [https://github.com/jlee-ds/makeFloorMap]

% This code is to find a plane using three 3d points.

function [p] = planeFromPoints(p1,p2,p3)
%find normal vector
n = findNormalVector(p1,p2,p3);
%n=[a,b,c]

%d=-(ax+by+cz)
%x <- p1(1), y <- p1(2), z <- p1(3)
d = 0;
for i = 1 : 3
    d = d + n(i) * p1(i);
end
d = d * (-1);

p = [n(1),n(2),n(3),d];
p = round((p*100))/100;
end
