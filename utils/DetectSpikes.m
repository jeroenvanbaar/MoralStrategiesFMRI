function [affectedSlices] = DetectSpikes(SLICE_AVERAGE, DETECTION_MODE, THRESHOLD)
%
% This function detects spikes in volumes and slices. It has two modes
% of operation:
%
% 1. 'previousVolume'
%   Select a slice as containing a spike if its value is larger than:
%   threshold * mean(previous volume)
%
% 2. timevourse average
%   Select a slice as containing a spike if its value is larger than:
%   threshold * mean(current slice over all volumes)
%
%
%
% Input
%       SLICE_AVERAGE           ... 2-dim matrix (nVolumes, nSlices), which
%                                   contains the slice averages
%       DETECTION_MODE          ... String. 'previousVolume' or
%                                   'timeCourseAverage'
%       THRESHOLD               ... Number. See description of modes above
%                                   for how this number is used
%
% Output
%       affectedSlices        ... logical matrix. the same as input
%                               variable SLICE_AVERAGE, where 1 indicates
%                               an affected slice, 0 a fine slice


%Preallocate affected volume information
affectedSlices  = zeros(size(SLICE_AVERAGE));

switch DETECTION_MODE
    case 'previousVolume'
        
        % calculate how average slice signal changes from one timepoint to the other
        signalChanges = diff([SLICE_AVERAGE(end,:) SLICE_AVERAGE],1,1); % prepending last volume to be able to detect spike in the first volume as well
        
        % detect spikes:
        ind = signalChanges > THRESHOLD .* SLICE_AVERAGE;
        
    case 'timecourseAverage'
        meanSliceAverages = mean(SLICE_AVERAGE, 1);
        
        % calculate how the slice deviates from mean signal of slice
        signalDeviation = SLICE_AVERAGE - ones(size(SLICE_AVERAGE,1),1)*meanSliceAverages;
        
        % detect spikes:
        ind = signalDeviation > THRESHOLD .* SLICE_AVERAGE;
        
    otherwise
        error('Error: unknown detection-mode ''%s''. See DetectSpikes.m for valid modes.')
end

% and set indicator
affectedSlices(ind) = 1;

