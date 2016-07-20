% �⺻���� 3D point  ����.
% �����Ų ������ raw depth data�� 3D point�� �ٲ㼭 ������.

% kinect���� depth ������ 2��. �ش� ����̽��� ���� ��ü�� ����.
depthDevice = imaq.VideoDevice('kinect', 2);
% depth sensor�� ���� �����ִ� â�� ����.
preview(depthDevice);
% warming�� ���� step�� �� �� �ҷ���� �Ѵٴ� ��, ���ش� ����.
frame = step(depthDevice);
% �ٽ� step���� ������ raw depth data�� depthImage�� ����.
depthImage = step(depthDevice);
% �ش� data�� 3D point�� ��ȯ �� 640 * 480 * 3 ũ�� �迭�� ����.
xyzPoints = depthToPointCloud(depthImage, depthDevice);
% ???
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
% ǥ�õǴ� �׷����� �� �̸��� ����.
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
% ��ü ����
release(depthDevice); 