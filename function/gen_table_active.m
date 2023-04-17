function table_active = gen_table_active(cyanuspath,table_isotope,spec_neutron)
% generate isotope table for code CYANUS
% Input:
% table_isotope: produced by prepWizard.m
% cyanuspath: filename or path of the cross sections
% neutronSpec: neutron flux spec with units MeV and nv
% method: 1: using NJOY21 produced (n,g) cross sections
%
% todo: Modify this function if (g,n),(g,p) and other reactions needs
% to be considered
%
table_active = table_isotope;
table_active{:,'intint'}=0;
table_active{:,'a'} = table_active{:,'a'}+1; % 中子俘获后质量数+1

%% calculate integral
disp('Calculating the xs and flux integral(intint) of table_active');
load(fullfile(cyanuspath,'data','xs_n_gamma.mat'));
for i = 1:size(table_active,1) % Each isotope
    processbar(i,size(table_active,1),10);
    isotope = table_active.Properties.RowNames{i};
    try
        eval(['xs = xs_n_gamma.',isotope,';']);
    catch
        % He4 没有截面数据
        continue;
    end
    if isempty(xs)
        xs = [1e-6,0;2e10,0];
    end
    % disp(isotope);
    table_active{i,'intint'} = ...
        numint([spec_neutron(:,1)*1e6,spec_neutron(:,2)],xs); 
end

%% calculating isomeric ratios
disp('Filling in the probmeta of table_active');
load(fullfile(cyanuspath,'data','isomer_n_gamma.mat'));
isomer_ng = get_isomer_ng(tally_all_element,spec_neutron);
% isomer_ng: target name, isomeric ratio 1,2,3
table_active = combine_table_active(table_active,isomer_ng);

end

