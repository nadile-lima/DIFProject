%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Loads the data from an input directory into a vector.
% Inputs: 
%   - inputPath: the input path for the data to be loaded.
% Outputs: 
%   - dataList: a vector with the data read from the directory.
% Ref: goo.gl/Y5Aes6
%% -------------------------------------------------------------------

function [dataList, names] = load_data(inputPath)
    % Gets all the files from the directory that are of type .JPG.
    dataList = get_all_files(inputPath,'*.JPG'); 
    % For each data, creates an image.
    for i=1:numel(dataList)
        % Grabs the file
        file = dataList{i};
        [~,name,ext] = fileparts(file);
        % Reads and saves the image
        dataList{i} = imread(file);
        names{i} = [name ext];
    end
end