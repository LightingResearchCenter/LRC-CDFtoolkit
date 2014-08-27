function txt2cdf(file,varargin)
% TXT2CDF Will take a text file and create a CDF file from it.
% This will be using a new method of checking the inputs as a testing for
% future programs written. it will use the PARSE function.
% Current inputs:
%   file: the full path to the file that you wish to convert.
%   
%   Name,Value pairs:
%
%   'outputPath': default - this will put the files in to the same
%                           directory that it got the file from.
%                           Functionality is not set up for this yet.
%                 DirName - the directory where the file should be saved to
%   'timeOffset': default - this will cause the program to ask each time it
%                           needs to insert a timeOffset value.
%                 Int Value - This will be the offset value inserted in to
%                             the cdf file. The format should be similar to
%                             how we write our time zones offset from UTC.
%                             the program will convert this to seconds.
%  'Delimiter': default - This will make the program think that the file in
%                         file in question is seperate by tabs.
%               String - This will be the delimiter used to read the file.
%                        For more information look at READTABLE's delimiter
%                        Name:Value pair.
%  'HeaderLines': default - this will cause the program to read the first
%                           line of the file as the variable names.
%                 lineNumber - this is the line number where it can find
%                              the variable names for reading the table. 
%% Input Checking
p = inputParser;
p.FunctionName = 'txt2cdf';
p.addRequired('file',(@(x) exist(x,'file')==2));
addParameter(p,'outputPath','default');
addParameter(p,'timeOffset','default');
addParameter(p,'delimiter','\t');
addParameter(p,'headerlines',0);
parse(p,file,varargin{:});
input = p.Results; %stores all the inputs, and any needed defaults
%% turn off warnings that are always generated. 
id = 'MATLAB:table:ModifiedVarnames';
warning('off',id);
%% generate the output
[out,path] = convert(input);
%% Attempt CDF write
txt2cdf.WriteCDF(out,path);
end %end of txt2cdf function

function [output,newFilePath]= convert(input)
% This will add the known values to a CDF structure from the file that was
% passed to it.
%% Create variables
[path,name] = fileparts(input.file);
data = readtable(input.file,'Delimiter',input.delimiter,...
                 'HeaderLines',input.headerlines); %gathers info from file
