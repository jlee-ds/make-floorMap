% 2016. 11. 17. made by Jongwon Lee and Soree Choi.
% Hanyang Uni. Last project for graduation.
% url: [https://github.com/jlee-ds/makeFloorMap]

% This code is to get 3d points from kinect depth sensor.
% and to show the 3d points.

% the number of Kinect depth sensor is 2
% create object according to device
depthDevice = imaq.VideoDevice('kinect', 2);

% call 'step' for warming(don't know why)
frame = step(depthDevice);

% store raw depth data at a moment to depthImage with 'step'
depthImage = step(depthDevice);

% transform data to 3D coordinate then store it to an array which size is
% 640*480*3
xyzPoints = depthToPointCloud(depthImage, depthDevice);

% show 3D points
figure(1);
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');

% set the name of graph label
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

% delete object
release(depthDevice); 
