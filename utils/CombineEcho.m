function CombineEcho(FILENAMES, TE, DIR_OUTPUT, CONFIG)
% ------------------------------------------------------------------
%
% Combine multi-echo data
%
% Input:
%       FILENAMES           ... 2-dim cell-array of full-path filenames of
%                               the nifti files. The first dimension
%                               corresponds to runs, the second to echoes
%
%       TE                  ... array (of same length as number of
%                               runs) of the echo times of that run
%
%       DIR_OUTPUT          ... string, folder path, where the nifti files
%                               should be written
%
%       CONFIG              ... a structure containing key parameters of
%                               the combining process. See beginning of
%                               function for list of properties
%
% Output:
%  No explicit function output.
%  Instead, files are written to the DIR_OUTPUT folder. These files include
%  realigned/resliced images (prefixed with 'r') AND the final combined
%  files (prefixed with 'c' for 'combined').
%
%
% Usage:
%
% Provide a two dimensional cell-array of filenames (nifti), and the echo
% times. This script will do the following steps:
%   1) realign the first echo of each run to the grand mean across all runs
%       using SPM's double-pass procedure (ie first to first image, then to
%       grand mean).
%   2) apply realignment parameters to all remaining echoes
%   3) reslice the images
%   4) calculate the echo-weights using PAID (Poser et al, 2006)
%   5) combine the echoes of each run by applying those weights
%
% ------------------------------------------------------------------

% extract settings from config file
N_WEIGHTING_VOLUMES     = CONFIG.nWeightingVolumes;
SAVE_WEIGHTS            = CONFIG.saveWeightsToFile;
FILENAME_WEIGHTS        = CONFIG.filenameWeights;

[nRuns, nEchoes] = size(FILENAMES);

assert(length(TE) == nEchoes, 'CombineEchoe: Expecting TE to have same length as number of echoes in FILENAMES. Instead: length(TE)=%i, nEchoes=%i',length(TE),nEchoes);



% step 0: change current working directory
oldFolder = pwd;
cd(DIR_OUTPUT);


% step 1: realign
% ------------------------------------------------------------------
% we're using SPM12 realgining of 'multi session' data (here called 'runs')
% by first realigning all images within a single run (double-pass) and then
% by aligning the first images to each other.
% Importantly, only first echo of each run is used to calculate the affine
% transformation parametes (aka motion parameters), which are then applied
% to all the remaining echoes. This is based on the rationale that the
% first echo has the largest mean intensity, so estimating the affine
% transformation is going to be the easiest.
% The resulting motion parameters are all per run, despite the runs being
% actually aligned to each other.

% first realign first echo:
flags.rtm = 1; % use 2-pass procedure
% by providing FILENAMES as a cell array, spm_realign understands them
% automatically as 'sessions' (SPM terminology), ie runs.
spm_realign(FILENAMES(:,1),flags);

for iRun=1:nRuns
    nVolumes = size(FILENAMES{iRun,1},1);
    filesFirstEcho = FILENAMES{iRun,1};

    for i=1:nVolumes% 1:nFiles
        % load voxel-to-world mapping from realigned, first echo
        V = spm_get_space(filesFirstEcho(i,:));

        for iEcho=2:nEchoes
            % realigned by applying voxel-to-world mapping from first echo
            spm_get_space(FILENAMES{iRun,iEcho}(i,:),V);
        end
    end
end


% step 2: reslice
% ------------------------------------------------------------------
% this step actually write new nifti files (prefixed with 'r') into the
% DIR_OUTPUT folder.


spm_reslice(FILENAMES(:));



% since spm_reslice doesn't return the filenames of the newly created
% files, we have to infer them:
filenamesResliced = AddPrefix(FILENAMES,'r');

% step 3: Calculate Weights
% ------------------------------------------------------------------
% Each run is combined separately.

for iRun=nRuns:-1:1
    % get list of all prescans
    for iEcho=nEchoes:-1:1
        filenamesPrescans{iEcho}=filenamesResliced{iRun,iEcho}(1:N_WEIGHTING_VOLUMES,:);
    end
    
    % use first image to initialize SPM volume object and 4D array
    dimVolume = spm_vol(filenamesPrescans{1}(1,:));
    dim = dimVolume.dim;
    volume5D = zeros(dim(1),dim(2),dim(3),N_WEIGHTING_VOLUMES,nEchoes);
    
    % get timeseries of prescans
    for iVol=1:N_WEIGHTING_VOLUMES
        for iEcho=1:nEchoes
            V = spm_vol(filenamesPrescans{iEcho}(iVol,:));
            volume5D(:,:,:,iVol,iEcho) = spm_read_vols(V);
        end
    end
    
    % calculate weights based on tSNR of prescan timeseries(c.f. Poser et al., (2006).
    % doi:10.1002/mrm.20900)
    tSNR = zeros(dim(1),dim(2),dim(3),nEchoes);
    CNR = zeros(dim(1),dim(2),dim(3),nEchoes);
    weight = zeros(dim(1),dim(2),dim(3),nEchoes);
    
    for j=1:nEchoes
        % for some voxels, the signal can be continuosly zero. We need to
        % keep the tSNR at zero (by setting only those values where it's
        % larger than zero):
        tmp =  mean(volume5D(:,:,:,:,j),4) ./ std(volume5D(:,:,:,:,j),0,4);
        tmp(isnan(tmp)) = 0; % we obtain NaN if above was "0/0", so we set it to zero
        tSNR(:,:,:,j) = tmp;
        CNR(:,:,:,j) = tSNR(:,:,:,j) * TE(j);
    end
    
    CNRTotal = sum(CNR,4);
    
    for j=1:nEchoes
        weight(:,:,:,j) = CNR(:,:,:,j) ./ CNRTotal;
        weight(isnan(weight)) = 0; % above line could produce NaN if "0/0". We set that weight to zero.
    end
    if any(isnan(weight(:)))
       fprintf('ERROR: NaN occurred in weights calculation\n'); 
    end
    weights{iRun} = weight;
end

% step 4: Apply Weights
% ------------------------------------------------------------------

% combine echos of all functional images using weights calculated based on
% prescans


for iRun = nRuns:-1:1
    clear V; % delete previously used 'V' variable..
    
    % loop over all timepoints (ie files in one echo)
    for iVolume = 1:size(filenamesResliced{iRun,1},1)
        % grab all volumes of same timepoint
        for j=1:nEchoes
            V{j} = spm_vol(filenamesResliced{iRun,j}(iVolume,:));
        end
        
        % create new volume variable
        newVolume = V{1};
        % follow SPM convention to prefix with single letter to indicate preprocessing step
        newVolume.fname = AddPrefix(newVolume.fname, 'c');
        newVolume.descrip = 'PAID combined'; % update description
        
        % combine echoes of current timepoint
        I_weighted = zeros(newVolume.dim);
        % Initilize 4d array
        I = zeros(dim(1),dim(2),dim(3),nEchoes);
        % grab weights for current run
        weight=weights{iRun};
        for j=1:nEchoes
            I(:,:,:,j) = spm_read_vols(V{j});
            I_weighted = I_weighted + I(:,:,:,j).*weight(:,:,:,j);
        end
        
        % write new volume to disk
        spm_create_vol(newVolume);
        spm_write_vol(newVolume,I_weighted);
    end
end

if SAVE_WEIGHTS
    save(FILENAME_WEIGHTS,'weights');
end

% step XX: change back to original working directory
cd(oldFolder);

end