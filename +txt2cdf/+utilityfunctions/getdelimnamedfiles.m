function processedFile = getdelimnamedfiles(path,str)
% this is a recursive regexpress file search ment to be used in a bacth
% txt2cdf file conversion function. 
%

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