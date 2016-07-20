% 기본적인 3D point  예제.
% 실행시킨 순간의 raw depth data를 3D point로 바꿔서 보여줌.

% kinect에서 depth 센서는 2번. 해당 디바이스에 대한 객체를 생성.
depthDevice = imaq.VideoDevice('kinect', 2);
% depth sensor의 값을 보여주는 창을 생성.
preview(depthDevice);
% warming을 위해 step을 한 번 불러줘야 한다는 데, 이해는 못함.
frame = step(depthDevice);
% 다시 step으로 순간의 raw depth data를 depthImage에 저장.
depthImage = step(depthDevice);
% 해당 data를 3D point로 변환 후 640 * 480 * 3 크기 배열에 저장.
xyzPoints = depthToPointCloud(depthImage, depthDevice);
% ???
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
% 표시되는 그래프의 라벨 이름을 설정.
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
% 객체 삭제
release(depthDevice); 