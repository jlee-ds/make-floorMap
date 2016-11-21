% 2016. 11. 17. made by Jongwon Lee and Soree Choi.
% Hanyang Uni. Last project for graduation.
% url: [https://github.com/jlee-ds/makeFloorMap]

% This code is to show only points on floor plane.
% It remains the points which is on the floor plane.

function [ xyzFloorPoints ] = remainFloorPoints( xyzPoints, floorPlane )
% this function just remain the points on floor.
xyzFloorPoints = xyzPoints;

for i = 1:480
    for j = 1:640
        x = xyzPoints(i,j,1);    y = xyzPoints(i,j,2);   z = xyzPoints(i,j,3);
        %dist = distance from a coordinate to the floorPlane
        dist = abs(floorPlane(1) * x + floorPlane(2) * y + floorPlane(3) * z + floorPlane(4));
        dist = dist / norm(floorPlane(1:3));
        %if the distance is larger than 0.015(threshold we set),
        if dist > 0.015
            %delete the coordinate
            xyzFloorPoints(i,j,:) = [NaN, NaN, NaN];
        end
    end
end

end
