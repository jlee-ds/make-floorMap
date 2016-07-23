function [ xyzFloorPoints ] = findFloorPlane( xyzPoints)
xyzFloorPoints = xyzPoints;
newPlaneArray = zeros(1,5); %create 1*5 zero matrix
%pick 5000 3-coordinates randomly
for i = 1 : 5000
    p1x = randperm(480, 1);
    p1y = randperm(640, 1);
    p2x = randperm(480, 1);
    p2y = randperm(640, 1);
    p3x = randperm(480, 1);
    p3y = randperm(640, 1);

        %if all the 3-coordinates are not 'Nan' values,
        if(isnan(xyzPoints(p1x,p1y,1)) ~= 1 && isnan(xyzPoints(p2x,p2y,1)) ~= 1 && isnan(xyzPoints(p3x,p3y,1)) ~= 1)
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
end

%maxValue = maximum number of planes
%row = the row which has the maximum number of planes
[maxValue, row] = max(newPlaneArray(:,5));
%flooe planes = the most frequent plane's coeffecient
floorPlane = newPlaneArray(row,1:4);

%print
floorPlane
maxValue
newPlaneArray

max(newPlaneArray(:,5))

%for all coordinates,
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
