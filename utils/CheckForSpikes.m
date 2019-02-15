function CheckForSpikes(FILENAMES, config)
% ------------------------------------------------------------------
%
% Detect spikes in your functional images.
%
% We know that spikes might create atypically high k-line values in a
% single slice. To avoid to Fourier-transform all the images (very time
% consuming..), we simply use the heuristic that when looking outside of
% the brain - i.e. where there is only noise - the spike will have
% increased the overall intensity within one slice.
% This function, thus, goes through the steps of 1) creating a mask (one of
% four possible types), 2) extracting the timeseries
%
% Given multi-echo data, there are multiple potential ways of handling
% spikes. For example, you could just drop the affected slice in teh
% affected volume and use the other echoes to calculate the combined data.
% Alternatively, you could do simply interpolate on the previous and
% subsequent volumes. Since it's an open question what to do, NO SPIKE
% REMOVAL IS IMPLEMENTED. If you want to remove spikes, you have to
% implement it yourself.
%
%
% Input:
%       FILENAMES           ... 2-dim cell-array of full-path filenames of
%                               the nifti files. The first dimension
%                               corresponds to runs, the second to echoes
%
%       CONFIG              ... a structure containing key parameters of
%                               the combining process. See beginning of
%                               function for list of properties
%
% As output, timeseries plots of the noise signal are written to the
% 'config.outputDir' folder. These files include images of slices/volumes
% where spikes were detected and timeseries plots of all images.
%
% In the config file, you can choose on of two ways of detecting spikes,
% cf. DetectSpikes.m
%
% -------------------------------------------------------------------------

% Extract config settings
%--------------------------------------------------------------------------
% fractional deviation of slice mean that qualifies as a 'spike' 0.1 = 10%
SPIKE_THRESHOLD = config.spikeThreshold;

% the mask will be squares in the corners of each slice (e.g. 8x8 voxels in
% each corner). The idea is that those voxel should be outside of the
% brain, and capture only noise.
MASK_SIZE = config.maskSize; % must be integer

% Select spikes based on 'timecourseAverage' or 'previousVolume;
DETECTION_METHOD = config.detectionMethod;

% where the output of spike detection will be saved
FOLDER_OUTPUT = config.outputDir;

% how to call the plots. This will be appended with 'run1_echo1, 'run1_echo2', etc.
FILENAME_PLOT_BASE = config.filenamePlotBase;

% Assert key assumptions are correct
%--------------------------------------------------------------------------
assert( (MASK_SIZE == floor(MASK_SIZE) ), 'Error: CheckForSpikes config.maskSize must be an integer');

% initialize some convenience variables
%--------------------------------------------------------------------------
[nRuns, nEchoes] = size(FILENAMES);
% if necessary, create output folder
[~,~,~] = mkdir(FOLDER_OUTPUT);


% get size of first volume (assuming all are the same..)
volumeHeader = spm_vol(FILENAMES{1,1}(1,:));

% create mask
%--------------------------------------------------------------------------
% create mask for slice of same size
% ie set corners of each slice to 1
mask = zeros(volumeHeader.dim);
mask(1:MASK_SIZE, 1:MASK_SIZE, :) = 1;
mask((end-MASK_SIZE+1):end, 1:MASK_SIZE, :)  =1;
mask(1:MASK_SIZE, (end-MASK_SIZE+1):end, :) =1;
mask((end-MASK_SIZE+1):end,(end-MASK_SIZE+1):end, :)  =1;

% go over runs and echoes separately
%--------------------------------------------------------------------------
nSlices = size(mask,3);
nMaskSlice = sum(reshape(mask(:,:,1),1,[])); % nVoxels per slice
for iRun=1:nRuns
    for iEcho=1:nEchoes
        
        % load current volumes of current run/echo
        %------------------------------------------------------------------
        volumeHeaders = spm_vol(FILENAMES{iRun,iEcho});
        volume4D = spm_read_vols(volumeHeaders);
        
        % calculate slice averages (after application of mask)
        %------------------------------------------------------------------
        nVolumes = size(volume4D,4);
        sliceAverage = zeros(nVolumes,nSlices);
        for iVol = 1:nVolumes
            maskedData = volume4D(:,:,:,iVol) .* mask;
            sliceAverage(iVol, :) = squeeze(sum(reshape(maskedData,1,[],nSlices)))/ nMaskSlice;
        end
        
        % detect Spikes
        %------------------------------------------------------------------
        affectedSlices = DetectSpikes(sliceAverage, DETECTION_METHOD, SPIKE_THRESHOLD);
        
        % save output of detection
        %------------------------------------------------------------------
        
        % Give alert when spikes detected, and copy affected iamges to
        % output-folder for visual inspection
        if any(affectedSlices(:))
            
            filesCurrent = FILENAMES{iRun,iEcho};
            [iVol, iSlice] = find(affectedSlices);
            
            fprintf('WARNING: Spikes detected in run %i, echo %i:\n',iRun,iEcho);
            for i=1:length(iVol)
                fprintf('Spikes detected in Volume %i, Slice %i.\n',iVol(i),iSlice(i));

                % copy affected volume to outputDir
                unixCommand = sprintf('cp %s %s',filesCurrent(iVol(i),:) , FOLDER_OUTPUT);
                unix(unixCommand);
                fprintf('Affected nifti file copied to %s\n',FOLDER_OUTPUT);
            end
        else
            fprintf('No Spikes detected in run %i, echo %i.\n',iRun,iEcho);
        end
        
        % Save timeseries plot of all slices
        % Make plot of sliceAverage=f(time) in percent
        f = figure(333);
        plot(sliceAverage ./ (ones(size(sliceAverage,1),1) * mean(sliceAverage,1)));
        line((1:size(sliceAverage, 1)), (1+SPIKE_THRESHOLD));
        v = axis; v(4) = max(v(4), 1.5*(1+SPIKE_THRESHOLD)); axis(v);
        title 'mean slice signal as f(time) in percent of temporal-mean signal of slice'
        xlabel 'time [scan number]'
        ylabel 'mean signal of slice [percent]'
        filenamePlot = sprintf('%s/%s_run%i_echo%i.png',FOLDER_OUTPUT, FILENAME_PLOT_BASE,iRun,iEcho);
        export_fig(filenamePlot)
        close(f);
        
    end
end




end

