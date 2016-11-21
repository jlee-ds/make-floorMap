% 2016. 11. 17. made by Jongwon Lee and Soree Choi.
% Hanyang Uni. Last project for graduation.
% url: [https://github.com/jlee-ds/makeFloorMap]

% calculate Rotation and Transition Matrix which transform AP to BP.
% Rotation Matrix (3*3), Transition Matrix (3*1)
% AP, BP - 3*3 Matrix, [[x1,x2,x3];[y1,y2,y3];[z1,z2,z3]]

function [ R, T ] = getRT(AP, BP)

AP_centroid = [sum(AP(1,:))/3;sum(AP(2,:))/3;sum(AP(3,:))/3];
BP_centroid = [sum(BP(1,:))/3;sum(BP(2,:))/3;sum(BP(3,:))/3];
% calculate centroid to move it's center to (0,0,0).

H = zeros(3,3);
for i=1:3
    H = H + (AP(:,i) - AP_centroid)*(BP(:,i) - BP_centroid)';
    % make its centroid be (0,0,0) and multiply AP and BP. (3*1)*(1*3) = (3*3)
    % sum the result. (= H)
end
[U,S,V] = svd(H);
R = V*U';
if det(R) < 0
    V(:,3) = V(:,3) .* (-1);
    R = V*U';
end
T = -R*AP_centroid + BP_centroid;
% equation reference: [http://nghiaho.com/?page_id=671]

T = round(T, 2);
end

