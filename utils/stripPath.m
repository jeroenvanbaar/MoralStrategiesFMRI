function justFilename = stripPath(fullPathFilename)
% 
% For filenames that also contain path, remove the path-part and return
% only the filename, incl. extension
% 
    [~, name, ext] = fileparts(fullPathFilename);
    justFilename = [name ext];
end