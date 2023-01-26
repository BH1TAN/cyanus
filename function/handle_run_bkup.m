%% Analyze the delayed gamma of the given specimen in given time
clear;close all;
nSpecName = 'nspec_9MeV_in_withoutCd';
nSpecFactor = 1; % multiply factor to neutron spectrum
isPrepareInput = 1; % Run cyanus_preparation or not
specimanFoler = 'demo';specimanFile = 'mylist.xlsx';specimanSheet = 'allonegram';
ttt = [300,300,1]; % unit:s , irradiation, cooling and measurement time

%% Generate spec_neutron
load(nSpecName,'spec_neutron'); % neutron flux spectrum
spec_neutron(:,2)=spec_neutron(:,2)*nSpecFactor; 
disp(['Total neutron flux(nv):',num2str(sum(spec_neutron(:,2)),'%.2e')]);

%% Generate table_specimen
cyanus_input = 'cyanus-input';
cyanus_path = which('cyanus_specimen');
cyanus_path = cyanus_path(1:end-17);
table_specimen = readtable(fullfile(cyanus_path,specimanFoler,specimanFile),'Sheet',specimanSheet);
table_specimen = table_specimen(:,[1,2]);

%% Excecute CYANUS
if isPrepareInput
    cyanus_preparation(spec_neutron); % MeV, nv/bin
end
[table_gamma,table_gamma_element_tot,table_gamma_element_max] = ...
    cyanus_specimen(table_specimen,cyanus_input,ttt);
