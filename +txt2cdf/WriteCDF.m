function WriteCDF(ProcessedData,savePath)
%WRITECDF
%   -Write processed data to CDF File. Note: Only works if
%   filename is not already taken. If file exists, creation
%   will fail. Deletion of files may be manual, or by using
%   cdflib.open() and cdflib.delete()

time = ProcessedData.Variables.time;
timeOffset = ProcessedData.Variables.timeOffset;
IDnum = str2num(ProcessedData.GlobalAttributes.deviceSN{1})-12000;
shortSN = num2str(IDnum);
longSN = num2str(120000+IDnum);

prompt = ['Enter Subject ID for SN ',shortSN,': '];
subjectID = input(prompt,'s');
if isempty(subjectID)
   subjectID = ' ';
end
prompt = ['Enter Subject Sex for SN ',shortSN,': '];
subjectSex = input(prompt,'s');
if isempty(subjectSex)
   subjectSex = ' ';
end
prompt = ['Enter Subject Date of Birth for SN ',shortSN,' in mm\\dd\\yyyy format: '];
subjectDOB = input(prompt,'s');
if isempty(subjectDOB)
   subjectDOB = ' ';
end
prompt = ['Enter Subject Mass for SN ',shortSN,': '];
subjectMass = input(prompt,'s');
if isempty(subjectMass)
   subjectMass = ' ';
end

red = ProcessedData.Variables.red;
green = ProcessedData.Variables.green;
blue = ProcessedData.Variables.blue;
illuminance = ProcessedData.Variables.illuminance;
CLA = ProcessedData.Variables.CLA;
CS = ProcessedData.Variables.CS;
activity = ProcessedData.Variables.activity;

logicalArray = ones(size(time));

calFactors = [ProcessedData.GlobalAttributes.redCalibration{1},...
   ProcessedData.GlobalAttributes.greenCalibration{1}...
   ProcessedData.GlobalAttributes.blueCalibration{1}];

%% Convert time to CDF_EPOCH format
% -Matlab creates 1x6 time vectors, but needs 1x7 to create
% a CDF_EPOCH value. This method adds 0 ms to each vector.
timeVecT = datevec(time);
timeVec = zeros(length(time),7);
timeVec(:,1:6) = timeVecT;

