function fpts = cal_points_and_features(I)
% Extracts interest points and their feature vectors.
%
% inputs
%   I : An image in greyscale
%
% outputs
%   fpts: a list of feature points object.
%     fpts.x ,fpts.y, fpts.scale : scale and position of points
%     fpts.feature : The feature for corresponding point matching

% Don't search for optimum beyond scale 5
max_scales = 5;

% Threshold for a point to be considered to be interest point
thresh = 0.0001;

% Integral image
iimg = cumsum(cumsum(I,1),2);

% Extract the interest points
fpts = cal_interest_points(iimg, max_scales, thresh);

% Compute the 64 feature for each point
fpts = cal_point_features(fpts, iimg);
