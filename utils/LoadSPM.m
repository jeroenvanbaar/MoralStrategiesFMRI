function LoadSPM()
%LOADSPM Adds SPM12 to path and loads fMRI defaults
% this works both on linux and windows machines at DCCN

if ispc
    % add spm12 to path
    addpath('H:\common\matlab\spm12');
elseif isunix
    addpath('/home/common/matlab/spm12');
else
    error('matlab does not know whether you are using windows or linux')
end

% using this instead of spm_defaults based on help  of sp_defaults
spm('Defaults','fmri')

fprintf('SPM12 added to path and fMRI detaults loaded.\n');

end

