%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Uses the data acquired during the labeling
%              to crop the segmented melon(s) to future analysis.
%
% Inputs: 
%   - I: image with the segmented melon(s).
%   - circle: array with boolean values indicating if the shape of the
%             melon is circular or not.
%   - majorAxis: array with the value(s) of the major axis of the melon(s).
%                If the melon have a circular shape, the major will be zero
%   - minorAxis: array with the value(s) of the minor axis of the melon(s).
%   - centroid: array with the values of the centroid of the melon(s).
% Outputs:
%   - cropedMelon: one or more images, depending of how many melons are
%                  inside the image.
%
%% -------------------------------------------------------------------

function cropedMelon = crop_image(I, circle, majorAxis, minorAxis, centroid)
    nbObjects = size(circle,2); % number of melons
    for object = 1 : nbObjects
        % the value for the centroid is double. The cast is made to use the
        % values a [x y] coordinate.
        xCent = uint16(centroid(1,1,object)); 
        yCent = uint16(centroid(1,2,object));
        if(circle(1,object))
            % if it's a circle, the area cropped will be a square. So only
            % one value is needed to calculate the size of the square side.
            lRect = (minorAxis(1,object)*sqrt(2))./2;
            lRect = uint16(lRect);
            cropedMelon{object} = imcrop(I, [xCent-(lRect/2) yCent-(lRect/2) lRect lRect]);
        else
            % if it's an ellipse, the cropped area will be a rectangle. So
            % two values are calculate.
            xRect = (minorAxis(1,object)*sqrt(2))./2;
            xRect = uint16(xRect);
            
            yRect = (majorAxis(1,object)*sqrt(2))./2;
            yRect = uint16(yRect);

            cropedMelon{object} = imcrop(I, [xCent-(xRect/2) yCent-(yRect/2) xRect yRect]);
        end
    end
end