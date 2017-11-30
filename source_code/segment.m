%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Segmentation of image based on thresholding for the HSV color
% space.
% Inputs: 
%   - I: the image to be segmented.
%   - hueThresholdLow: the lower limit of the hue threshold.
%   - hueThresholdHigh: the higher limit of the hue threshold.
%   - saturationThresholdLow: the lower limit of the saturation threshold.
%   - saturationThresholdHigh: the higher limit of the saturation threshold.
%   - valueThresholdLow: the lower limit of the value threshold.
%   - valueThresholdHigh: the higher limit of the value threshold.
% Outputs: 
%   - mask: final segmented image (binary).
%   - smallestAcceptableArea: the area of the biggest object that exist in
%                             the final mask.
% Ref: http://fr.mathworks.com/matlabcentral/fileexchange/28512-simplecolordetectionbyhue--
%% -------------------------------------------------------------------

function [mask, smallestAcceptableArea] = segment(I, hueThresholdLow, hueThresholdHigh, ....
                        saturationThresholdLow, saturationThresholdHigh, ....
                        valueThresholdLow, valueThresholdHigh)
    % Convert RGB image to HSV
	hsvImage = rgb2hsv(I);
    % Extract out the HSV value of the image
    hImage = hsvImage(:,:,1);
	sImage = hsvImage(:,:,2);
    vImage = hsvImage(:,:,3);
    % Now apply each color band's particular thresholds to the color band
	mask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh) & ...
           (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh) & ....
           (vImage >= valueThresholdLow) & (sImage <= valueThresholdHigh);
    % Smooth the border using a morphological closing operation, imclose().
	structuringElement = strel('disk', 4);
	mask = imclose(mask, structuringElement);
    % Fill in any holes in the regions, since they are most likely red also.
	mask = imfill(logical(mask), 'holes');
    % Leave only the largest object.
    s = regionprops(mask,'Area');
    s = cat(1, s.Area); % convert it to a matrix
    s = sort(s);
    if(~isempty(s))
        % keep areas only the big areas.
        smallestAcceptableArea = s(end); 
        for j=1:(numel(s)-1)
            if(((smallestAcceptableArea-s(end-j))/smallestAcceptableArea) < 0.4)
                smallestAcceptableArea = s(end-j);
            else
                break;
            end
        end
        % Get rid of small objects.
        mask = uint8(bwareaopen(mask, smallestAcceptableArea));
    end
    % You can only multiply integers if they are of the same type.
	mask = cast(mask, class(I));
end