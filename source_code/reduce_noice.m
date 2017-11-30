%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Reduces the noise in an image with a specific method:
%   - averaging: returns an averaging filter.
%   - gaussian: returns a rotationally symmetric Gaussian lowpass filter.
%   - median: returns a median filtering.
%   - sharpening: returns an enhanced version of the image.
% Inputs: 
%   - type: the type of noise reduction to perform (averaging, gaussian, 
%           median or sharpening).
%   - I: the image to correct.
%   - size: the size of the reduction of noise.
% Outputs: 
%   - I_reduced: image corrected.
% Ref: goo.gl/Y5Aes6
%% -------------------------------------------------------------------

function I_reduced = reduce_noice(type, I, size)
    switch type
        
        % Averaging method would be used.
        case 'averaging'
            I_reduced = imfilter(I,fspecial('average', size));
            
        % Gaussian method would be used.
        case 'gaussian'
            I_reduced = imfilter(I,fspecial('gaussian', size, 2));
            
        % Median method would be used.
        case 'median'
            % Applies the median methon on each channel (RGB).
            img_r_med = medfilt2(I(:,:,1),[size  size]);
            img_g_med = medfilt2(I(:,:,2),[size  size]);
            img_b_med = medfilt2(I(:,:,3),[size  size]);
            % Merge the image again.
            I_reduced = cat(3, img_r_med, img_g_med, img_b_med);
            
        % Sharpening method would be used.
        case 'sharpening'
            I_reduced = imsharpen(I);
        
        % Returns an error if the type input does not exists.
        otherwise
            error('wrong type of reduce noice')
    end
end