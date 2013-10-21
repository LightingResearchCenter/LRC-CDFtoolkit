function [TI, CS, activity, days, IS, IV, phasorMagnitude, phasorAngle, f24, MagH] = CDFPhasorProcess(data)

time = data.Variables.time;
activity = data.Variables.activity;
CS = data.Variables.CS;
logicalArray = data.Variables.logicalArray;

%% Process and analyze data
% Trim data to length of experiment
TI = time - time(1); % time index in days from start
days = floor(max(TI));
delta = logicalArray == 1;
time = time(delta);
TI = TI(delta);
activity = activity(delta);
CS = CS(delta);

Srate = 1/((time(2)-time(1))*(24*3600)); % sample rate in Hertz
% Calculate inter daily stability and variablity
[IS,IV] = IS_IVcalc(activity,1/Srate);

% Apply gaussian filter to data
CS = gaussian(double(CS), 4);
activity = gaussian(activity, 4);
% Calculate phasors
[phasorMagnitude, phasorAngle] = cos24(CS, activity, time);
[f24H,f24] = phasor24Harmonics(CS,activity,Srate); % f24H returns all the harmonics of the 24-hour rhythm (as complex numbers)
MagH = sqrt(sum((abs(f24H).^2))); % the magnitude including all the harmonics

end