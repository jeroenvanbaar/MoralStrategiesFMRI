function TE = GetTE(FILENAMES)
% ------------------------------------------------------------------
%
% Get T_Echo from DICOM headers of first files in cell-array.
%
% Input:
%   FILENAMES       ... cell-array of filenames of DICOM files. dimensions
%                       are assumed to correspond to {echoes}
%
% Output:
%   TE              ... array of length nEchoes, containing the echo times.
%
% ------------------------------------------------------------------

nEchoes = length(FILENAMES);

for iEcho = nEchoes:-1:1
    
    % grab headers of files
    files = FILENAMES{iEcho};
    
    % read header of first file from current run and echo
    hdr = spm_dicom_headers(files(1,:));
    
    % save echo time for combine-script
    TE(iEcho) = hdr{1}.EchoTime;
end



end