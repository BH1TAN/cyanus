function [table_gamma,table_gamma_element_tot,table_gamma_element_max] = cyanus_specimen(table_specimen,spec_neutron,ttt)
% cyanus main function, fill in the specimen composition and calculate
% gammas
% operate with handle_1.mat will be easier
% Inputs:
%    table_specimen: Two column, element and mass in gram
%    spec_neutron: Two column, pointwised neutron energy (MeV) and flux
%    ttt: Irradiation, cooling and measurement time
% Outputs:
%    table_gamma: All possible decay gammas and their counts
%    table_gamma_element_tot: decay gamma count for each element
%    table_gamma_element_max: most intense decay gamma count for each element


cyanus_input_file = cyanus_preparation(spec_neutron);
load(cyanus_input_file);
tradi = ttt(1);
tcool = ttt(2);
tmeas = ttt(3);
%% fill in table_element
disp('cyanus_specimen: filling table_element (task 1/4)');
table_element{:,'mass_g'}=0;
for i = 1:size(table_specimen,1)
    table_element{table_specimen{i,1}{1,1},'mass_g'} = table_specimen{i,2};
end

%% fill in table_isotope
disp('cyanus_specimen: filling table_isotope (task 2/4)');
table_isotope{:,'n_mol'} = 0;
for i = 1:size(table_isotope,1)
    thisZ = table_isotope{i,'z'};
    eleNo = find(table_element{:,'z'}==thisZ);
    if ~isempty(eleNo)
        table_isotope{i,'n_mol'} = ...
            table_element{eleNo,'mass_g'}/table_element{eleNo,'atomicweight'}*table_isotope{i,'abun'};
    end
end

%% fill in table_decay
disp('cyanus_specimen: filling table_decay (task 3/4)');
table_decay{:,'nsat'}=0;
for i = 1:size(table_decay,1)
    thisZ = table_decay{i,'z'};
    thisA = table_decay{i,'a'}-1;
    decayConst = log(2)./table_decay{i,'halflife_s'};
    isoNo = find(table_isotope{:,'z'}==thisZ & table_isotope{:,'a'}==thisA);
    table_decay{i,'nsat'} = ...
        table_isotope{isoNo,'n_mol'}*0.602*table_decay{i,'int_part'}/decayConst;
end

%% Fill in table_gamma, table_gamma1, table_gamma2
% Fill in table_gamma
disp('cyanus_specimen: filling table_gamma (task 4/4)');
table_gamma{:,'nsat'} = table_decay{table_gamma{:,'radioisotope'},'nsat'};
decayConst = log(2)./table_gamma{:,'halflife_s'};
table_gamma{:,'ngamma'} = ...
    table_gamma{:,'nsat'}.*table_gamma{:,'branch'}.* ...
    (1-exp(-decayConst*tradi)).*exp(-decayConst*tcool).*(1-exp(-decayConst*tmeas));
table_gamma(find(table_gamma{:,'ngamma'}==0),:)=[]; % 删除没有伽马的行
columnNum = find(strcmp(table_gamma.Properties.VariableNames, 'ngamma')); % ngamma的列号
table_gamma = sortrows(table_gamma,-columnNum); % sort by gamma intensity

% fill in table_gamma1 (2nd generate radioisotope)
disp('cyanus_specimen: filling table_gamma1 (task 4/4)');
table_gamma1{:,'nsat'} = table_decay{table_gamma1{:,'isotope_parent'},'nsat'};
lam0 = table_gamma1{:,'lambda_parent'}; % 中子俘获生成的放射性同位素的衰变常数
p0 = table_gamma1{:,'br_parent'}; % 中子俘获生成的放射性同位素衰变为所研究的核素的分支比
lam1 = log(2)./table_gamma1{:,'halflife_s'}; % 研究的放射性核素的衰变常数
% 下面公式参考博士论文附录
table_gamma1{:,'ngamma'} = ...
    table_gamma1{:,'nsat'}.* (1-exp(-lam0*tradi)).* ... % 结束照射时放射性核素数量
    table_gamma1{:,'branch'}.* p0./(lam1-lam0).* ( ...
    lam1.*(exp(-lam0.*tcool)-exp(-lam0.*(tcool+tmeas))) - ...
    lam0.*(exp(-lam1.*tcool)-exp(-lam1.*(tcool+tmeas))) ...
    );
table_gamma1(find(table_gamma1{:,'ngamma'}==0),:)=[]; % 删除没有伽马的行
columnNum = find(strcmp(table_gamma1.Properties.VariableNames, 'ngamma')); % ngamma的列号
table_gamma1 = sortrows(table_gamma1,-columnNum); % sort by gamma intensity

% fill in table_gamma2 (3rd generate radioisotope)
disp('cyanus_specimen: filling table_gamma2 (task 4/4)');
table_gamma2{:,'nsat'} = table_decay{table_gamma2{:,'isotope_grand'},'nsat'};
lam0 = table_gamma2{:,'lambda_grand'}; % 中子俘获生成的放射性同位素的衰变常数(祖代)
p0 = table_gamma2{:,'br_grand'}; % 中子俘获生成的放射性同位素衰变为父代核素的分支比(祖代)
lam1 = table_gamma2{:,'lambda_parent'};% 父代放射性核素衰变常数
p1 = table_gamma2{:,'br_parent'}; % 父代放射性核素衰变为所研究核素的分支比
lam2 = log(2)./table_gamma2{:,'halflife_s'}; % 研究的放射性核素的衰变常数
table_gamma2{:,'ngamma'} = ...
    table_gamma2{:,'nsat'}.* (1-exp(-lam0*tradi)).* ... % 结束照射时放射性核素数量
    table_gamma2{:,'branch'}.*lam0.*p0.*lam1.*p1.*lam2.* ( ...
    (exp(-lam0.*tcool)-exp(-lam0.*(tcool+tmeas)))./(lam1-lam0)./(lam2-lam0)./lam0 + ...
    (exp(-lam1.*tcool)-exp(-lam1.*(tcool+tmeas)))./(lam0-lam1)./(lam2-lam1)./lam1 + ...
    (exp(-lam2.*tcool)-exp(-lam2.*(tcool+tmeas)))./(lam0-lam2)./(lam1-lam2)./lam2  ...
    );
table_gamma2(find(table_gamma2{:,'ngamma'}==0),:)=[]; % 删除没有伽马的行
columnNum = find(strcmp(table_gamma2.Properties.VariableNames, 'ngamma')); % ngamma的列号
table_gamma2 = sortrows(table_gamma2,-columnNum); % sort by gamma intensity

% Organizing gamma-rays for each element
disp('cyanus_specimen: organizing gamma for each element');
[table_gamma_element_tot,table_gamma_element_max] = ...
    getElementGamma(table_gamma); % 分元素总伽马

%% Save
disp('cyanus_specimen: Saving to cyanus-output.mat');
save('cyanus-output','table*','ttt','spec_neutron');
disp('cyanus_specimen: All Done !');

end

