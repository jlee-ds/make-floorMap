% 2016. 11. 17. made by Jongwon Lee and Soree Choi.
% Hanyang Uni. Last project for graduation.
% url: [https://github.com/jlee-ds/makeFloorMap]

% capture images and compare them to find camera pose.
% kinect v1 is used as caemra.

% initial camera position - (0,0,0)
% traceCount is row number of camera pose.
delayTime = 0.5;
traceCamera = zeros(1,3);   traceCount = 1;

colorDevice = imaq.VideoDevice('kinect', 1);
depthDevice = imaq.VideoDevice('kinect', 2);   
colorDevice.ReturnedDataType = 'uint8';

step(colorDevice);  step(depthDevice);  
colorImage = step(colorDevice);               
depthImage = step(depthDevice);

xyzPoints = depthToPointCloud(depthImage, depthDevice);
alignedColorImage = alignColorToDepth(depthImage, colorImage, depthDevice);

beforeImage = alignedColorImage;
beforePoints = xyzPoints;
BRM = eye(3,3);         % Before Rotation Matrix
BTM = zeros(3,1);      % Before Transition Matrix

while 1

    colorImage = step(colorDevice);     
    depthImage = step(depthDevice);
    xyzPoints = depthToPointCloud(depthImage, depthDevice);
    alignedColorImage = alignColorToDepth(depthImage, colorImage, depthDevice);
   
    afterImage = alignedColorImage;
    afterPoints = xyzPoints;

    I1 = rgb2gray(beforeImage);               
    I2 = rgb2gray(afterImage);
    points1 = detectSURFFeatures(I1);      
    points2 = detectSURFFeatures(I2);
    features1 = extractFeatures(I1,points1);
    features2 = extractFeatures(I2,points2);
    indexPairs = matchFeatures(features1,features2,'Unique',true);
    matchedPoints1 = points1(indexPairs(:,1));
    matchedPoints2 = points2(indexPairs(:,2));
    figure(1); showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    
    matchedNum = size(matchedPoints1); matchedNum = matchedNum(1,1);
    if matchedNum < 10
        continue;
    end
    
    beforeDots = zeros(3,3);
    afterDots = zeros(3,3);
    beforeTestDot = zeros(3,1);
    afterTestDot = zeros(3,1);
    maxInlier = -1;
    optRM = zeros(3,3);
    optTM = zeros(3,1);

    % repeat RANSAC to find optimal R and T.
    for i = 1:15
        inlierNum = 0;
        disp(i);
        % make three random matched 3D points to calculate R and T.
        % throw away the 3D points with NaN value.
        while true
            randIndexs = randperm(matchedNum, 3);
            for j = 1:3
                xy1 = ceil(matchedPoints1(randIndexs(j)).Location);
                xy2 = ceil(matchedPoints2(randIndexs(j)).Location);
                xyz1 = beforePoints(xy1(2),xy1(1),:);
                xyz2 = afterPoints(xy2(2),xy2(1),:);
                if isnan(sum(xyz1)) || isnan(sum(xyz2))
                    break;
                else
                    beforeDots(:,j) = xyz1;
                    afterDots(:,j) = xyz2;
                end
            end
            if j == 3
                break;
            end
        end
        
        % get R and T matrixs using random three 3D points.
        % find inliers and number of inliers.
        [RM, TM] = getRT(afterDots, beforeDots);
        for k = 1:matchedNum
            if ismember(k,randIndexs)
                continue;
            else
                xy1 = ceil(matchedPoints1(k).Location);
                xy2 = ceil(matchedPoints2(k).Location);
                xyz1 = beforePoints(xy1(2),xy1(1),:);
                xyz2 = afterPoints(xy2(2),xy2(1),:);
                if isnan(sum(xyz1)) || isnan(sum(xyz2))
                    continue;
                else
                    beforeTestDot(:,1) = xyz1;
                    afterTestDot(:,1) = xyz2;
                    err = beforeTestDot - (RM * afterTestDot + TM);
                    if sum(abs(err)) < 1
                        inlierNum = inlierNum + 1;
                    end
                end
            end
        end
        if inlierNum >= 5
            optRM = RM;
            optTM = TM;
            break;
        end
        if inlierNum > maxInlier 
            optRM = RM;
            optTM = TM;
            maxInlier = inlierNum;
        end
    end
  
    traceCount = traceCount + 1;
    traceCamera(traceCount, :) = (BRM*optTM+traceCamera(traceCount-1,:)')' ;
    BRM = BRM * optRM;
    
    figure(2);
    pcshow(traceCamera, 'MarkerSize', 300, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    
    beforePoints = afterPoints;
    beforeImage = afterImage;
end

% figure();
% pcshow(traceCamera, 'MarkerSize', 300, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
% xlabel('X (m)');
% ylabel('Y (m)');
% zlabel('Z (m)');

release(colorDevice); 
release(depthDevice); 
