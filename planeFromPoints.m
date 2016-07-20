function [p] = planeFromPoints(p1,p2,p3)
%find normal vector
n = findNormalVector(p1,p2,p3);

%d=-(ax+by+cz)
d = 0;
for i = 1 : 3
    d = d + n(i) * p1(i);
end
d = d * (-1);
p = [n(1),n(2),n(3),d]; 
p = round((p*100))/100;
end

