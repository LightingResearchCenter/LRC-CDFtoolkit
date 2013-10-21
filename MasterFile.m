function MasterFile(filename)

%Generate title string, assumes that CDF name is formatted
%IDID-YYYY-MM-DD-HH-MM-SS.cdf

temp = size(filename);
titleLen = temp(2);
titleStart = titleLen - 27;
titleEnd = titleLen - 4;
title = filename(titleStart:titleEnd);

%Make data struct
data = ProcessCDF(filename);


CDFMillerPlot(data, title, [0,0,1,1]);
CDFPhasorReport(data, title);

end