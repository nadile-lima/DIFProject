%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Histrogram transformation in an image with a specific method:
%   - imadjust: adjust image intensity values or colormap.
%   - histeq: enhance contrast using histogram equalization.
%   - adapthisteq: enhances the contrast of images by transforming the
%                  values in the intensity image I.
% Inputs: 
%   - type: the type of histogram transformation to perform (imadjust, 
%           histeq or adapthisteq).
%   - I: the image to correct.
% Outputs: 
%   - I_transformed: image corrected.
% Ref: goo.gl/Y5Aes6
%% -------------------------------------------------------------------

function I_transformed = hist_transf(type, img)
    switch type
        
        % Imadjust method would be used.
        case 'imadjust'
            % Applies the imadjust methon on each channel (RGB).
            img_r_imadjust = imadjust(img(:,:,1));
            img_g_imadjust = imadjust(img(:,:,2));
            img_b_imadjust = imadjust(img(:,:,3));
            % merges the image again.
            I_transformed = cat(3, img_r_imadjust, img_g_imadjust, img_b_imadjust);
            
        % Histeq method would be used.
        case 'histeq'
            % Applies the histeq methon on each channel (RGB).
            img_r_histeq = histeq(img(:,:,1));
            img_g_histeq = histeq(img(:,:,2));
            img_b_histeq = histeq(img(:,:,3));
            % merges the image again.
            I_transformed = cat(3, img_r_histeq, img_g_histeq, img_b_histeq);
            
        % Adapthisteq method would be used.
        case 'adapthisteq'
            % Applies the adapthisteq methon on each channel (RGB).
            img_r_adapthisteq = adapthisteq(img(:,:,1));
            img_g_adapthisteq = adapthisteq(img(:,:,2));
            img_b_adapthisteq = adapthisteq(img(:,:,3));
            % merges the image again.
            I_transformed = cat(3, img_r_adapthisteq, img_g_adapthisteq, img_b_adapthisteq);
       
        % Returns an error if the type input does not exists.
        otherwise
            error('wrong type of histogram transformation')
    end
end