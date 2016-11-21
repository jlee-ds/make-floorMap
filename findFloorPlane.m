% 2016. 11. 17. made by Jongwon Lee and Soree Choi.
% Hanyang Uni. Last project for graduation.
% url: [https://github.com/jlee-ds/makeFloorMap]

% This code is to find floor plane's equation.
% We used RANSAC method.
% For this, the points on the floor have to be the most.
% To make this reasonable, our camera looks at floor a litte.

function [ floorPlane ] = findFloorPlane(xyzPoints)
%xyzFloorPoints = xyzPoints;
newPlaneArray = zeros(1,5); %create 1*5 zero matrix
%pick 5000 3-coordinates randomly
for i = 1 : 500
    while 1
        p1x = randi(480, 1);
        p1y = randi(640, 1);
        p2x = randi(480, 1);
        p2y = randi(640, 1);
        p3x = randi(480, 1);
        p3y = randi(640, 1);
        if(isnan(xyzPoints(p1x,p1y,1)) ~= 1 && isnan(xyzPoints(p2x,p2y,1)) ~= 1 && isnan(xyzPoints(p3x,p3y,1)) ~= 1)
            break;
        end
   end
        %if all the 3-coordinates are not 'Nan' values,

        %change each coordinate from depth value to 3d-coordinate
        p1 = [xyzPoints(p1x,p1y,1), xyzPoints(p1x,p1y,2), xyzPoints(p1x,p1y,3)];
        p2 = [xyzPoints(p2x,p2y,1), xyzPoints(p2x,p2y,2), xyzPoints(p2x,p2y,3)];
        p3 = [xyzPoints(p3x,p3y,1), xyzPoints(p3x,p3y,2), xyzPoints(p3x,p3y,3)];

        %find a plane with 3 3d-coordinates
        newPlane = planeFromPoints(p1,p2,p3);

        %we have to find all the planes' coeffecients, the number of
        %each planes and the coordinates on each planes.
        %the information of them will be stored at newPlaneArray
        %numofPlane is the number of planes we found with randomly
        %selected 3d-coordinates
        numOfPlane = size(newPlaneArray); %numofPlane = [1, 5]
        numOfPlane = numOfPlane(1); %numofPlane = 1
        isTrue = (newPlaneArray(1,:) == [0,0,0,0,0]);

        %put the first plane you found in newPlaneArray
        %if newPlaneArray is a zero matrix,
        if sum(isTrue) == 5
            newPlaneArray(1,1:4) = newPlane; %add the new plane's coeffecient
            newPlaneArray(1,5) = 1; %add the number of the plane
        else
            %check if the plane i found is already in newPlaneArray
            flag = 0;
            for j = 1:numOfPlane
                isTrue = (newPlaneArray(j,1:4) == newPlane);
                %if it is already in newPlaneArray
                if sum(isTrue) == 4
                    %count the number of the plane
                    newPlaneArray(j,5) = newPlaneArray(j,5) + 1;
                    flag = 1;
                    break;
                end
            end
            %if the plane i found is a new plane
            if flag == 0
                %put it in newPlaneArray and count the number of the
                %plane
                newPlaneArray(numOfPlane+1,1:4) = newPlane;
                newPlaneArray(numOfPlane+1,5) = 1;
            end
        end
end

%maxValue = maximum number of planes
%row = the row which has the maximum number of planes
[maxValue, row] = max(newPlaneArray(:,5));
%flooe planes = the most frequent plane's coeffecient
floorPlane = newPlaneArray(row,1:4);
disp(newPlaneArray);

%print
floorPlane
maxValue
end
