% CreateHistogram(data, nBins, titleString, figureFilename)
% 
% Input:
%       data            ... array of image data. typically 4D array
%       nBins           ... number of bins for histogram
%       titleString     ... title to print in figure
%       figureName      ... filename under which to save figure
% 
% Output:
%   picture of histogram, but no variables are returned.
% 
function CreateHistogram(DATA, N_BINS, TITLE_STRING, FIGURE_FILENAME)

f = figure;
hist(DATA(:),N_BINS);
title(TITLE_STRING)
xlabel('Value of intensity')
ylabel('Pixel count')
saveas(f, FIGURE_FILENAME)
close(f)


end