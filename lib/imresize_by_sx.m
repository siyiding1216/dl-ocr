function resized_I = imresize_by_sx( I, new_sx )
% resize the input image I so that its x dimension has new_sx pixels.
[sx, sy] = size(I);
resized_I = imresize(...
    I, [new_sx,round(new_sx*sy/sx)], 'Bilinear','Antialiasing', true);
end

