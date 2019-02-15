% CreateMeanCurvePlot(data,titleString, fullFilename)
% creates plot of mean signals
%
% Input:
%   data            ... 4D array containing all image data
%   titleString     ... String used for title of figure
%   fullFilename    ... String. full path filename (ie including folder)
%                       under which file can be saved
% Output:
%   image containing figure is saved on disk, but no variable is returned
%
function CreateMeanCurvePlot(DATA,TITLE_STRING, FULL_FILENAME)
% data is assumed to be 4D array, with dimensions X by Y by Z by Time

[dimX, dimY, dimZ, dimTime] = size(DATA);

% calculate mean signal per slice, as f(time)
sliceSignal = squeeze(mean(reshape(DATA,[dimX*dimY, dimZ, dimTime]))); % collapse across first 2 dim
% calculate mean signal per whole volume, as f(time)
globalSignal = squeeze(mean(reshape(DATA,[dimX*dimY*dimZ, dimTime]))); % collapse across first 3 dim

figureHandle = figure('NumberTitle','off');
set(figureHandle,'Color','w');

% mean signal per slice, as f(time)
subplot(2,2,1); 
plot(sliceSignal');
title_str = sprintf('mean signal per slice as f(time)');
title(['Slice Sig ' title_str]);

% variance of mean signal, as f(slice)
subplot(2,2,3); 
plot(var(sliceSignal,0,2));
title('Variance of mean signal as f(slice):');

% global-mean signal 
subplot(2,2,2); 
plot(globalSignal);
title('Global-mean signal');

% variance of global signal
subplot(2,2,4); 
bar(var(globalSignal));
title('Variance of global signal');

% write title for figure
suplabel(TITLE_STRING, 't');

% save figure to file
saveas(figureHandle, FULL_FILENAME,'png');
close(figureHandle)
end