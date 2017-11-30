%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Corrects the orientation of an image to be horizontal.
% Inputs: 
%   - I: the image to be corrected.
%   - sizeI: the final size percerntage for the output image (goes form 
%             the range of 0 to 1).
% Outputs: 
%   - I: image corrected.
%% -------------------------------------------------------------------

function I = correct_orientation(I, sizeI)
    % First the size of the image is obtained.
    s = size(I);
    % Checks if the image is horizontal or vertical by comparing the two
    % sizes of the image (if the size(1) > size(2) then the orientation 
    % of the image is actually vertically instead of horizontally and we
    % have to rotate it 90 degrees).
    if(s(1) > s(2))
        I = imrotate(I, 90); 
    end
    
    % Now that the image is horizontally, it's time to check if the
    % orientation is correct or if it's upside down. To do this, we divide
    % the image into two equal parts (left and right).
    I_left = rgb2gray(I(:,1:(end/2),:));
    I_right = rgb2gray(I(:,(end/2):end,:));
    % and obtain the are of each part.
    left_area = bwarea(im2bw(I_left, graythresh(I_left)));
    right_area = bwarea(im2bw(I_right, graythresh(I_right)));
    % Checks the area of the two parts (if the right part of the image has
    % more area, then the image is upsidedown and we have to rotated 180
    % degrees. Remember that most of the objects in the correct orientation
    % image should be located in the left part of the image).
    if right_area > left_area
        I = imrotate(I,-180);
    end
    
    % Finally if the image needs to re resize, this step is done.
    I = imresize(I, sizeI);
end
