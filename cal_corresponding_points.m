function [P1, P2] = cal_feature_points_correspondance(img1, img2, mask)
% This function extracts the top features from two images and
% computes the correspondence between these points
%
% input
%   img1: image 1 in RGB
%   img2: image 2 in RGB
%   mask: feature points outside mask are discarded
%
% output:
%   P1: the extracted feature points for test image
%   P2: the extracted feature points for reference image

% Images are downsampled so that their x dimension has 256 pixels.
low_resolution_sx = 256;
low_resolution_scale = size(img1, 1) / low_resolution_sx;

% The number of best match points considered.
max_num_matches = 30;

% display results
display = true;

% Low resolution image
I1 = imresize_by_sx(rgb2gray(img1),low_resolution_sx);
I2 = imresize_by_sx(rgb2gray(img2),low_resolution_sx);

% Get the Key Points
Ipts1=cal_points_and_features(I1);
Ipts2=cal_points_and_features(I2);

% Put the landmark features in a matrix
D1 = reshape([Ipts1.feature],64,[]);
D2 = reshape([Ipts2.feature],64,[]);

% Find the best matches
err=zeros(1,length(Ipts1));
cor1=1:length(Ipts1);
cor2=zeros(1,length(Ipts1));
for i=1:length(Ipts1),
    distance=sum((D2-repmat(D1(:,i),[1 length(Ipts2)])).^2,1);
    [err(i),cor2(i)]=min(distance);
end

% Sort matches on vector distance
[err, ind]=sort(err);
cor1=cor1(ind);
cor2=cor2(ind);

% Make vectors with the coordinates of the best matches
Pos1=[[Ipts1(cor1).y]',[Ipts1(cor1).x]'];
Pos2=[[Ipts2(cor2).y]',[Ipts2(cor2).x]'];
Pos1=Pos1(1:max_num_matches,:);
Pos2=Pos2(1:max_num_matches,:);

% Filter out the feature points outside the mask;
k = 1;
for i = 1:max_num_matches
    x1 = round(Pos1(i,1)*low_resolution_scale);
    y1 = round(Pos1(i,2)*low_resolution_scale);
    x2 = round(Pos2(i,1)*low_resolution_scale);
    y2 = round(Pos2(i,2)*low_resolution_scale);
    if((mask(x1,y1,1)~=0) && (mask(x2,y2,1)~=0))
        P1(k,1) = x1;
        P1(k,2) = y1;
        P2(k,1) = x2;
        P2(k,2) = y2;
        k=k+1;
    end
end

% Display results nicely for debug.
if display
    clear I1 I2 distance D1 D2
    I = uint8(zeros([size(img1,1) size(img1,2)*2]));
    I(:,1:size(img1,2))=uint8(rgb2gray(img1));
    I(:,size(img1,2)+1:size(img1,2)+size(mask,2))=uint8(rgb2gray(mask));
    figure, imagesc(I); colormap(gray); hold on; axis off;
    title('Feature Point Extraction','FontSize', 20,'FontWeight','bold');

    % Show the best matches
    plot([P1(:,2) P2(:,2)+size(img1,2)]',[P1(:,1) P2(:,1)]','-');
    plot([P1(:,2) P2(:,2)+size(img1,2)]',[P1(:,1) P2(:,1)]','o');
end

P1=[P1(:,2),P1(:,1)];
P2=[P2(:,2),P2(:,1)];

