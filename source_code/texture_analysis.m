%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: characterization of regions in an image by their texture
%              content, with a specific method:
%   - entropyfilt: calculates the local entropy of a grayscale image.
%                  Entropy is a statistical measure of randomness.
%   - stdfilt: calculates the local standard deviation of an image.
%   - rangefilt: calculates the local range of an image.
% Inputs: 
%   - type: the type of texture analysis to perform (rangefilt, stdfilt, 
%           or entropyfilt).
%   - I: the image to analyze.
%   - nhood: is a multidimensional array of zeros and ones where the
%            nonzero elements specify the neighborhood for the range
%            filtering operation.
% Outputs: 
%   - J: gray-level co-occurrence matrix.
% Ref: https://fr.mathworks.com/help/images/texture-analysis.html
%% -------------------------------------------------------------------

function J = texture_analysis(type, I, nhood)
    switch type
        
        % Entropyfilt method would be used.
        case 'entropyfilt'
            % Merge the image again.
            J = entropyfilt(I, nhood);
            
            % Stdfilt method would be used.
        case 'stdfilt'
            J = stdfilt(I, nhood);
            
        % Rangefilt method would be used.
        case 'rangefilt'
            J = rangefilt(I,nhood);
            
        % Returns an error if the type input does not exists.
        otherwise
            error('wrong type of texture analysis')
    end

end