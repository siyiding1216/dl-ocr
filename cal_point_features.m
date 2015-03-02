function ipts = cal_point_features(ipts, img)
% Computes features (64) for each point.
% inputs
%   ipts: Interest Points (x,y,scale)
%
% outputs
%   ipts: Interest Points with features (x,y,scale,orientation,feature)

if (isempty(fields(ipts))), return; end
for i=1:length(ipts)
   ipts(i).orientation=get_direction(ipts(i),img);
   ipts(i).feature=get_feature(ipts(i), img);
end
