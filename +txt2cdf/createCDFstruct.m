function output = createCDFstruct()
%% Create Struct creation
output = struct('Variables',[],...
    'GlobalAttributes',     [],...
    'VariableAttributes',   []);
%% Global Attributes creation
output.GlobalAttributes = struct('creationDate',{[]},...
    'deviceModel',{{[]}},...
    'deviceSN',{{[]}},...
    'redCalibration',{{[]}},...
    'greenCalibration',{{[]}},...
    'blueCalibration',{{[]}},...
    'subjectID',{{'NA'}},...
    'subjectSex',{{'None'}},...
    'subjectDateOfBirth',{{'None'}},...
    'subjectMass',{{'0'}});
%% Variables creation
output.Variables = struct('time', [],...
    'timeOffset',[],...
    'logicalArray',[],...
    'red',[],...
    'blue',[],...
    'green',[],...
    'illuminance',[],...
    'CLA',[],...
    'CS',[],...
    'activity',[]);
%% Variables Attributes Creation and assignment
output.VariableAttributes = struct('description',[],...
    'unitPrefix',[],...
    'baseUnit',[],...
    'unitType',[],...
    'otherAttributes',[]);
output.VariableAttributes.description = {'time','Time of data values collection';
    'timeOffset','Offset from UTC';
    'logicalArray','True = subject was supposed to be wearing the device';
    'red','';
    'green','';
    'blue','';
    'illuminance','Calculated Lux';
    'CLA','Circadian Light';
    'CS','Circadian Stimulus';
    'activity','activity';};
output.VariableAttributes.unitPrefix = {'time','day';
    'timeOffset','sec';
    'logicalArray','logical';
    'red','';
    'green','';
    'blue','';
    'illuminance','lux';
    'CLA','lux';
    'CS','';
    'activity','m\s';};
output.VariableAttributes.baseUnit = {'time','d';
    'timeOffset','s';
    'logicalArray','';
    'red','lx';
    'green','lx';
    'blue','lx';
    'illuminance','lx';
    'CLA','CLA';
    'CS','CS';
    'activity','g_n';};
output.VariableAttributes.unitType = {'time','baseSI';
    'timeOffset','baseSI';
    'logicalArray','';
    'red','namedSI';
    'green','namedSI';
    'blue','namedSI';
    'illuminance','namedSI';
    'CLA','nonSI';
    'CS','nonSI';
    'activity','nonSI';};
output.VariableAttributes.otherAttributes = {'time','';
    'timeOffset','';
    'logicalArray','';
    'red','';
    'green','';
    'blue','';
    'illuminance','';
    'CLA','model';
    'CS','model';
    'activity','method';};
end