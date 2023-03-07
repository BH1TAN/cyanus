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
spec_neutron = [spec_neutron(:,1)*1e6,spec_neutron(:,2)]; % units to eV
table_active = table_isotope;
table_active{:,'intint'}=0;
table_active{:,'a'} = table_active{:,'a'}+1;

%% calculate integral
disp('Calculating the xs and flux integral(intint) of table_active');
for i = 1:size(table_active,1) % Each isotope
    xs = readtable(fullfile(cyanuspath,'data','xs_n_gamma',[table_active.Properties.RowNames{i},'.txt']));
    xs = table2array(xs);
    if isempty(xs)
        table_active{i,'intint'} = 0;
    else
        % Energy unit of spec_neutron and xs should be the same
        table_active{i,'intint'} = numint(spec_neutron,xs);
    end
    processbar(i,size(table_active,1),10);
end

%% calculating isomeric ratios
disp('Filling in the probmeta of table_active');
load(fullfile(cyanuspath,'data','isomer_n_gamma.mat'));
isomer_ng = get_isomer_ng(tally_all_element,spec_neutron);
% isomer_ng: target name, isomeric ratio 1,2,3
table_active = combine_table_active(table_active,isomer_ng);

end

