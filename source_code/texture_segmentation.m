%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Use texture segmentation to identify regions based on their
%              texture.
% Inputs:
%   - I: image to be segmented.
%   - J: gray-level co-occurrence matrix.
% Outputs: 
%   - outlineTexture: final outlined texture image.
% Ref: https://fr.mathworks.com/help/images/examples/texture-segmentation-using-texture-filters.html
%% -------------------------------------------------------------------

function outlineTexture = texture_segmentation(I, J)
    % Extracts the each channel from the J co-ocurrence matrix and converts
    % it into a graylevel image.
    J_1 = mat2gray(J(:,:,1));
    J_2 = mat2gray(J(:,:,2));
    J_3 = mat2gray(J(:,:,3));
    % Thresholds each channel.
    BW1 = im2bw(J_1, graythresh(J_1));
    BW2 = im2bw(J_2, graythresh(J_2));
    BW3 = im2bw(J_3, graythresh(J_3));
    % Creates the mask with the segmentation information.
    mask = logical(BW1.*BW2.*BW3);
    % Outline the boundary between the two textures for each channel.
    boundary = bwperim(mask);
    segmentResults_1 = I(:,:,1);
    segmentResults_2 = I(:,:,2);
    segmentResults_3 = I(:,:,3);
    segmentResults_1(boundary) = 0;
    segmentResults_2(boundary) = 0;
    segmentResults_3(boundary) = 0;
    outlineTexture = cat(3, segmentResults_1, segmentResults_2, segmentResults_3);
end