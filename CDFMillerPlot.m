function CDFMillerPlot(data, Title, plotPosition)
%MILLERPLOT Creates overlapping area plots of activity index and circadian
%stimulus for a 24 hour period.

[mCS, mAI, hour, time] = CDFMillerProcess(data);

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

