%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Main program that analyze and classify a group of images
% with melons in it, from Vilmorin company.
%% -------------------------------------------------------------------

% Start with closing and clearing everything first.
close all; clc; clear all; warning off; 

% Defining the directory with the input images.
inputPath = './input_img/'; 
% Defining the directory for the segmentated images.
segmentedMelonPath = './segmented_img/';
% Defining the directory for the cropped images.
textureMelonPath = './texture_img/';

%% ------------------------------------------------------------------- 
%  Loading: Loads the data and starts the variables.
%  -------------------------------------------------------------------

% The first step is to load the input images.
[dataList allNames] = load_data(inputPath);

% The size of the images would be reduce from the original to increase
% performance.
sizeImages = 1/4; 

% It's define some references images.
refI = imread('coin.jpg');

%% ------------------------------------------------------------------- 
%  Preprocessing: identify and defy orientation.
%  -------------------------------------------------------------------

% For each image to analyze, first the orientation of all images is 
% defined as horizontal and with a resize of the image of (sizeImages =
% 1/4).
for i=1:numel(dataList)
   dataList{i} = correct_orientation(dataList{i}, sizeImages);
end

%% ------------------------------------------------------------------- 
%  Pre-processing: histogram transformation or reduction of noise.
%  -------------------------------------------------------------------

% For each image, an histogram transformation and a noise reduction
% is performed to improve the segmentation or the feature extraction steps
% that will follow.
for i=1:numel(dataList)
    % Histogram transformation with adapthisteq
    dataList{i} = hist_transf('imadjust', dataList{i});  
    % Noise reduction with gaussian filter
    dataList{i} = reduce_noice('gaussian',dataList{i},5); 
end

%% ------------------------------------------------------------------- 
%  Segmentation: segment the melon area from the background and take away
%  the stem.
%  -------------------------------------------------------------------

% For each image, a segmentation of 1 or more melons is performed. 
for i=1:numel(dataList)
    % Segment using the corresponding thresholds:
    % - Hue: [0.07 - 0.21] the hue value is the defining parameter to
    %        achieve the color that we are looking for.
    % - Saturation: [0.15 - 1] saturation begins at 0.15.
    % - Value: [0 - 1] does not affects the color of the melons we are
    %          searching.
    [melonMask{i}, area] = segment(dataList{i}, 0.07, 0.21, 0.15, 1, 0.2, 1);
    % Define thresholds for channel 1 based on histogram settings

    % Get rid of the stem fiding the radius of the melon and doing an
    % opening of the image with a disk with the reduced radius.
    radius = double(int8(sqrt(area/31)));
    se = strel('disk', radius);
    melonMask{i} = imopen(melonMask{i},se);
    
    % The melon segmentation is saved in the output folder.
    fileName = char(strcat(segmentedMelonPath, allNames(i)));
    segmentedMelon{i} = dataList{i}.*cat(3,melonMask{i},melonMask{i},melonMask{i});
    imwrite(segmentedMelon{i},fileName,'JPG');
end

%% ------------------------------------------------------------------- 
%  Segmentation: segment the 1 cent coin.
%  -------------------------------------------------------------------

% For each image, a segmentation of the coin (if it exists) is performed.
for i=1:numel(dataList)
    % Segment using the corresponding thresholds:
    % - Hue: [0.046 - 0.091] the hue value limits centered
    % - Saturation: [0.2 - 0.60] saturation limits centered
    % - Value: [0.375 - 0.691] the value limits centered
    coinMask{i} = segment(dataList{i}, 0.046, 0.091, 0.2, 0.600, 0.375, 0.691);
    %figure,
    %subplot(1,2,1), imshow(dataList{i}.*cat(3,coinMask{i},coinMask{i},coinMask{i}));
    %subplot(1,2,2), imshow(dataList{i});
end

%% ------------------------------------------------------------------- 
%  Labeling: detect whether the melon is spherical or circular.
%  -------------------------------------------------------------------

% Prepares the document to write the results
fid=fopen([segmentedMelonPath 'shape_results.txt'],'w');
% For each image, the next step is to do define the shape of the melon and
% crop the maximum region of interest that it's possible to obtain. 
for i=1:numel(melonMask) 
    % Print the name of the image we are working with 
    fprintf(fid, 'Image %s \n', char(allNames(i)));
    % Creates a predeterminated reference (this reference will be used if
    % the coin does not exist in the image).
    coin = imresize(rgb2gray(refI), sizeImages);
    coinBW = imfill(im2bw(coin, graythresh(coin)), 'holes');
    % Determines wheter or not the mask of the coin exists.
    noCoin = min(all(~coinMask{i}));
    % If the reference doesnt exists, uses the image of the coin already
    % predeterminated (coin diameter: 16.25 mm = 1.625cm).
    if(noCoin)
        [circle, majorAxis, minorAxis, centroid] = ...
            def_shape(melonMask{i}, coinBW, 1.625, fid);
    % If does exists, uses the corresponding mask.
    else
        [circle, majorAxis, minorAxis, centroid] = ...
            def_shape(melonMask{i}, coinMask{i}, 1.625, fid);
    end
    
    % the region of interest is croped, finding the greatest rectangle that
    % you can fit inside the segmented melon.
    melonRI{i} = crop_image(segmentedMelon{i}, circle, majorAxis,...
        minorAxis, centroid);
end
% Close the document
fclose(fid);
    
%% ------------------------------------------------------------------- 
%  Feature extraction: texture analysis.
%  -------------------------------------------------------------------

% The NHOOD is chosen to be a matrix of size 9 filled with 1.
nhood = true(9);
% For each image to analyze, first a texture analysis is performed.
for i=1:numel(melonRI)
    RI = melonRI{i};
    clear sub_melonJ
    % Does the texture analysis for each object (melon) that is in the
    % image (the three methods are entropyfitlt, stdfilt, rangefilt).
    for j=1:numel(RI)
        sub_melonJ{j} = texture_analysis('entropyfilt', RI{j}, nhood);
    end
    melonJ{i} = sub_melonJ;
end

%% ------------------------------------------------------------------- 
%  Netting segmentation: method for segmenting the netting on the melons.
%  -------------------------------------------------------------------

% For each image to analyze, then a netting segmentation is performed 
% which returns the outline of the nettings on each image.
for i=1:numel(melonRI)
    RI = melonRI{i};
    J = melonJ{i};
    clear sub_texture
    % Does the texture segmentation for each object (melon) that is in the
    % image (the three methods are entropyfitlt, stdfilt, rangefilt).
    for j=1:numel(RI)
        sub_texture{j} = texture_segmentation(RI{j}, J{j});
        % If there is more than one object, it will save all the correspond
        % objects.
        if(numel(RI)>1)
            name = strsplit(allNames{i}, '.');
            name = cell(strcat(name(1),'_',num2str(j),'.',name(2)));
        else
            name = allNames(i);
        end
        fileName = char(strcat(textureMelonPath, name));
        imwrite(sub_texture{j},fileName,'JPG');
    end
    % The outline of the netting
    textureSegmentedMelon{i} = sub_texture;
end