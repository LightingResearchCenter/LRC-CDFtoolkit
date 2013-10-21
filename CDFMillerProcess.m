function [mCS, mAI, hour, time] = CDFMillerProcess(data)

time = data.Variables.time;
AI = data.Variables.activity;
CS = data.Variables.CS;
logicalArray = data.Variables.logicalArray;

%   time is in MATLAB date time series format
%   AI is activity index from a Daysimeter or Dimesimeter
%   CS is Circadian Stimulus from a Daysimeter or Dimesimeter
%   logicalArray is an array of 0s and 1s denoting the actual window of
%   data collection
%   data will be trimed inclusively to the date range (logicalArray)
%   Title can be a string or cell array of strings
%   plotPosition is in the form [x y width height] relative to the bottom
%   left corner of the outer position of the plot in percent of the figure
%   dimensions



% Trim data to date range specified
idx = logicalArray == 1; % indices of data to keep
time = time(idx);
AI = AI(idx);
CS = CS(idx);

% Reshape data into columns of full days
% ASSUMES CONSTANT SAMPLING RATE
TI = time - floor(time(1));
dayIdx = find(TI >= 1,1,'first') - 1;
extra = rem(length(TI),dayIdx)-1;
CS(end-extra:end) = [];
AI(end-extra:end) = [];
CS = reshape(CS,dayIdx,[]);
AI = reshape(AI,dayIdx,[]);

% Average data across days
mCS = mean(CS,2);
mAI = mean(AI,2);

% Trim time index
TI = TI(1:dayIdx);
% Convert time index into hours from start
hour = TI*24;

end