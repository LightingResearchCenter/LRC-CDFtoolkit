function newtime = smarttimeconvert(time)
interval= mode(diff(time));
if interval >=300
   %Time is stored in Milliseconds used in CDF formats
   time = time/10/24/60/60;
   exceltime = datetime(time(1:2), 'ConvertFrom','excel');
   excel1904time = datetime(time(1:2), 'ConvertFrom','excel1904');
   posixtime = datetime(time(1:2), 'ConvertFrom','posixtime');
elseif interval<1
   %Time is stored in days
   exceltime = datetime(time(1:2), 'ConvertFrom','excel');
   excel1904time = datetime(time(1:2), 'ConvertFrom','excel1904');
   posixtime = datetime(time(1:2), 'ConvertFrom','posixtime');
elseif interval<200 && interval>20
   %Time in stored in seconds
   time=time/24/60/60;
   exceltime = datenum(datetime(time(1:2), 'ConvertFrom','excel'));
   excel1904time = datenum(datetime(time(1:2), 'ConvertFrom','excel1904'));
   posixtime = datenum(datetime(time(1:2), 'ConvertFrom','posixtime'));
end
disp('1)');
disp(datestr(exceltime));
disp('2)');
disp(datestr(excel1904time));
disp('3)');
disp(datestr(posixtime));
disp('4)');
disp( datestr(time(1:2)));
disp('5) Create your own epoch');
prompt= 'Please select which option is the best for this file';
str = input(prompt,'s');
in = false;
while in==false
   if isempty(str)
      prompt='That was not an option. Please select again.';
      str = input(prompt,'s');
   elseif strcmp(str,'1')
      newtime = datetime(time, 'ConvertFrom','excel');
      disp(newtime(1:2));
      prompt='Are these times correct(Y/N):';
      correct = input(prompt,'s');
      if strcmpi(correct,'y')
         in = true;
      elseif strcmpi(correct,'n')
         
      else
         
      end
   elseif strcmp(str,'2')
      newtime = datetime(time, 'ConvertFrom','excel1904');
      disp(newtime(1:2));
      prompt='Are these times correct(Y/N):';
      correct = input(prompt,'s');
      if strcmpi(correct,'y')
         in = true;
      elseif strcmpi(correct,'n')
         
      else
         
      end
   elseif strcmp(str,'3')
      newtime = datetime(time, 'ConvertFrom','posixtime');
      disp(newtime(1:2));
      prompt='Are these times correct(Y/N):';
      correct = input(prompt,'s');
      if strcmpi(correct,'y')
         in = true;
      elseif strcmpi(correct,'n')
         
      else
         
      end
   elseif strcmp(str,'4')
      newtime = time;
      disp(datestr(newtime(1:2)));
      prompt='Are these times correct(Y/N):';
      correct = input(prompt,'s');
      if strcmpi(correct,'y')
         in = true;
      elseif strcmpi(correct,'n')
         
      else
         in = true;
      end
   elseif strcmp(str,'5')
      prompt = 'What is your epoch?(enter in yyyy-mm-dd format): ';
      epoch = input(prompt,'s');
      epochnum = datenum(epoch);
      newtime = time + epochnum;
      disp(datestr(newtime(1:2)));
      prompt='Are these times correct(Y/N):';
      correct = input(prompt,'s');
      if strcmpi(correct,'y')
         in = true;
         newtime = datestr(newtime);
      elseif strcmpi(correct,'n')
         
      else
         
      end
   else
      prompt='That was not an option. Please select again.';
      str = input(prompt,'s');
   end
end
newtime = datenum(newtime);
end