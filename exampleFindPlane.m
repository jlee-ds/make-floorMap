xyzFloorPoints = findFloorPlane(xyzPoints, 0);
figure(1);
pcshow(xyzFloorPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
%set tne name of graph label
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

figure(2);
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
%set tne name of graph label
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
