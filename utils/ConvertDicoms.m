function filenamesNifti = ConvertDicoms(FILENAMES, DIR_OUTPUT)
% ------------------------------------------------------------------
%
% converts DICOM images to nifti format
% 
% Input:
%       FILENAMES           ... 2-dim cell-array of char-matrices of
%                               full-path filenames
% 
%       DIR_OUTPUT          ... string, folder path, where the nifti files
%                               should be written
% 
% Output:
%       filenamesNifti      ... cell-array of char-matrices, with full-path
%                               filenames of the created Nifti files.
% 
% Usage: 
% 
% Use the dimensions of the cell-array of FILENAMES to keep track the
% DICOMS of different runs and echoes (e.g. {nRuns, nEchoes}). 
%
% ------------------------------------------------------------------
[nRuns, nEchoes] = size(FILENAMES);

% NOTE: SPM writes newly created nifti files to
% current directory, so we temporarily jump to the
% 'output' directory
oldFolder = pwd;
cd(DIR_OUTPUT);

% combine each run separately
for iRun=nRuns:-1:1
    for iEcho = nEchoes:-1:1
        files = FILENAMES{iRun,iEcho};
        
        % it could be that a certain run has fewer echoes than other
        % runs. This would mean that a certain {iRun,iEcho} combination
        % might be emtpy, so we just skip it - SPM would otherwise throw
        % an error...
        if isempty(files), continue; end
            
        % grab headers of files
        hdr = spm_dicom_headers(files);
        
        % convert dicom to nifti
        tmp = spm_dicom_convert(hdr,'mosaic','flat','nii');
        
        % keep new filenames 
        filenamesNifti{iRun,iEcho} = tmp.files;
    end
end

% make sure the content of filenames{:} are matrices, not cell-arrays. 
for i=numel(filenamesNifti):-1:1
    filenamesNifti{i} = cell2mat(filenamesNifti{i});
end

% and return back to original folder
cd(oldFolder);

end