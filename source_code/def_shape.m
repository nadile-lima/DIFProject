%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Detect whether the melon is spherical or circular 
%              using the coin diameter as reference.
% Inputs: 
%   - I: the image to be analyzed (as a binary).
%   - Ref: the reference image to compare I (as a binary).
%   - size: the size used by the reference.
%   - fid: file id to save the results.
% Outputs:
%   - circle: if the melon(s) is/are a circle or not.
%   - majorAxis: size of the major axis if the melon is an elipse.
%   - minorAxis: size of the minor axis if the melon is an elipse.
%   - centroid: the centroid point.
%% -------------------------------------------------------------------

function [circle, majorAxis, minorAxis, centroid] = def_shape(I, Ref, size, fid)
    % Obtain the correspoding region properties of the reference (because
    % we know that the coin is a circle, only the major axis is necesary
    % to determine the diameter of the coin).
    statsR = regionprops(Ref, 'MajorAxisLength');
    RAxisLength = max(statsR.MajorAxisLength);
    RDiameter = size;
    % Obtains the corresponding region properties of the image to be tested
    % (we obtain the eccentricity to determine if it's a circle or an ellipse,
    % also the diameter with the major and minor axis and the centroid point).
    [L,nbObjects] = bwlabel(I); % also we count the number of objects to inspect
    stats = regionprops(L, 'Eccentricity', 'MajorAxisLength',...
        'MinorAxisLength', 'Centroid');
    circle = zeros(1,nbObjects); 
    majorAxis = zeros(1,nbObjects);
    minorAxis = zeros(1,nbObjects);
    centroid = zeros(1,2,nbObjects);
    % For each object in the image to be analyze, the shape is analyze
    % (this allows to test from 1 to any number of object in the image).
    for object = 1 : nbObjects
        % The centroid point is saved
        centroid(:,:,object) = stats(object).Centroid;
        if(nbObjects ~= 1)
            fprintf(fid,'Melon %d \n', object);
        end
        % The region properties are defined for each object.
        ecc = [stats(object).Eccentricity];
        Major = stats(object).MajorAxisLength.*RDiameter./RAxisLength;
        Minor = stats(object).MinorAxisLength.*RDiameter./RAxisLength;
        % Prints the results
        fprintf(fid, 'Eccentricity: %f \n', stats(object).Eccentricity);
        % Determines if its a circle or a ellipse
        if(ecc <= 0.35) % circle if the ecccentricity is <= 0.35
            circle(1,object) = 1;
            minorAxis(1,object) = stats(object).MinorAxisLength;
            fprintf(fid, 'Circle \n');
            fprintf(fid, 'Diameter: %f pixels and %f cm \n \n',...
                stats(object).MinorAxisLength, Minor);
        else % elipse if the ecccentricity is > 0.35
           fprintf(fid, 'Ellipse \n'); 
           majorAxis(1,object) = stats(object).MajorAxisLength;
           minorAxis(1,object) = stats(object).MinorAxisLength;
           fprintf(fid, 'MajorAxisLength: %f pixels and %f cm \n',...
               stats(object).MajorAxisLength, Major);
           fprintf(fid, 'MinorAxisLength: %f pixels and %f cm \n \n',...
               stats(object).MinorAxisLength, Minor);
        end        
    end
end