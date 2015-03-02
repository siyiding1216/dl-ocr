function run_tesseract(patch_paths)

% add path for tesseract
functionname='tesseract.exe';
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
addpath([functiondir])

command_base = '!tesseract %s %s';

for i = 1:length(patch_paths)
    command = sprintf(command_base, patch_paths{i}, [patch_paths{i} '_tesseract']);
    eval(command);
end