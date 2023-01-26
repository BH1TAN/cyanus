function [msg,flag] = extract_output_1_isotope(zzz,cyanus_output,folderName)
% Extract all the info cyanus used for 1 element and save to excel sheet
% Inputs:
%    zzz: z number of the element
%    cyanus_output: output .mat file of cyanus
%    folderName: (Optional) Data sheet save to which folder
% Output:
%    msg: The information of extraction
%    flag: 1=failed,0=success
%    Save one .xls file

load(cyanus_output);
idx = find(table_element{:,'z'}==zzz);
switch nargin
    case 2
        folderName = '.';
    otherwise
end
if isempty(idx)
    msg = ['Warning: Ignored invalid z=',num2str(zzz)];
    flag = 1;
    return;
else
    msg = ['Extract z=',num2str(zzz), ' into excel'];
    flag = 0;
    table_element0 = table_element(idx,:);
end
ele = table_element0.Properties.RowNames{1};
xlsName = fullfile(folderName,['z',num2str(zzz),'-',ele]);
writetable(table_element0,xlsName,'writeMode','overwritesheet', ...
    'FileType','spreadsheet','WriteVariableNames',true);

table_isotope0 = table_isotope(find(table_isotope{:,'z'}==zzz),:);
writetable(table_isotope0,xlsName,'writeMode','append', ...
    'FileType','spreadsheet','WriteVariableNames',true);

table_active0 = table_active(find(table_active{:,'z'}==zzz),:);
writetable(table_active0,xlsName,'writeMode','append', ...
    'FileType','spreadsheet','WriteVariableNames',true);

table_decay0 = table_decay(find(table_decay{:,'z'}==zzz),:);
writetable(table_decay0,xlsName,'writeMode','append', ...
    'FileType','spreadsheet','WriteVariableNames',true);

table_gamma0 = table_gamma(find(table_gamma{:,'z'}==zzz),:);
% sort by gamma intensity
table_gamma0 = sortrows(table_gamma0,-size(table_gamma0,2)); 
if ~isempty(table_gamma0)
    writetable(table_gamma0,xlsName,'writeMode','append', ...
        'FileType','spreadsheet','WriteVariableNames',true);
end

end