%% Create CDF file
createTime = now;
cdfID = cdflib.create(savePath);
% All writing is done in a try statement, so that if there is an error it
% will still close the cdf file. 
 try 
   %% Create Variables
   varTime         = cdflib.createVar(cdfID,'time',        'CDF_EPOCH',1,[],true,[]);
   varTimeOffset   = cdflib.createVar(cdfID,'timeOffset',  'CDF_REAL8',1,[],true,[]);
   varLogicalArray = cdflib.createVar(cdfID,'logicalArray','CDF_REAL8',1,[],true,[]);
   varRed          = cdflib.createVar(cdfID,'red',         'CDF_REAL8',1,[],true,[]);
   varGreen        = cdflib.createVar(cdfID,'green',       'CDF_REAL8',1,[],true,[]);
   varBlue         = cdflib.createVar(cdfID,'blue',        'CDF_REAL8',1,[],true,[]);
   varIlluminance  = cdflib.createVar(cdfID,'illuminance', 'CDF_REAL8',1,[],true,[]);
   varCLA          = cdflib.createVar(cdfID,'CLA',         'CDF_REAL8',1,[],true,[]);
   varCS           = cdflib.createVar(cdfID,'CS',          'CDF_REAL8',1,[],true,[]);
   varActivity     = cdflib.createVar(cdfID,'activity',    'CDF_REAL8',1,[],true,[]);
   
   %% Allocate Records
   % -Finds the number of entries from Daysimeter device and
   % allocates space in each variable.
   numElTime = length(time);

   cdflib.setVarAllocBlockRecords(cdfID,varTime,           1,numElTime);
   cdflib.setVarAllocBlockRecords(cdfID,varTimeOffset,     1,1);
   cdflib.setVarAllocBlockRecords(cdfID,varLogicalArray,   1,numElTime);
   cdflib.setVarAllocBlockRecords(cdfID,varRed,            1,numElTime);
   cdflib.setVarAllocBlockRecords(cdfID,varGreen,          1,numElTime);
   cdflib.setVarAllocBlockRecords(cdfID,varBlue,           1,numElTime);
   cdflib.setVarAllocBlockRecords(cdfID,varIlluminance,    1,numElTime);
   cdflib.setVarAllocBlockRecords(cdfID,varCLA,            1,numElTime);
   cdflib.setVarAllocBlockRecords(cdfID,varCS,             1,numElTime);
   cdflib.setVarAllocBlockRecords(cdfID,varActivity,       1,numElTime);
   
   %% Find varNum
   % -CDF assigns a number to each variable. Records are
   % written to variables using the appropriate number.
   timeVarNum = cdflib.getVarNum(cdfID,'time');
   timeOffsetVarNum = cdflib.getVarNum(cdfID,'timeOffset');
   logicalArrayVarNum = cdflib.getVarNum(cdfID,'logicalArray');
   redVarNum = cdflib.getVarNum(cdfID,'red');
   greenVarNum = cdflib.getVarNum(cdfID,'green');
   blueVarNum = cdflib.getVarNum(cdfID,'blue');
   illuminanceVarNum = cdflib.getVarNum(cdfID,'illuminance');
   CLAVarNum = cdflib.getVarNum(cdfID,'CLA');
   CSVarNum = cdflib.getVarNum(cdfID,'CS');
   activityVarNum = cdflib.getVarNum(cdfID,'activity');
   
   %% Write Records
   % -Loops and writes data to records. Note: CDF uses 0
   % indexing while MatLab starts indexing at 1.
   cdflib.putVarData(cdfID,timeOffsetVarNum,   0,   [],timeOffset);
   for i1 = 1:numElTime
      cdflib.putVarData(cdfID,timeVarNum,         i1-1,[],cdflib.computeEpoch(timeVec(i1,:)));
      cdflib.putVarData(cdfID,logicalArrayVarNum, i1-1,[],logicalArray(i1));
      cdflib.putVarData(cdfID,redVarNum,          i1-1,[],red(i1));
      cdflib.putVarData(cdfID,greenVarNum,        i1-1,[],green(i1));
      cdflib.putVarData(cdfID,blueVarNum,         i1-1,[],blue(i1));
      cdflib.putVarData(cdfID,illuminanceVarNum,  i1-1,[],illuminance(i1));
      cdflib.putVarData(cdfID,CLAVarNum,          i1-1,[],CLA(i1));
      cdflib.putVarData(cdfID,CSVarNum,           i1-1,[],CS(i1));
      cdflib.putVarData(cdfID,activityVarNum,     i1-1,[],activity(i1));
   end
   
   %% Make Variable Attributes
   numDescription  = cdflib.createAttr(cdfID, 'description',       'variable_scope');
   numUnitPrefix   = cdflib.createAttr(cdfID, 'unitPrefix',        'variable_scope');
   numUnitBase     = cdflib.createAttr(cdfID, 'baseUnit',          'variable_scope');
   numUnitType     = cdflib.createAttr(cdfID, 'unitType',          'variable_scope');
   numOther        = cdflib.createAttr(cdfID, 'otherAttributes',   'variable_scope');
   
   %%
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', 'Local time in CDF Epoch format, milliseconds since 1-Jan-000');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', 'Localized offset from UTC in seconds');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', 'Circadian Light');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', 'Circadian Stimulus');
   cdflib.putAttrEntry(cdfID, numDescription, cdflib.getAttrMaxEntry(cdfID,...
      numDescription) + 1, 'CDF_CHAR', 'Activity index in g-force (acceleration in m/s^2 over standard gravity 9.80665 m/s^2)');
   
   %%
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,... 
   numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitPrefix, cdflib.getAttrMaxEntry(cdfID,...
      numUnitPrefix) + 1, 'CDF_CHAR', ' ');
   
   %%
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 'CDF_EPOCH');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 's');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 'lx');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 'lx');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 'lx');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 'lx');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 'CLA');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 'CS');
   cdflib.putAttrEntry(cdfID, numUnitBase, cdflib.getAttrMaxEntry(cdfID,...
      numUnitBase) + 1, 'CDF_CHAR', 'g_n');
   
   %%
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'nonSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'namedSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'nonSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'namedSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'namedSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'namedSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'namedSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'nonSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'nonSI');
   cdflib.putAttrEntry(cdfID, numUnitType, cdflib.getAttrMaxEntry(cdfID,...
      numUnitType) + 1, 'CDF_CHAR', 'nonSI');
   
   %%
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', ' ');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', 'model');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', 'model');
   cdflib.putAttrEntry(cdfID, numOther, cdflib.getAttrMaxEntry(cdfID,...
      numOther) + 1, 'CDF_CHAR', 'method');
   
   %% Make Global Attributes
   numCreate   = cdflib.createAttr(cdfID, 'creationDate',          'global_scope');
   numModel    = cdflib.createAttr(cdfID, 'deviceModel',           'global_scope');
   numSN       = cdflib.createAttr(cdfID, 'deviceSN',              'global_scope');
   numRedCal   = cdflib.createAttr(cdfID, 'redCalibration',        'global_scope');
   numGreenCal = cdflib.createAttr(cdfID, 'greenCalibration',      'global_scope');
   numBlueCal  = cdflib.createAttr(cdfID, 'blueCalibration',       'global_scope');
   numSubID    = cdflib.createAttr(cdfID, 'subjectID',             'global_scope');
   numSubSex   = cdflib.createAttr(cdfID, 'subjectSex',            'global_scope');
   numSubDOB   = cdflib.createAttr(cdfID, 'subjectDateOfBirth',    'global_scope');
   numSubMass  = cdflib.createAttr(cdfID, 'subjectMass',           'global_scope');
   
   cdflib.putAttrgEntry(cdfID, numCreate,      0, 'CDF_CHAR',  datestr(createTime,'dd-mmm-yyyy HH:MM:SS.FFF'));
   cdflib.putAttrgEntry(cdfID, numModel,       0, 'CDF_CHAR',  'daysimeter12');
   cdflib.putAttrgEntry(cdfID, numSN,          0, 'CDF_CHAR',  longSN);
   cdflib.putAttrgEntry(cdfID, numRedCal,      0, 'CDF_REAL8', calFactors(1));
   cdflib.putAttrgEntry(cdfID, numGreenCal,    0, 'CDF_REAL8', calFactors(2));
   cdflib.putAttrgEntry(cdfID, numBlueCal,     0, 'CDF_REAL8', calFactors(3));
   cdflib.putAttrgEntry(cdfID, numSubID,       0, 'CDF_CHAR',  subjectID);
   cdflib.putAttrgEntry(cdfID, numSubSex,      0, 'CDF_CHAR',  subjectSex);
   cdflib.putAttrgEntry(cdfID, numSubDOB,      0, 'CDF_CHAR',  subjectDOB);
   cdflib.putAttrgEntry(cdfID, numSubMass,     0, 'CDF_CHAR',  subjectMass);
   
   %% Close File
   % -If file is not closed properly, it could corrupt entire
   % file, making it un-openable/un-readable/un-deletable
   cdflib.close(cdfID);
catch err
   cdflib.close(cdfID);
   rethrow(err);
end
end
