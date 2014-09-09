function [ CLA ] = cs2cla( CS )
%% Description
% This function takes a given CS and converts it to its corresponding CLA 
% value

%% Conversion Function
CLA = 355.7 * -log(1-(CS/.7))/log(1.1026);

end

