function filenamesDicom = GetAllDicomNames( FIRST_SERIES, N_SERIES, FOLDER )
% ------------------------------------------------------------------
%
% load all DICOM filenames of a specific set of 'scan series'.
%
% Input: 
%       FIRST_SERIES        ... array, indicating the series number being 
%                               to load
%       N_SERIES            ... array, indicating how many consecutive 
%                               series to load, starting with the series
%                               number indicated in FIRST_SERIES
%       FOLDER              ... in which folder the DICOM files are located
% 
% Output:
%       filenamesDicom      ... cell-array of char-matrices, with first 
%                               dimension corresponding to FIRST_SERIES
%                               (e.g. run), and second dimension to
%                               N_SERIES number (e.g. echo).
% Usage:
%   This function is used to load, for example, the function volumes of
%   multi-echo, multi-run data. For that, indicate the FIRST_SERIES of the
%   first echo of each run (e.g. [7 11 15] for three runs), and the number 
%   of echoes in N_SERIES (e.g. [4 4 4] for four echoes in each of the
%   three runs). The result will be a 3x4 cell-array (three runs, four
%   echoes).
%   
%   Typically, this function will be called by another script.
%   Importantly, this assumes DCCN naming conventions of the DICOM files.
% 
% NOTE: if the exportation of the data from the MRI host PC was done on
% another day then the scan was aquired, this fill fail, because the date
% in the filename is the exportation date, and not the aquisition date. The
% simplest solution is to rename the files to match the aquisition date.
% 
% ------------------------------------------------------------------

nFirst = length(FIRST_SERIES);

assert(length(N_SERIES) == nFirst, 'GetAllDicomNames: Expecting FIRST_SERIES to be the same length as N_SERIES. See function help for usage description. Instead: length(N_SERIES)=%i and nFirst=%i', length(N_SERIES),nFirst);

% list all DICOMs in folder
allFiles = dir([FOLDER '/*.IMA']);

% use first DICOM to extract string-before-series-number, ie scanner
% name, e.g. 'SKYRA'
firstDicomInfo = dicominfo([FOLDER '/' allFiles(1).name]);
expDate = firstDicomInfo.InstanceCreationDate;
expDate = [expDate(1:4) '.' expDate(5:6) '.' expDate(7:8)];
stringBeforeSeriesNumber = allFiles(3).name(strfind(allFiles(3).name,expDate)-16:strfind(allFiles(3).name,expDate)-12); % e.g. 'SKYRA'

% load list of files for each run and echo, one at a time
for iFirst = nFirst:-1:1
    currentNSeries = N_SERIES(iFirst);
    for iSeries = currentNSeries:-1:1
        % each echo has its own runSeries number, always increasing by one
        currentSeriesNumber = FIRST_SERIES(iFirst)+(iSeries-1);
        
        % select all DICOMs of current series number
        filesTemp = dir([FOLDER '/*' stringBeforeSeriesNumber '.' sprintf('%.4d', currentSeriesNumber) '*.IMA']);
        fileNames = char(zeros(length(filesTemp),length(filesTemp(1).name)+2));
        for i=1:size(fileNames ,1)
            fileNames (i,1:length(filesTemp(i).name)) = filesTemp(i).name;
        end
        % prepare to prepend folder, to make filenames full-path
        a = repmat([FOLDER, '/'], size(fileNames,1),1);
        % store filenames
        filenamesDicom{iFirst,iSeries}  = cat(2, a , fileNames);
    end
end

end
