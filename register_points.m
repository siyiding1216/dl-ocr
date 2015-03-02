function trans = register_points(P1,P2)
% Calculate affine transformation
trans = fitgeotrans([P1(:,1) P1(:,2)],[P2(:,1) P2(:,2)],'affine');

