# make-floorMap
After moving through the corridor, make a map of floor with KINECT v1.
We used MATLAB program for coding.
We completed two processes. One is camera pose tracing and the other is make 2d map of floor.
You can reference this code only for educational purpose.

> Trace Camera Pose

    - related code: traceCameraPose.m, getRT.m
    - compare two 2D image and 3D points to get relative camera pose.

> Make Map of Floor

    - related code: drawMap.m, findFloorPlane.m, planeFromPoints.m, findNormalVector.m
    - code for test: example3dPoint.m, remainFloorPoints.m
    - variable for test: EX_3dPoint.mat
    - calculate floor plane with RANSAC. find obstacle region with height value.
    - make a map of floor. (obstacle = red)
