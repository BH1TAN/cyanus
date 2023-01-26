%% Analyze the count rate of delayed gammas of the given specimen
%  in different cooling time
%

clear;close all;
nSpecName = 'nspec_7M20uA_BiSurface.mat';
nSpecFactor = 7/2; % multiply factor to neutron spectrum
isPrepareInput = 1; % Run cyanus_preparation or not
specimanFoler = 'demo';specimanFile = 'special.xls';specimanSheet = 'AgBulk';
tirr = 45*60;
tcool = (0:60:3600*2)';

%% Generate spec_neutron
load(nSpecName,'spec_neutron'); % neutron flux spectrum
spec_neutron(:,2)=spec_neutron(:,2)*nSpecFactor; 
disp(['Total neutron flux(nv):',num2str(sum(spec_neutron(:,2)),'%.2e')]);

%% Generate table_specimen
cyanus_path = which('cyanus_specimen');
cyanus_path = cyanus_path(1:end-17);
table_specimen = readtable(fullfile(cyanus_path,specimanFoler,specimanFile),'Sheet',specimanSheet);
table_specimen = table_specimen(:,[1,2]);
% table_specimen = table_specimen('Ge',:); % only one element


%% Excecute CYANUS
cyanus_input = 'cyanus-input';
gammaTotalList = zeros(length(tcool),1);
gammaMaxList = zeros(length(tcool),1);
if isPrepareInput
    cyanus_preparation(spec_neutron); % MeV, nv/bin
end
for i = 1:length(tcool)
[table_gamma,table_gamma_element_tot,table_gamma_element_max] = ...
    cyanus_specimen(table_specimen,cyanus_input,[tirr,tcool(i),1]);
gammaTotalList(i,1) = sum(table_gamma_element_tot{:,end});
gammaMaxList(i,1) = table_gamma_element_max{'Cl38','ngamma'};
disp(['Cooling time No.',num2str(i),'/',num2str(length(tcool))]);
end

%% Show the results
figure;
yyaxis left;
semilogy(tcool/60,gammaMaxList,'.-','LineWidth',1);hold on;grid on;
semilogy(tcool/60,gammaTotalList,'--','LineWidth',1);
ylabel('Emission rate of gamma ray (cps)');
xlabel('Cooling time (min)');
yyaxis right
semilogy(tcool/60,gammaMaxList./gammaTotalList,'.-');
ylabel('Ratio of 2.167MeV');
legend({'Total','2.167MeV of Cl-38','Ratio of 2.167MeV'});
