%xyzFloorPoints = find_plane(xyzPoints, 0);
xyzFloorPoints = findFloorPlane(xyzPoints, 0);
figure(1);
pcshow(xyzFloorPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
% ǥ�õǴ� �׷����� �� �̸��� ����.
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

figure(2);
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
% ǥ�õǴ� �׷����� �� �̸��� ����.
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');