output = txt2cdf.createCDFstruct();
output = getserialnumber(input.file,output);
%% Format variables
data.Properties.Description = input.file;% adds file name to the table
[data, output, has] = checkVariables(data, output);
[output,data,has] = calcluxclacs(data, output, input.file, has);
if strcmpi(input.outputPath, 'default')
   newFilePath = [path '\' name '_' getenv('USERNAME') '.cdf'];
else
   newFilePath = fullfile(input.outputPath, [name '_' getenv('USERNAME') '.cdf']);
end %end of if strcmpi statement
%% input Variables in to structure
output.GlobalAttributes.deviceModel = {'Needs to be entered'};
output.Variables.time=data.Time;
output.Variables.logicalArray = true(size(data.Time));
if has.Lux
   output.Variables.illuminance=data.Lux;
else
   output.Variables.illuminance = zeros(size(data.Time));
end% end of if has.Lux statement
if has.CLA
   output.Variables.CLA=data.CLA;
else
   output.Variables.CLA=zeros(size(data.Time));
end% end of if has.CLA statement
if has.CS
   output.Variables.CS=data.CS;
else
   output.Variables.CS=zeros(size(data.Time));
end% end of if has.CS statement
output.Variables.activity=data.Activity;
if strcmpi(input.timeOffset,'default')
   output.Variables.timeOffset = str2num(timezone)*60*60;
else
   output.Variables.timeOffset = str2num(input.timeOffset)*60*60;
end%end of if strcmpi function
end%end of convert function

function [data, output, has] = checkVariables(data,output)
% This will look at the variable names that are in table and makes sure 
% that they are in the format that is used in the rest of the program. Also
% builds 'has' a struct which says which variables are available.
%% Pull needed info from table
prop = data.Properties.VariableNames;
[has.RGB,has.Lux,has.CLA,has.CS]= deal(false);
%% Check format of Variable names
% this loop will rename the variable names of the table in to the ones that
% are uesd in the rest of the program. 
for i = 1:length(prop)
   if ~isempty(strfind(prop{1,i},'time'))||~isempty(strfind(prop{1,i},'Time'))
      prop{1,i} = 'Time';
   elseif strcmpi(prop(1,i),'red')||strcmpi(prop(1,i),'r')
      prop{1,i} = 'Red';
      has.RGB = true;
   elseif strcmpi(prop(1,i),'green')||strcmpi(prop(1,i),'g')
      prop{1,i} = 'Green';
      has.RGB = true;
   elseif strcmpi(prop(1,i),'blue')||strcmpi(prop(1,i),'b')
      prop{1,i} = 'Blue';
      has.RGB = true;
   elseif strcmpi(prop(1,i),'lux')
      prop{1,i} = 'Lux';
      has.Lux = true;
   elseif strcmpi(prop(1,i),'cla')
      prop{1,i} = 'CLA';
      has.CLA = true;
   elseif strcmpi(prop(1,i),'cs')
      prop{1,i} = 'CS';
      has.CS = true;
   elseif strcmpi(prop(1,i),'activity')
      prop{1,i} = 'Activity';
   end% end of if strcmpi statement
end %end of for length(prop) loop
%% replace new variable names
data.Properties.VariableNames = prop;
data = timeconvert(data);
end % end of checkVariables function

function [output, data, has] = calcluxclacs(data,output,file, has)
% This function will generate as much missing information as it can. If
% it has RGB then it can generate any missing information, if it does not
% then Lux will not be able to be calcualted if missing. CLA requieres
% either RGB or CS to be present, while CS can only be calcualted from CLA.
% To this end if CS is unable to be calcualted then this program will error
% out.
%% Pull in nessacary variables
[~, ~, ~, ~, Vlamda, ~] = Day12Constants; % Lux requires vlamda
%% put RGB information in to output
if has.RGB == false
   %a place holder value is put in to the output structure
   nTime = numel(data.Time);
   for i = 1:nTime
      output.Variables.red(i) = -1;    %this will make sure that writing to 
      output.Variables.green(i) = -1;  % the CDF file will not error. 
      output.Variables.blue(i) = -1;
   end
   output.VariableAttributes.description(4,2) = {'Could not be calculated'};
   output.VariableAttributes.description(5,2) = {'Could not be calculated'};
   output.VariableAttributes.description(6,2) = {'Could not be calculated'};
else
   %writes RGB to the output structure
   output.Variables.red = data.Red;
   output.Variables.green = data.Green;
   output.Variables.blue = data.Blue;
   output.VariableAttributes.description(4,2) = {'Pulled from Original file'};
   output.VariableAttributes.description(5,2) = {'Pulled from Original file'};
   output.VariableAttributes.description(6,2) = {'Pulled from Original file'};
end %end of if has.RGB statment
%% Calculate Lux and put in to output.
if has.Lux == false
   if has.RGB == true
      redCal = output.GlobalAttributes.redCalibration{1};
      greenCal = output.GlobalAttributes.greenCalibration{1};
      blueCal = output.GlobalAttributes.blueCalibration{1};
      calibratedRed = data.Red * redCal;
      calibratedGreen = data.Green * greenCal;
      calibratedBlue = data.Blue * blueCal;
      data.Lux = calibratedRed * Vlamda(1) + calibratedGreen * ...
         Vlamda(2) + calibratedBlue * Vlamda(3);
      has.Lux = true;
   else
      output.VariableAttributes.description(7,2) = {'Could not be calculated,RGB missing'};
   end % end of if has.RGB statement
end %end of if has.Lux statement
%% calcualte CLA and put in to output
if has.CLA == false
   if has.CS == true
      data.CLA = txt2cdf.utilityfunctions.cs2cla(data.CS);
      has.CLA = true;
   elseif has.RGB == true
      calibratedRed = data.Red * redCal;
      calibratedGreen = data.Green * greenCal;
      calibratedBlue = data.Blue * blueCal;
      [~, CLA] = (Day12luxCLA(calibratedRed,calibratedGreen,calibratedBlue));
      data.CLA = CLA';
      data.CLA(data.CLA < 0) = 0;
      logInterval = mode(round(diff(data.Time)*24*60*60*30)/30);
      data.CLA = filter5min(data.CLA,logInterval);
      has.CLA = true;
   else % no CS and no RGB
      nTime = numel(data.Time);
      for i = 1:nTime
         %this will make writing to CDF not error due to array indexing
         output.Variables.CLA(i) = -1;
      end% end of for nTime statement
   end%end of if has.[RGB,CS] statement
end %end of if has.CLA statement
%% calcualte CS and put in to output
if has.CS == false
   if has.CLA == true
      data.CS = txt2cdf.utilityfunctions.cla2cs(data.CLA);
      has.CS = true;
   else
      text = ['The file: ' file ' can not produce the CS variable. Both '...
         'RGB and CLA are missing, Please correct and try again.'];
      error(text);
   end%end of if has.CLA
end %end of if has.CLA statement
end %end of checkVariables function

function data = timeconvert(data)
%% make sure data.time is datenum
if ~isnumeric(data.Time(1))
   disp(data.Time(1));%this contains the file name
   prompt = 'what is the date format for this string (use DATENUM standard): ';
   str = input(prompt,'s');
   data.Time = datenum(data.Time,str); 
else
   disp(data.Properties.Description);
   data.Time = txt2cdf.smarttimeconvert(data.Time);
end %end of if isnumeric statement
end %end of timeconvert function

function [output] = getserialnumber(file,output)
% using the file name this will find the device numeber, if the file name
% does not give easy clues to the device serial number this will ask if
% there is a 'log_info.txt' file to find it, and if that is not an option
% it will then ask the user to input the divice number. This is a required
% function, and will not allow the program move forward with out it. 
%% import RGB values
[path,name] = fileparts(file);
idNum = 0;
for i = 1:length(name)
   if isstrprop(name(i),'digit')
      idNum = i;
   else
      break
   end%end of if isstrprop statement
end%end of for length(name) statement
if idNum ~= 0
   if exist([path '\' name(1:idNum) 'log_info.txt'],'file')
      fid = fopen([path '\' name(1:idNum) 'log_info.txt'],'rt');
      fgets(fid);
      SerialNumber = fgets(fid);
      output.GlobalAttributes.deviceSN = {num2str(str2num(SerialNumber)+12000)};
      fclose(fid);
      FileInfo = dir([path '\' name(1:idNum) 'log_info.txt']);
      TimeStamp = FileInfo.date;
      output.GlobalAttributes.creationDate = {TimeStamp};
   else
      prompt = ['Is there a log_info.txt file for ' name ' (Y/N): '];
      str = input(prompt,'s');
      testStatement = true;
      while testStatement
         if isempty(str)
            testStatement = false;
         elseif strcmpi(str,'y')
            logFile = uigetfile('*.txt','Please select the file');
            fid = fopen(logFile,'rt');
            fgets(fid);
            SerialNumber = fgets(fid);
            output.GlobalAttributes.deviceSN = {num2str(str2num(SerialNumber)+12000)};
            fclose(fid);
            FileInfo = dir([path '\' name(1:idNum) 'log_info.txt']);
            TimeStamp = FileInfo.date;
            output.GlobalAttributes.creationDate = {TimeStamp};
            testStatement = false;
         elseif strcmpi(str,'n')
            testStatement = false;
         else
            prompt = 'That was not an option please choose Y or N: ';
            str = input(prompt,'s');
         end%end of if isempty statement
      end%end of while testStatement statement
   end%end of if exist statement
end%end of if idNum~=0 statement
if strcmp(name(1:3),'Day') || strcmp(name(1:3),'day')
   text = strsplit(name,'_');
   SN = text{1};
   if isstrprop(SN(4),'digit')
      SerialNumber = SN(4:end);
      output.GlobalAttributes.deviceSN = {num2str(str2num(SerialNumber)+12000)};
      output.GlobalAttributes.creationDate = {datenum([text{2} '_' text{3}],'mmddyy_HHMM')};
   end%end of if isstrprop statement
end%end of if strcmp statement
if ~exist('SerialNumber','var')
   disp('Can not find the Device Serial Number for ');
   disp(file);
   prompt = 'Please enter a max of three(3) digit Serial number for the file: ';
   SerialNumber = input(prompt,'s');
   output.GlobalAttributes.deviceSN = {num2str(str2num(SerialNumber)+12000)};
   FileInfo = dir(file);
   TimeStamp = FileInfo.date;
   output.GlobalAttributes.creationDate = {datenum(TimeStamp),'generated from files modified date'};
end%end of if exist statement
SerialNumber = str2num(SerialNumber);
RGBpath = '\\root\projects\DaysimeterAndDimesimeterReferenceFiles\data\Day12 RGB Values.txt';
RGBval = readtable(RGBpath, 'Delimiter','\t');
output.GlobalAttributes.redCalibration = {RGBval.R((SerialNumber))};
output.GlobalAttributes.greenCalibration = {RGBval.G((SerialNumber))};
output.GlobalAttributes.blueCalibration= {RGBval.B((SerialNumber))};
end%end of getserialnumber function
