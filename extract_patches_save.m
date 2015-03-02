function saved_file_paths = extract_patches_save(I, rois, file_path)
% Extract all the images of ROI and save them.
%
% input
%   I: the image
%   rois: a list of strcutures, each has coordinates of a ROI and its name.
%   file_path: all patches are saved into the file path
%
% output
%   saved_file_paths: a list of saved file paths.

for i = 1 : length(rois)
    roi = rois{i};
    patch = I(...
        round(roi.coord(1,2)):round(roi.coord(2,2)),...
        round(roi.coord(1,1)):round(roi.coord(2,1)), :);
    saved_file_paths{i} = [file_path roi.name '.jpg'];
    imwrite(patch, saved_file_paths{i});  
end
