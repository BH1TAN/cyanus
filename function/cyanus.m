function [table_specimen,table_gamma] = cyanus(varargin)
% CYANUS is a MATLAB fucntion for calculating the energies and intensities
% of delayed gamma-rays released by neutron irradiated samples.
% ========================================================================
% USAGE :
% cyanus(<ele>,<mass>,<spec>,[<tirr>,<tcool>,<tmeas>]);
% <ele>   -- list of elements, for example: {'Au';'Al'}
% <mass>  -- masses of the elements, Unit:gram, for example: [1;2]
% <spec>  -- neutron spectrum, n*2 variable. The first column is the
%            neutron energy in MeV. The second column is the neutron flux
%            in cm-2s-1. Could also be the name of a .matfile. The .mat
%            file should contain the n*2 variable named spec_neutron.
% <tirr>  -- The irradiation time, unit:second
% <tcool> -- The cooling time, unit:second
% <tmeas> -- The measurement time, unit:second
% ========================================================================
% EXAMPLES :
% cyanus({'Au';'Al'},[1;2],'nspec_9MeV_in_withCd.mat',[300,300,1])
%     ----Calculate the neutron activation of 1-gram Au and 2-gram Al.
%         Use built-in neutron spectrum
%         '\data\spec_neutron\nspec_9MeV_in_withCd.mat'
%         300-second irradiation time, 300-second cooling time, and
%         1-second measurement time
% cyanus('nspec_9MeV_in_withCd.mat',[300,300,1])
%     ----Using default specimen: one gram of each element.
% cyanus({'earth';'Kenneth'},'nspec_9MeV_in_withCd.mat',[300,300,1])
%     ----Using the specimen in sheet 'Kenneth' in .xlsx file
%         'data\specimen\earth.xlsx'
% cyanus('nspec')
%     ----Show the built-in neutron spectrums
% cyanus('test1')
%     ----Run the comparison with Yule1965's reactor results
% cyanus('clear')
%     ----Clear the stored integrations of cross sections and neutron flux.

cyanus_path = which('cyanus');
cyanus_path = cyanus_path(1:end-17);
table_specimen = [];
table_gamma = [];
switch(nargin)
    case 0
        help cyanus;
        return;
    case 1
        if strcmp(varargin,'nspec')
            % show the built-in neutron spectrums
            EsupCd = 0.5e-6; % 镉截断能量，MeV
            dir1 = dir(fullfile(cyanus_path,'data','spec_neutron','n*.mat'));
            for i = 1:size(dir1,1)
                file_name{i,1} = dir1(i).name;
                load(fullfile(dir1(i).folder,dir1(i).name));
                flux_tot(i,1) = sum(spec_neutron(:,2));
                flux_supCd(i,1) = sum(spec_neutron(find(spec_neutron(:,1)>EsupCd),2));
            end
            disp('Check built_in_neutron_spec:');
            table(file_name,flux_tot,flux_supCd)
            return
        elseif strcmp(varargin,'clear')
            % clear stored input files
            delete(fullfile(cyanus_path,'data','cyanus_input\*'));
        elseif strcmp(varargin,'test1')
            % run test1
            load(fullfile(cyanus_path,'data','spec_neutron','nspec_thermal.mat'));
            spec_neutron(:,2) = spec_neutron(:,2) * 4.3e12;
            table_specimen = ...
                readtable(fullfile(cyanus_path,'data','specimen','fake.xlsx'),...
                'Sheet','allonegram');
            [table_gamma,table_gamma_element_tot,...
                table_gamma_element_max] = ...
                cyanus_specimen(table_specimen,spec_neutron,[60*60,0,1]);
            
            % show the comparison
            gammaMax = [table_gamma_element_max{:,'z'},table_gamma_element_max{:,'ngamma'}];
            load(fullfile(cyanus_path,'data','ref_Yule.mat'));
            figure;
            semilogy(table_gamma_element_max{:,'z'},table_gamma_element_max{:,'ngamma'},'ro-');
            hold on; grid on
            semilogy(sensitivity_Yule(:,1),sensitivity_Yule(:,2),'k.-');
            xlim([5 80]);
            xlabel('Z');
            ylabel('Sensitivity(cps/g)');
            legend({'CYANUS';'Yule'},'Location','best');
        else
            disp('CYANUS: Invalid input. run cyanus() to see the hints');
        end
    case 2
        % Defined neutron spectrum and 3 times
        spec_neutron = getspec(varargin{1},cyanus_path);
        
        table_specimen = ...
            readtable(fullfile(cyanus_path,'data','specimen','fake.xlsx'),...
            'Sheet','allonegram');
        
        ttt = varargin{2};
        
        [table_gamma,table_gamma_element_tot,...
            table_gamma_element_max] = ...
            cyanus_specimen(table_specimen,spec_neutron,ttt);
    case 3
        % Execute with built-in specimen, spec and times
        table_specimen = ...
            readtable(fullfile(cyanus_path,'data','specimen',[varargin{1}{1},'.xlsx']),...
            'Sheet',varargin{1}{2});
        spec_neutron = getspec(varargin{2},cyanus_path);
        
        ttt = varargin{3};
        
        [table_gamma,table_gamma_element_tot,...
            table_gamma_element_max] = ...
            cyanus_specimen(table_specimen,spec_neutron,ttt);
        
    case 4
        % Execute with user defined elements, masses, spec and times
        if ischar(varargin{1})
            % Only one element
            element = varargin(1);
        else
            % % many elements
            element = varargin{1};
        end
        mass_g = varargin{2};
        table_specimen = table(element,mass_g);
        spec_neutron = getspec(varargin{3},cyanus_path);
        ttt = varargin{4};
        
        [table_gamma,table_gamma_element_tot,...
            table_gamma_element_max] = ...
            cyanus_specimen(table_specimen,spec_neutron,ttt);
        % Show the results in the command window
        disp('--------CYANUS result---------');
        table_gamma
        disp('-------------end--------------');
    otherwise
        
end
disp('CYANUS finish! Load cyanus-output.mat to check the results');
end

