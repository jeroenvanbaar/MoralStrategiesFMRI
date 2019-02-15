% CreateMovie of mosaic, a bit like when looking at the images as they
% get aquired at the scanner
%   Input:
%       config          ... config struct. see code for which settings
%                           needed.
%       data            ... 4D array. data of images, where 4th dimension
%                           is time.
%   Output:
%       only files written to output folder. Function does not return a
%       value.
% 
function CreateMovie(config, DATA)
%- set movie-script settings
%----------------------------
% there are two ways of defining a movie's clim properties
% (all frames are created using matlab's imagesc()):
%   1) via "brightness"
%       in this case, the clim is calculated as:
%           clim=[min, min + (max-min)/brightness]
%       where min and max refer to the maximum and minimum
%       intensities across all images, and brightness is
%       provided via the clims{i}.value variable
%
%   2) via "percentiles"
%       in this case, clim is calculated by first
%       calculating the lower and upper thresholds, as
%       defined via percentile fractions:
%           thresholdLow = prctile(imageData(:),lowerLimit*100);
%           thresholdHigh = prctile(imageData(:), upperLimit*100);
%           clims{i} = [thresholdLow thresholdHigh];
%       where imageData contains the data of all images,
%       and lowerLimit and upperLimit are provided using
%       clims{i}.value(1) and clims{i}.value(2) variables
%- which version of clim definition is depends on the clims{i}.type value:
CLIM_TYPE_PERCENTILE = 'percentile'; % expects CLIMS{i}.values = [lower upper];
CLIM_TYPE_BRIGHTNESS = 'brightness'; % expects CLIMS{i}.values = brightness;
CLIMS = config.clims;
% array of filenames for the different movies. must be the same length as
% CLIMS
MOVIE_FILENAMES = config.movieFilenames;
% Frames per second.
FPS = config.framesPerSecond;
% where to save resulting movies
FOLDER_OUTPUT = config.folderOutput;
% which compression type VideoWriter will use
COMPRESSION_TYPE = config.compressionType;


% assert some more 'hidden' assumptions
%---------------------------------------
assert(length(CLIMS)==length(MOVIE_FILENAMES),'config.clims and config.movieFilenames must have the same length');
for iMovie=1:length(CLIMS)
    switch CLIMS{iMovie}.type
        case CLIM_TYPE_BRIGHTNESS
            assert(length(CLIMS{iMovie}.value)==1, 'CLIMS{i}.value must be a vector of length 1 for CLIMS{i}.type="%s"',CLIM_TYPE_BRIGHTNESS);
        case CLIM_TYPE_PERCENTILE
            assert(length(CLIMS{iMovie}.value)==2, 'CLIMS{i}.value must be a vector of length 2 for CLIMS{i}.type="%s"',CLIM_TYPE_PERCENTILE);
        otherwise
            error('config.clims{i}.type must match one of the valid types: %s or %s', CLIM_TYPE_PERCENTILE, CLIM_TYPE_BRIGHTNESS);
    end
end
assert(ndims(DATA)==4,'CreateMovie: data must be a 4D array, where last dim is time');
validCompressionTypes = {'Motion JPEG AVI','MPEG-4','Uncompressed AVI'};
assert(ismember(COMPRESSION_TYPE, validCompressionTypes),'please use valid compression types only. See VideoWriter for help');
assert( ~strcmp(COMPRESSION_TYPE, 'MPEG-4') || ispc ,... % either compression is pc - then we can have codec MPEG-4 - or we're not on pc, then codec must be different
    'When using MPEG-4 codec, you must run this script from Windows');



% setup mosaic parameters
[dimX,dimY,nSlice,nVolumes] = size(DATA);
mosaicFormat   = ceil(sqrt(nSlice)); % nr of slices in each direction
mosaicX        = mosaicFormat * dimX;
mosaicY        = mosaicFormat * dimY; % size in pixels
mosaic         = zeros(mosaicX, mosaicY, nVolumes); % where the data fill be rearranged
textX          = round(mosaicX - dimX/4); % where the image-index will be printed; e.g. lower right corner
textY          = round(mosaicY - dimY/2);

% fill up mosaic matrix with data
for vol = 1:nVolumes
    for slice = 1:nSlice
        minX = mod(slice - 1, mosaicFormat) * dimX + 1;
        maxX = minX + dimX - 1;
        minY = (ceil(slice/mosaicFormat)-1) * dimY + 1;
        maxY = minY + dimY - 1;
        
        dataSlice = reshape(DATA(:,:,slice,vol), dimX, dimY);
        dataSlice = rot90(dataSlice);
        
        mosaic(minY:maxY, maxX:-1:minX, vol) = dataSlice;
    end
end
clear DATA; % to save memory

% create movies
%-----------------
fprintf('Creating movies...');
nMovies = length(CLIMS);
% prepare clims vectors
mmin = min(mosaic(:));
mmax = max(mosaic(:));
for iMovie=nMovies:-1:1
    switch CLIMS{iMovie}.type
        case CLIM_TYPE_PERCENTILE
            lowerLimit = CLIMS{iMovie}.value(1);
            upperLimit = CLIMS{iMovie}.value(2);
            thresholdLow = prctile(mosaic(:),lowerLimit*100);
            thresholdHigh = prctile(mosaic(:), upperLimit*100);
            clims{iMovie} = [thresholdLow thresholdHigh];
        case CLIM_TYPE_BRIGHTNESS
            brightness = CLIMS{iMovie}.value;
            clims{iMovie} = [mmin, mmin + (mmax-mmin)/brightness];
        otherwise
            error('unknown CLIMS{i}.type');
    end
end
% start plotting, one volume at a time, but create all movies at the same
% time
f=figure('NumberTitle','off');
for k = size(mosaic,3):-1:1
     imagesc(mosaic(:,:,k));
    colormap(gray);
    axis tight
    set(gca,'nextplot','replacechildren');
    hold on;
    text(textX,textY,num2str(k),'Color','r','FontSize',24,'HorizontalAlignment','right');
    hold off;
    % create different movies, depending on length of config.clims
    for iMovie=nMovies:-1:1
        % set correct 'clims'
        caxis(clims{iMovie});
        % save frame to vector
        allMovies{iMovie}.movie(k) = getframe;
    end
end
close(f)
fprintf(' done\n');

% save all movies to disk

oldFolder=pwd;
cd(FOLDER_OUTPUT);
for iMovie=1:nMovies
    fprintf('Saving movie %i - %s...',iMovie, CLIMS{iMovie}.type);
    compression = COMPRESSION_TYPE;
    writerObject = VideoWriter(MOVIE_FILENAMES{iMovie},compression);
    writerObject.FrameRate = FPS;
    open(writerObject);
    writeVideo(writerObject,allMovies{iMovie}.movie);
    close(writerObject);
    fprintf(' done\n');
end
cd(oldFolder);

end
