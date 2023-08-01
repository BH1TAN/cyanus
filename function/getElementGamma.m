function [gamma_tot,gamma_max] = getElementGamma(table_gamma)
% Change discrete gamma point to element catalog
% Input:
%   table_element: contains the interested element list
%   table_gamma: cyanus produced gamma table
% Output:
%   table_gamma_element: Gamma count for each element
%% gamma_max
columnNum_z = find(strcmp(table_gamma.Properties.VariableNames, 'z')); % z的列号
columnNum_ngamma = find(strcmp(table_gamma.Properties.VariableNames, 'ngamma')); % ngamma的列号
table_gamma = sortrows(table_gamma,[columnNum_z,-columnNum_ngamma]); % sort by z and gamma intensity
[~,ia,~] = unique(table_gamma{:,'z'});
gamma_max = table_gamma(ia,{'radioisotope','z','a','halflife_s','energy_MeV','branch','ngamma'});
gamma_max.Properties.VariableNames{1}='element';
gamma_max.Properties.RowNames = gamma_max{:,'element'};
for i = 1:size(gamma_max,1) 
    % Only keep the Element symbol
    thisEle = gamma_max{i,'element'}{1};
    tmp = isstrprop(thisEle,'alpha');
    tmp(1,end) = 0; % 删除可能存在的能级符号
    gamma_max{i,'element'}{1} = thisEle(find(tmp)); 
end

%% gamma_tot 
element = cell(0,1);
z = [];
ngamma = [];
for i = 1:size(table_gamma,1)
    thisN = table_gamma{i,'ngamma'};
    thisZ = table_gamma{i,'z'};
    thisEle = table_gamma{i,'radioisotope'}{1};
    tmp = isstrprop(thisEle,'alpha');
    tmp(1,end) = 0; % 删除可能存在的能级符号
    thisEle = thisEle(find(tmp));
    if ismember(thisZ,z)
        ngamma(find(z==thisZ),1) = ngamma(find(z==thisZ),1)+thisN;
    else
        element = [element;thisEle];
        z = [z;thisZ];
        ngamma = [ngamma;thisN];
    end
end
gamma_tot = table(element,z,ngamma);
gamma_tot = sortrows(gamma_tot,2); % 强度由大至小排列
end

