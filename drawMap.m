% 2016. 11. 17. made by Jongwon Lee and Soree Choi.
% Hanyang Uni. Last project for graduation.
% url: [https://github.com/jlee-ds/makeFloorMap]

% This code is to make a map from 3d points.
% 1. get a floor plane equation. 
% 2. make the floor plane equation be XZ plane(in camera coordinate).
% 3. use the absolte Y value as height.
% 4. make a map.

cell_size = 1;
obs_height = 0.1;

floorPlane = findFloorPlane(xyzPoints);
% floorPlane = [A,B,C,D], Ax+By+Cz+D=0

xyzFloorPoints = remainFloorPoints(xyzPoints, floorPlane);
figure(2);
pcshow(xyzFloorPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

y = -floorPlane(4)/floorPlane(2); % y = -D/B
floorPlane(4) = floorPlane(4) - y; % now the plane cross the (0,0,0).

% find X-axis rotation matrix. 
v = [0,0,1];
nv = floorPlane(1:3);
angle = pi/2 - atan2(norm(cross(v,nv)),dot(v,nv));
angle = -angle;
Rx = [[1,0,0];[0,cos(angle),-sin(angle)];[0,sin(angle),cos(angle)]];

% find Z-axis rotation matrix.
v = [1,0,0];
nv = Rx * floorPlane(1:3)';
nv = nv';
angle = pi/2 - atan2(norm(cross(v,nv)),dot(v,nv));
Rz = [[cos(angle),-sin(angle),0];[sin(angle),cos(angle),0];[0,0,1]];

% change all points.
xyzNewPoints = NaN(480, 640, 3);
mapObj = containers.Map('KeyType','double','ValueType','any');
for i=1:480
    for j=1:640
        if isnan(sum(xyzPoints(i,j,:)))
            xyzNewPoints(i,j,:) = xyzPoints(i,j,:);
            continue;
        else
            xyzNewPoint = zeros(3,1);
            xyzNewPoint(:,1) = xyzPoints(i,j,:);
            xyzNewPoint(2,1) = xyzNewPoint(2,1) - y;  
            xyzNewPoints(i,j,:) = Rz * (Rx * xyzNewPoint);
            key_x = floor(xyzNewPoints(i,j,1)*10/cell_size);
            key_z = floor(xyzNewPoints(i,j,3)*10/cell_size);
            height = abs(xyzNewPoints(i,j,2));
            key_sign = 0;
            if key_x >= 0 && key_z >= 0
                key_sign = 1;
            elseif key_x >=0 && key_z < 0
                key_sign = 2;
            elseif key_x < 0 && key_z >= 0
                key_sign = 3;
            else
                key_sign = 4;
            end
            % make a key for map Object.
            key = key_sign * 100000000 + abs(key_x) * 10000 + abs(key_z);
            if isKey(mapObj,key)
                % already exist.
                info = mapObj(key);
                new_height = (info(2) * info(3) + height) / (info(3) + 1);
                if new_height < obs_height
                    mapObj(key) = [0, new_height, info(3)+1];
                    % [isObstacle, avg, count]
                else
                    mapObj(key) = [1, new_height, info(3)+1];
                end
            else
                % not exist.
                if height < obs_height 
                    mapObj(key) = [0, height, 1]; 
                else
                    mapObj(key) = [1, height, 1];
                end
            end
        end
    end
end

% show result of traslation and rotation.
figure(3);
pcshow(xyzNewPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

% draw floor's map.
figure(4);
key_set = keys(mapObj);
cell_count = length(mapObj);
for i = 1:cell_count
    key = cell2mat(key_set(i));
    info = mapObj(key);
    key_sign = floor(key/100000000);   
    key_x = floor(mod(key,100000000)/10000);
    key_z = mod(key,10000);
    if key_sign == 2
        key_z = -key_z;
    elseif key_sign == 3
        key_x = -key_x;
    elseif key_sign == 4
        key_x = -key_x;
        key_z = -key_z;
    end
    if info(1) == 0
        rectangle('Position',[key_x,key_z,cell_size,cell_size],'FaceColor','g','EdgeColor','k','LineWidth',3)
    elseif info(1) == 1
        rectangle('Position',[key_x,key_z,cell_size,cell_size],'FaceColor','r','EdgeColor','k','LineWidth',3)
    end
end
xlabel('X');
ylabel('Z');