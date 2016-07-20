function [ xyzFloorPoints ] = findFloorPlane( xyzPoints, threshold )
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
% threshold (angle)
kinectNormalVector = [0, -1, 0];
xyzFloorPoints = xyzPoints;
newPlaneArray = zeros(1,5);

for i = 1 : 10000
    p1x = randperm(480, 1);
    p1y = randperm(640, 1);
    p2x = randperm(480, 1);
    p2y = randperm(640, 1);
    p3x = randperm(480, 1);
    p3y = randperm(640, 1);

        if(isnan(xyzPoints(p1x,p1y,1)) ~= 1 && isnan(xyzPoints(p2x,p2y,1)) ~= 1 && isnan(xyzPoints(p3x,p3y,1)) ~= 1)
            p1 = [xyzPoints(p1x,p1y,1), xyzPoints(p1x,p1y,2), xyzPoints(p1x,p1y,3)];
            p2 = [xyzPoints(p2x,p2y,1), xyzPoints(p2x,p2y,2), xyzPoints(p2x,p2y,3)];
            p3 = [xyzPoints(p3x,p3y,1), xyzPoints(p3x,p3y,2), xyzPoints(p3x,p3y,3)];
            %newNormalVector = findNormalVector(p1,p2,p3);
            newPlane = planeFromPoints(p1,p2,p3);
            %innerProduct = dot(newNormalVector, kinectNormalVector);
            %angle = acos(innerProduct/(norm(newNormalVector)*norm(kinectNormalVector))) * 180 / pi;
            numOfPlane = size(newPlaneArray);
            numOfPlane = numOfPlane(1);
            isTrue = (newPlaneArray(1,:) == [0,0,0,0,0]);
            if sum(isTrue) == 5
                newPlaneArray(1,1:4) = newPlane;
                newPlaneArray(1,5) = 1;
            else
                flag = 0;
                for j = 1:numOfPlane
                    isTrue = (newPlaneArray(j,1:4) == newPlane);
                    if sum(isTrue) == 4
                        newPlaneArray(j,5) = newPlaneArray(j,5) + 1;
                        flag = 1;
                        break;
                    end
                end
                if flag == 0
                    newPlaneArray(numOfPlane+1,1:4) = newPlane;
                    newPlaneArray(numOfPlane+1,5) = 1;
                end
            end

%             if(angle > threshold)
%                 xyzFloorPoints(p1x,p1y,1) = NaN;
%                 xyzFloorPoints(p1x,p1y,2) = NaN;
%                 xyzFloorPoints(p1x,p1y,3) = NaN;
%                 xyzFloorPoints(p2x,p2y,1) = NaN;
%                 xyzFloorPoints(p2x,p2y,2) = NaN;
%                 xyzFloorPoints(p2x,p2y,3) = NaN;
%                 xyzFloorPoints(p3x,p3y,1) = NaN;
%                 xyzFloorPoints(p3x,p3y,2) = NaN;
%                 xyzFloorPoints(p3x,p3y,3) = NaN;
%             end
        end
end
[maxValue, col] = max(newPlaneArray(:,5));
floorPlane = newPlaneArray(col,1:4);
floorPlane
maxValue
newPlaneArray
max(newPlaneArray(:,5))

for i = 1:480
    for j = 1:640
        x = xyzPoints(i,j,1);    y = xyzPoints(i,j,2);   z = xyzPoints(i,j,3);
        dist = abs(floorPlane(1) * x + floorPlane(2) * y + floorPlane(3) * z + floorPlane(4));
        dist = dist / norm(floorPlane(1:3));
        if dist > 0.015
            xyzFloorPoints(i,j,:) = [NaN, NaN, NaN];
        end
    end
end
end

