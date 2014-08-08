function reprocesscdf(filePath,overwrite,varargin)
%REPROCESSCDF Summary of this function goes here
%   filePath:   is a fully defined path to the origianl CDF to be processed
%   overwrite:  is a logical (true or false). If true it will delete the
%   original file and replace it with the new one. If false it will append
%   '_reprocess' to the file name.
%   varargin:   is an optional input. If overwrite is false varargin can be
%   a different directory to save the reprocessed file to.

% Import original data
OriginalData = ProcessCDF(filePath);

% Copy data to a new struct
EditedData = OriginalData;

% Red, Green, and Blue are already calibrated DO NOT calibrate again.
red   = OriginalData.Variables.red;
green = OriginalData.Variables.green;
blue  = OriginalData.Variables.blue;

% Determine sampling rate in seconds
logInterval = mode(round(diff(OriginalData.Variables.time*24*60*60)));

% Recalculate CLA
[~, CLA] = Day12luxCLA(red, green, blue);
CLA(CLA < 0) = 0;
% filter CLA
CLA = filter5min(CLA,logInterval);
% Recalculate CS
CS = CSCalc(CLA);

% Assign recalculated data to struct for output
EditedData.Variables.CLA = CLA(:);
EditedData.Variables.CS  = CS(:);

if overwrite
    % DANGER deleting the original file so it may be rewritten
    delete(filePath);
else
    % Append the file name if not overwriting
    [fileDir,fileName,fileExt] = fileparts(filePath);
    fileName = [fileName,'_reprocessed'];
    if nargin == 3
        fileDir = varargin{1};
    end
    filePath = fullfile(fileDir,[fileName,fileExt]);
end

RewriteCDF(EditedData, filePath);

end

