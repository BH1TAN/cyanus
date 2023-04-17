function table_isomer_ng = get_isomer_ng(tally_all_element,spec_neutron)
% generate isomer_ng.xlsx for CYANUS from talys
% 注意：当前只考虑了(n,g)反应，舍弃talys给出的其它反应道
% 注意：talys给出的isomer xs 和用numdot算的结果有区别，需明确isomer xs具体含义
% TODO: 本代码基于isomer_ng.xlsx，需要优化
% 下一步可改成直接生成table_active，并对应调整TINAA主程序代码
% 
% INPUT:
%    tally_all_element: from read_talys_output_folder
%    spec_neutron: two columns(MeV , nv/lethargy)
% OUTPUT:
%    table_active: see variable explanation excel sheet
%
% 测试代码：clear;load('isotopesAndNeutronSpec.mat');load('tally_all_element.mat');table_isomer_ng = gen_table_isomer_ng(tally_all_element,spec_neutron)
% 使用有镉：clear;load('isotopesAndNeutronSpec.mat');load('nspec_9MeV_in_withCd.mat');load('tally_all_element.mat');table_isomer_ng = gen_table_isomer_ng(tally_all_element,spec_neutron)
tally_all_element(find(tally_all_element{:,'z_i'}~=tally_all_element{:,'z_o'}),:)=[];
tally_all_element(find(tally_all_element{:,'a_i'}+1~=tally_all_element{:,'a_o'}),:)=[];
tally_all_element(find(tally_all_element{:,'a_i'}+1~=tally_all_element{:,'a_o'}),:)=[];

% tally_all_element 只保留n,g反应道
targetList = [];
prob1=[];prob2=[];prob3=[];
residual = unique(tally_all_element{:,'isotope_o'},'stable'); % 子核
for i = 1:size(residual,1)
    thisRes = residual{i,1};
    thisPart = tally_all_element(find(strcmp(tally_all_element{:,'isotope_o'},thisRes)),:);
    thisIRMat = [thisPart{:,'EMeV'},thisPart{:,'ir'}];
    ir_ave = averageIR(thisIRMat,spec_neutron);
    tmp = isstrprop(thisRes,'digit');
    if tmp(end)==1
        % Isotope name finishes with a digit is in ground state
        target0 = [thisRes(find(~tmp)),num2str(thisPart{1,'a_i'})];
        targetList{end+1,1} = target0;
        prob1 = [prob1;ir_ave];
        prob2 = [prob2;0];
        prob3 = [prob3;0];
    elseif tmp(end)==0 &&tmp(end-1)==1
        % Isotope name finishes with a letter is in meta state
        target0 = [thisRes(find(~tmp(1:end-1))),num2str(thisPart{1,'a_i'})];
        rowNo = find(strcmp(targetList,target0));
        if strcmp(thisRes(end),'m')
            prob2(rowNo,1)=ir_ave;
        elseif strcmp(thisRes(end),'n')
            prob3(rowNo,1)=ir_ave;
        end
    end
    
end
table_isomer_ng = table(targetList,prob1,prob2,prob3);
table_isomer_ng.Properties.RowNames = targetList;
end