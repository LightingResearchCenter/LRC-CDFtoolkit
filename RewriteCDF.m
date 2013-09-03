function RewriteCDF(data, FileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REWRITECDF                                                %
% -After applying custom code to a dataset, rewrite the CDF %
% file.                                                     %
% INPUT: data - The data to be written                      %
%        FileName - The name of the new CDF file. Note:     %
%                   File must not already exsist.           %
% OUTPUT: CDF File with name FileName                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create CDF file                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cdfID = cdflib.create(FileName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get variable and attribute names                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varNames = fieldnames(data.Variables);
gAttNames = fieldnames(data.GlobalAttributes);
vAttNames = fieldnames(data.VariableAttributes);

timeVecT = datevec(data.Variables.time);
timeVec = zeros(length(data.Variables.time),7);
timeVec(:,1:6) = timeVecT;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Variables                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i1 = 1:length(varNames)
    if strcmp(char(varNames(i1)), 'time')
        vars.(char(varNames(i1))) = cdflib.createVar(cdfID, char(varNames(i1)), 'CDF_EPOCH', 1, [], true, []);
    else
        vars.(char(varNames(i1))) = cdflib.createVar(cdfID, char(varNames(i1)), 'CDF_REAL8', 1, [], true, []);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Allocate Records                                          %
% -Finds the number of entries and allocates space in each  %
% variable.                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numRecords = length(data.Variables.time);
for i2 = 1:length(varNames)
    cdflib.setVarAllocBlockRecords(cdfID, vars.(char(varNames(i2))), 1, numRecords);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write Records                                             %
% -Loops and writes data to records. Note: CDF uses 0       %
% indexing while MatLab starts indexing at 1.               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i3 = 1:numRecords
    for i4 = 1:length(varNames)
        if strcmp(char(varNames(i4)), 'time')
            cdflib.putVarData(cdfID, cdflib.getVarNum(cdfID, char(varNames(i4))), ...
                i3-1, [], cdflib.computeEpoch(timeVec(i3,:)));
        else
            cdflib.putVarData(cdfID, cdflib.getVarNum(cdfID, char(varNames(i4))), ...
                i3-1, [], double(data.Variables.(char(varNames(i4)))(i3)));
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Variable Attributes                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i5 = 1:length(vAttNames)
    cdflib.createAttr(cdfID, char(vAttNames(i5)), 'variable_scope');
end

for i6 = 1:length(vAttNames)
    for i7 = 1:length(varNames)
        cdflib.putAttrEntry(cdfID, cdflib.getAttrNum(cdfID, ...
            char(vAttNames(i6))), cdflib.getAttrMaxEntry(cdfID, ...
            cdflib.getAttrNum(cdfID, char(vAttNames(i6)))) + 1, ...
            'CDF_CHAR', char(data.VariableAttributes.(char(vAttNames(i6)))(i7)));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Global Attributes                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i8 = 1:length(gAttNames)
    cdflib.createAttr(cdfID, char(gAttNames(i8)), 'global_scope');
end

for i9 = 1:length(gAttNames)
    if isa(data.GlobalAttributes.(char(gAttNames(i9))){1}, 'char')
        cdflib.putAttrgEntry(cdfID, cdflib.getAttrNum(cdfID, char(gAttNames(i9))), ...
            cdflib.getAttrMaxgEntry(cdfID, cdflib.getAttrNum(cdfID, char(gAttNames(i9)))) + 1, ...
            'CDF_CHAR', char(data.GlobalAttributes.(char(gAttNames(i9))){1}));
    elseif isa(data.GlobalAttributes.(char(gAttNames(i9))){1}, 'numeric')
        cdflib.putAttrgEntry(cdfID, cdflib.getAttrNum(cdfID, char(gAttNames(i9))), ...
            cdflib.getAttrMaxgEntry(cdfID, cdflib.getAttrNum(cdfID, char(gAttNames(i9)))) + 1, ...
            'CDF_REAL8', double(data.GlobalAttributes.(char(gAttNames(i9))){1}));
    end
end

cdflib.close(cdfID)
end