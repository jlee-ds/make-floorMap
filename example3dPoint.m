%basic example of 3D point
%show 3D coordinate transformed from raw depth data when executed

%the number of Kinect depth sensor is 2
%create object according to device
depthDevice = imaq.VideoDevice('kinect', 2);

%create tab to show values of depth sensors
preview(depthDevice);

%call 'step' for warming(don't know why)
frame = step(depthDevice);

%store raw depth data at a moment to depthImage with 'step'
depthImage = step(depthDevice);

%transform data to 3D coordinate then store it to an array which size is
%640*480*3
xyzPoints = depthToPointCloud(depthImage, depthDevice);

%don't know why
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');

%set the name of graph label
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

%delete object
release(depthDevice); 
