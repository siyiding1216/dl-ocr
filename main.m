clear all;
close all;
addpath(['../../']);

Params.create_atlas = false;
Params.atlas_path = 'atlas_ca.mat';
Params.template_path = 'template_ca.jpg';
Params.test_path = 'test_ca.jpg';
Params.template_lable = 'CA';
Params.test_patch_path = 'test_ca';

if Params.create_atlas
    % create atlas
    I = imread('template_ca.jpg');
    atlas = create_atlas(I,'CA');
    save(Params.atlas_path,'atlas');
    return;
end

% load data
load(Params.atlas_path, 'atlas');
ref = im2double(atlas.original_image);
test = im2double(imread(Params.test_path));
foreground = im2double(atlas.foreground_image);

% Extract feature points
[P1,P2] = cal_corresponding_points(test,ref,foreground);

% register points and warp image
trans = register_points(P1,P2);
test_in_ref = imwarp(test,trans,'OutputView',imref2d(size(ref)));

figure;
imshowpair(rgb2gray(atlas.original_image),rgb2gray(test_in_ref),'blend');
figure;
imshowpair(rgb2gray(atlas.foreground_image),rgb2gray(test_in_ref),'blend');
title('Registered DL','FontSize', 24,'FontWeight','bold'); axis off;

% warp the points and save small image into files
patch_path = extract_patches_save(test_in_ref, atlas.rois, Params.test_patch_path);

% run character recognition
run_tesseract(patch_path);
