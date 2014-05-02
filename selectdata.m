function logicalArray = selectdata(fileName,time,CS,activity)
%SELECTDATA Summary of this function goes here
%   Detailed explanation goes here

% Plot the data
plot(time(:),[CS(:),activity(:)]);
hTitle = title(fileName);
set(hTitle,'FontSize',16);
datetick2('keepticks','keeplimits');
legend('CS','activity');

% Get user input
display('Select start time.');
[startTime,~] = ginput(1);
display('Select end time.');
[endTime,~] = ginput(1);

logicalArray = (time >= startTime) & (time <= endTime);

logicalArray = double(logicalArray);

clf;

end

