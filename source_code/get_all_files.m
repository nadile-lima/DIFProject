%% -------------------------------------------------------------------
% University Jean Monnet
% Digital Image Fundamentals
% Project:  Melon Identification
% Partners: Evelyn Paiz & Nadile Nunes
% Instructors: Hubert Konik & Carlos Arango
% Description: Gets all files under a specific directory.
% Inputs: 
%   - inputPath: the input path for the data to be loaded.
%   - fileExtension: type of file to search into the directory.
% Outputs: 
%   - fileList: list of the files that are contained in the directory.
% Ref: http://stackoverflow.com/questions/2652630/how-to-get-all-files-under-a-specific-directory-in-matlab
%% -------------------------------------------------------------------

function fileList = get_all_files(dirName, fileExtension)
    % Get the data for the current directory
    dirData = dir([dirName '/' fileExtension]);
    % Find the index for directories
    dirIndex = [dirData.isdir]; 
    % Get a list of the files
    fileList = {dirData(~dirIndex).name}';
    if ~isempty(fileList)
        % Prepare the path to files
        fileList = cellfun(@(x) fullfile(dirName,x),...  
                   fileList,'UniformOutput',false);
    end
    % Get a list of the subdirectories
    subDirs = {dirData(dirIndex).name};  
    % Find index of subdirectories that are not '.' or '..'
    validIndex = ~ismember(subDirs,{'.','..'});  
    % Loop over valid subdirectories
    for iDir = find(validIndex)       
        % Get the subdirectory path
        nextDir = fullfile(dirName,subDirs{iDir});    
        % Recursively call get_all_files to get the files into the 
        % subdirectories.
        fileList = [fileList; getAllFiles(nextDir,fileExtension)];
    end
end