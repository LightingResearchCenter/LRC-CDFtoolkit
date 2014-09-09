 function data = filter5min(data,epoch)
%FILTER5MIN Lowpass filter data series with zero phase delay,
%   moving average window.
%   epoch = sampling epoch in seconds
minutes = 5; % length of filter (minutes)
Srate = 1/epoch; % sampling rate in hertz
windowSize = floor(minutes*60*Srate);
b = ones(1,windowSize)/windowSize;

if epoch <= 150
    data = filtfilt(b,1,data);
end

end