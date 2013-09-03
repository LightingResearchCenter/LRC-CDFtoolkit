function MillerPlotCDF(filename, Title, plotPosition)
%MILLERPLOT Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.

data = ProcessCDF(filename);

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

% Begin plotting
figure1 = gcf;

% Create axes
axes1 = axes('Parent',figure1,'XTick',0:2:24,...
    'TickDir','out',...
    'OuterPosition',plotPosition,...
    'ActivePositionProperty','outerposition');
xlim(axes1,[0 24]);
% Ymax = max([max(mAI),max(mCS)]);
% Ymax = ceil(Ymax/0.5)*0.5;
Ymax = 1;
ylim(axes1,[0 Ymax]);
box(axes1,'off');
hold(axes1,'all');

% Create custom grid
YgridPos = 0.25:0.25:(Ymax-.25);
XgridPos = 2:2:22;
GridColor = [0.8 0.8 0.8];
% Y grid lines
for i1 = 1:length(YgridPos)
    line([0 24],[YgridPos(i1),YgridPos(i1)],'Color',GridColor,'LineStyle',':');
end
% X grid lines
for i1 = 1:length(XgridPos)
    line([XgridPos(i1),XgridPos(i1)],[0 Ymax],'Color',GridColor,'LineStyle',':');
end

% Plot AI
area1 = area(axes1,hour,mAI,'LineStyle','none');
set(area1,...
    'FaceColor',[0.2 0.2 0.2],'EdgeColor','none',...
    'DisplayName','AI');

% Plot CS
plot1 = plot(axes1,hour,mCS);
set(plot1,...
    'Color',[0.6 0.6 0.6],'LineWidth',2,...
    'DisplayName','CS');

% Create legend
legend1 = legend([area1, plot1],'Location','EastOutside');
set(legend1,'Orientation','vertical');

% Create x-axis label
xlabel('hour');

% Create title
dateRange = [time(1), time(end)];
dateRangeStr = datestr(dateRange,'mm/dd/yyyy');
text2 = [dateRangeStr(1,:),' - ',dateRangeStr(2,:)];
days = dateRange(2)-dateRange(1)+1;
text3 = [num2str(days,'%.0f'),' days'];
title([Title,'   ',text2,'   ',text3]);

% Close box around plot
line([0 24],[Ymax Ymax],'Color','k');
line([24 24],[0 Ymax],'Color','k');

end

