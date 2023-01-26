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
    decayConst = (log(2)/table_decay{i,'halflife_s'});
    isoNo = find(table_isotope{:,'z'}==thisZ & table_isotope{:,'a'}==thisA);
    table_decay{i,'nsat'} = ...
        table_isotope{isoNo,'n_mol'}*0.602*table_decay{i,'int_part'}/decayConst;
end

%% fill in table_gamma
disp('cyanus_specimen: filling table_gamma (task 4/4)');
table_gamma{:,'ngamma'} = 0;
nsat_list = table_decay{table_gamma{:,'radioisotope'},'nsat'};
decayConst = log(2)./table_gamma{:,'halflife_s'};
table_gamma{:,'ngamma'} = ...
    nsat_list.*table_gamma{:,'branch'}.* ...
    (1-exp(-decayConst*tradi)).*exp(-decayConst*tcool).*(1-exp(-decayConst*tmeas));
table_gamma(find(table_gamma{:,'ngamma'}==0),:)=[]; % 删除没有伽马的行
table_gamma = sortrows(table_gamma,-8); % sort by gamma intensity

disp('cyanus_specimen: organizing gamma for each element');
[table_gamma_element_tot,table_gamma_element_max] = getElementGamma(table_gamma); % 分元素总伽马

disp('cyanus_specimen: Saving to cyanus-output.mat');
save('cyanus-output','table*','ttt','spec_neutron');
disp('cyanus_specimen: All Done !');

end

