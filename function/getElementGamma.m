function [gamma_tot,gamma_max] = getElementGamma(gamma)
% Change discrete gamma point to element catalog
% Input:
%   gamma: cyanus produced gamma table (normally named table_gamma)
% Output:
%   gamma_tot: Total gamma-ray count of each element
%   gamma_max: The most intense gamma-ray of each element

%% gamma_max
columnNum_z = find(strcmp(gamma.Properties.VariableNames, 'z')); % z的列号
columnNum_ngamma = find(strcmp(gamma.Properties.VariableNames, 'ngamma')); % ngamma的列号
gamma = sortrows(gamma,[columnNum_z,-columnNum_ngamma]); % sort by z and gamma intensity
[~,ia,~] = unique(gamma{:,'z'});
gamma_max = gamma(ia,{'radioisotope','z','a','halflife_s','energy_MeV','branch','ngamma'});
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
for i = 1:size(gamma,1)
    thisN = gamma{i,'ngamma'};
    thisZ = gamma{i,'z'};
    thisEle = gamma{i,'radioisotope'}{1};
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

