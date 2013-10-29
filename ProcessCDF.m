function data = ProcessCDF(FileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ProcessCDF                                               %
% -Processes a CDF file and converts variables to MatLab   %
% readable format.                                         %
% INPUT: FileName                                          %
% OUTPUT: Struct <data> containing variables & attributes  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rawData,info] = cdfread(FileName,...
    'Structure',true,'ConvertEpochToDatenum',true);

varNames = info.Variables(:,1);
% varTypes = info.Variables(:,4);

numVars = length(varNames);

gAttNames = fieldnames(info.GlobalAttributes);
gNumAtts = length(gAttNames);
vAttNames = fieldnames(info.VariableAttributes);
vNumAtts = length(vAttNames);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For each variable, check to see if it needs to be       %
% converted from epoch to matlab time. Put variables into %
% a struct named Variables that is part of a struct named %
% data.                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if numVars > 0
    for i1 = 1:numVars
        if isa(rawData(i1,1).Data, 'single')
            data.Variables.(varNames{i1}) =  double(rawData(i1,1).Data);
        else
            data.Variables.(varNames{i1}) =  rawData(i1,1).Data;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For each global attribute, put into struct named        %
% GlobalAttributes that is a part of a struct named data. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if gNumAtts > 0
    for i2 = 1:gNumAtts
            data.GlobalAttributes.(gAttNames{i2}) =...
                info.GlobalAttributes.(gAttNames{i2});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For each variable attribute, put into struct named      %
% VariableAttributes that is a part of a struct named     %
% data.                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if gNumAtts > 0
    for i3 = 1:vNumAtts
            data.VariableAttributes.(vAttNames{i3}) =...
                info.VariableAttributes.(vAttNames{i3});
    end
end


end