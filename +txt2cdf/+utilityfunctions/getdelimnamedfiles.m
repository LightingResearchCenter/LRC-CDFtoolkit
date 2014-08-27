function processedFile = getdelimnamedfiles(str)
path = uigetdir(pwd,'Select Data Directory');
if path == 0
    ME = MException('getprocessedfiles:NoDirectorySelected', ...
        'No directory was selected.');
    throw(ME)
else
    files = dir(path);
    dirIndex = [files.isdir];  %# Find the index for directories
    fileList = {files(~dirIndex).name}';
    index = 1;
    for i = 1:length(fileList)
        expression = ['.*' str '.*'];
        matchStr = regexpi(fileList(i),expression,'match');
        processedFiles(index) = matchStr;
        index = index + 1;
    end
    for i = 1:length(processedFiles)
        processedFile{i} = fullfile(path,processedFiles{i});
    end
    processedFile = processedFile(~cellfun('isempty',processedFile))';
end
end