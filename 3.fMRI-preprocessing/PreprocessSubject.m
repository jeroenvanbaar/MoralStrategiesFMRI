function PreprocessSubject(SUBJECT_NUMBER, SESSION_NUMBER)
% -------------------------------------------------------------------------
% Function: PreprocessSubject(SUBJECT_NUMBER,SESSION_NUMBER)
% 
% Preprocess combined data using SPM12. After combining, the images are
% realigned already, so we continue with the typical SPM12 preprocessing
% pipeline after that: Slice time correct, Segment structural, Coregister
% functional and structural images, Normalize both, and Smooth.
% 
% The final output will be 'swacrf*.nii' images which you can use for your
% first-level anaylsis.
% 
% -------------------------------------------------------------------------
%
% Input:
%  SUBJECT_NUMBER       ... integer, indicating subject number
%  SESSION_NUMBER       ... [optional] integer,indicating session number,
%                           if not provided, will be set to 1.
% 
% Usage: 
%   This is meant to be used via:
%       qsubfeval(@PreprocessSubject, s, 'memreq', cfg.memreq, ...
%                   'timreq', cfg.timreq);
%   OR:
%       batch_PreprocessSubject.m
%   OR: in an interactive matlab session:
%       PreprocessSubject(13);
% -------------------------------------------------------------------------

% set default session number
if ~exist('SESSION_NUMBER','var')
    SESSION_NUMBER=1;
end

if ~exist('logs','dir'); mkdir('logs'); end
diary(['logs/preprocessing_subject' num2str(SUBJECT_NUMBER) '.log'])
fprintf('========================================================================\n');

% add path '../utils' to matlab PATH, without having relative path
% note: if this is not done, mfilename will return relative path, which
% might mess up other script, notably the GetSubjectProperties.m
[currentPath, ~, ~] = fileparts(mfilename('fullpath'));
pathParts = strsplit(currentPath,filesep);
addpath(sprintf('/%s/utils',fullfile(pathParts{1:(end-1)})));

% prepare spm jobman
% LoadSPM(); already loaded
spm_jobman('initcfg');

try
    % load subject specific details
    s = GetSubjectProperties(SUBJECT_NUMBER, SESSION_NUMBER);
    
    %- Convert Structuctural
    % ---------------------------------------------------------------------
    % set settings for converting structural images
    % load matlabbatch variable
    clear matlabbatch; % to be sure to start with a fresh job description
    run('spmbatch_structural.m');
    
    % overwrite subject-specific job-stuff (ought to be adapted such that
    % it determines based on autoTransfer property in config / metadata
    % where to find the structural DICOMs!)
    folderList = dir(s.dataRawPath);
    for i = 3:length(folderList)
        if strcmp(folderList(i).name(1:3),sprintf('%03d',s.structuralSeries))
            structuralSourcePath = [s.dataRawPath,'/',folderList(i).name];
        end
    end
%     matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{s.dataRawPath}};
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{structuralSourcePath}};
%     matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = sprintf('%s\\.%04d',upper(s.scannerName), s.structuralSeries); % filter files based on scannername and series number
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.IMA'; % filter files based on scannername and series number
    matlabbatch{3}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = s.dataStructuralPath; % this is an absolute path, so the parent is '/'
    matlabbatch{3}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/'};
    
%     fileFilter = sprintf('%s/*%s.%04d*',s.dataRawPath, upper(s.scannerName),s.structuralSeries);
    fileFilter = sprintf('%s/*.IMA',structuralSourcePath);
    %- assert raw data still present, otherwise skip this step
%     if ~( exist(s.dataRawPath,'dir') && ~isempty(dir(fileFilter)) )
    if ~( exist(structuralSourcePath,'dir') && ~isempty(dir(fileFilter)) )
        fprintf('No structural DICOM files found. Skipping DICOM to Nifti conversion');
    else
        %- run SPM job
        fprintf('converting structural DICOMs to Nifti...\n');
        spm_jobman('run', matlabbatch);
        fprintf('converting structural DICOMs to Nifti - done\n');
    end
    
    %- set settings for functional data preprocessing
    %--------------------------------------------------
    % load matlabbatch variable
    clear matlabbatch; % to be sure to start with a fresh job description
    run('spmbatch_preprocessing_final.m');
    
    % overwrite subject-specific variables
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{s.dataStructuralPath}};%{{workingDirStructural}}; % where structural nifti files are
    matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{s.dataPreprocessedPath}};%{{workingDirCombined}}; % where combined nifti files are
    
    %- run SPM job
    %-----------------
    fprintf('Preprocessing functional images... \n');
    spm_jobman('serial', matlabbatch);
    fprintf('Preprocessing functional images - done\n');
    
    % clean up
    delete([s.dataPreprocessedPath '/run1/a*'],[s.dataPreprocessedPath '/run1/w*'],...
        [s.dataPreprocessedPath '/run1/rf*'],[s.dataPreprocessedPath '/run1/f*']);
        
catch err
    fprintf('ERROR: could not preprocess subject %i\n',SUBJECT_NUMBER);
    fprintf('ERROR: %s\n',err.message);
    timestamp = datestr(now,30);
    error_filename = ['error' timestamp];
    save(error_filename,'err','matlabbatch');
end

fprintf('finished proprocessing at %s\n', datestr(now));
fprintf('========================================================================\n');
fprintf('========================================================================\n');
diary off;

end

