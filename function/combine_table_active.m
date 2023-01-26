function outTable = combine_table_active(inTable,isomer)
% Generate compound nucleus list of reaction
% Input:
%    target: target nucleus. ('23Na');
%    spec_neutron: MeV and nv
% Output:
%    nuc: radioactive nucleus
%    prob: probability to form this radioactive nucleus
% 
% Info:
%     inTable(table_active) contains 289 isotopes, while isomer contains 
% 283 isotopes. The missing isotopes are 1H/2H/3He/4He/230Th/231Pa
outTable = inTable;
%outTable{1,'compound'}=cell(1,3);
outTable{:,'compound'}=cell(size(inTable,1),3);
outTable{:,'probmeta'} = zeros(size(inTable,1),3);

list_isomer = table2cell(isomer(:,'targetList'));
for i = 1:size(inTable,1)
    thisTarget = inTable.Properties.RowNames{i};
    thisName = thisTarget(isstrprop(thisTarget,'alpha'));
    thisA = str2num(thisTarget(isstrprop(thisTarget,'digit')));
    if ismember(thisTarget,list_isomer) % exist isomer
        outTable{i,'probmeta'} = isomer{thisTarget,2:4};
        if strcmp(thisTarget,'In115')
            outTable{i,'compound'} = {'In116','In116m','In116n'};
        elseif strcmp(thisTarget,'Sb123')
            outTable{i,'compound'} = {'Sb124','Sb124m','Sb124n'};
        elseif strcmp(thisTarget,'Eu151')
            outTable{i,'compound'} = {'Eu152','Eu152m','Eu152n'};
        else
            outTable{i,'compound'} = {[thisName,num2str(thisA+1)],[thisName,num2str(thisA+1),'m'],[]};
        end
    else % isomer donot exist
        outTable{i,'probmeta'} = [1,0,0];
        outTable{i,'compound'} = {[thisName,num2str(thisA+1)],'',''};
    end
end

%% Adjust the isomer ratio according to user given info
outTable{'Ti47','probmeta'}=[1 0 0];

end % of the function

