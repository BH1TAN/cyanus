function [table_specimen,table_gamma] = cyanus(varargin)
% The entrance of CYANUS function
tic;
cyanus_path = which('cyanus');
cyanus_path = cyanus_path(1:end-17);
table_specimen = [];
table_gamma = [];
switch(nargin)
    case 0
        disp(' ');
        disp('HINTS:');
        disp('cyanus(''nspec'')');
        disp('    ----Show the built-in neutron spectrums');
        disp('cyanus(''test1'')');
        disp('    ----Run the comparison with Yule1965''s reactor results ');
        disp('cyanus(''nspec_9MeV_in_withCd.mat'',[300,300,1])');
        disp('    ----Calculate specified activation case (one gram of each element)');
        disp('        [irradiation time, cooling time, measurement time] in seconds');
        disp('cyanus({''earth'';''Kenneth''},''nspec_9MeV_in_withCd.mat'',[300,300,1])');
        disp('    ----Calculate specified activation case (use built-in specimen)');
        disp('        {.xlsx filename;sheet name}, spec, times');
        disp('cyanus(''Au'',1,''nspec_9MeV_in_withCd.mat'',[300,300,1])');
        disp('    ----Calculate specified activation case (single element)');
        disp('cyanus({''Au'';''Al''},[1;2],''nspec_9MeV_in_withCd.mat'',[300,300,1])');
        disp('    ----Calculate specified activation case (more elements)');
        disp('        Input parameter: elements table, mass in gram, ');
        disp('        neutron spectrum or file, three times in second');
        disp(' ');
        disp('Using new neutron spectrum:');
        disp('    Create a n*2 variable named neutron_spec');
        disp('    The first column is the neutron energy in MeV');
        disp('    The second column is the neutron flux in cm-2s-1');
        disp('    Save the variable to the working folder as .mat file');
        disp('    Use your .mat file as input variable when excuting CYANUS');
    case 1
        if strcmp(varargin,'nspec')
            % show the built-in neutron spectrums
            dir1 = dir(fullfile(cyanus_path,'data','spec_neutron'));
            for i = 3:size(dir1,1)
                names{i-2,1} = dir1(i).name;
                load(fullfile(dir1(i).folder,dir1(i).name));
                flux_tot(i-2,1) = sum(spec_neutron(:,2));
                flux_supCd(i-2,1) = sum(spec_neutron(find(spec_neutron(:,1)>0.5e-6),2));
            end
            disp('Check built_in_neutron_spec:');
            table(names,flux_tot,flux_supCd)
        elseif strcmp(varargin,'test1')
            % run test1
            load(fullfile(cyanus_path,'data','spec_neutron','nspec_thermal.mat'));
            table_specimen = ...
                readtable(fullfile(cyanus_path,'data','specimen','fake.xlsx'),...
                'Sheet','allonegram');
            [table_gamma,table_gamma_element_tot,...
                table_gamma_element_max] = ...
                cyanus_specimen(table_specimen,[spec_neutron(:,1),spec_neutron(:,2)],[60*60,0,1]);
            
            % show the comparasion to Yule
            gammaMax = [table_gamma_element_max{:,'z'},table_gamma_element_max{:,'ngamma'}];
            load(fullfile(cyanus_path,'data','ref_Yule.mat'));
            figure;
            semilogy(table_gamma_element_max{:,'z'},table_gamma_element_max{:,'ngamma'},'k.-');
            hold on; grid on
            semilogy(sensitivity_Yule(:,1),sensitivity_Yule(:,2),'ro-');
            xlim([5 80]);
            xlabel('Z');
            ylabel('Sensitivity(cps/g)');
            legend({'Yule';'CYANUS'},'Location','best');
        else
            disp('CYANUS: Invalid input. run cyanus() to see the hints');
        end
    case 2
        % Defined neutron spectrum and 3 times
        specName = varargin{1};
        
        if isnumeric(specName) && size(specName,2)>=2
            % Input spectrum
            spec_neutron = specName;
        elseif exist(fullfile(pwd,specName))
            % Input file exist
            disp('CYANUS: Using user defined neutron spec');
            load(specName);
        elseif exist(fullfile(cyanus_path,'data','spec_neutron',specName))
            % Input file in userdata
            disp('Loading spec...');
            load(fullfile(cyanus_path,'data','spec_neutron',specName));
        end
        
        table_specimen = ...
            readtable(fullfile(cyanus_path,'data','specimen','fake.xlsx'),...
            'Sheet','allonegram');
        if isnumeric(specName) && size(specName,2)>=2
            % Input spectrum
        elseif exist(fullfile(pwd,specName))
            % Input file exist
            disp('CYANUS: Using user defined neutron spec');
            load(specName);
        elseif exist(fullfile(cyanus_path,'data','spec_neutron',specName))
            % Input file in userdata
            disp('Loading spec...');
            load(fullfile(cyanus_path,'data','spec_neutron',specName));
        end
        ttt = varargin{2};
        [table_gamma,table_gamma_element_tot,...
            table_gamma_element_max] = ...
            cyanus_specimen(table_specimen,[spec_neutron(:,1),spec_neutron(:,2)],ttt);
    case 3
        % Execute with built-in specimen, spec and times
        table_specimen = ...
            readtable(fullfile(cyanus_path,'data','specimen',[varargin{1}{1},'.xlsx']),...
            'Sheet',varargin{1}{2});
        specName = varargin{2};
        if isnumeric(specName) && size(specName,2)>=2
            % Input spectrum
            spec_neutron = specName;
        elseif exist(fullfile(pwd,specName))
            % Input file exist
            disp('CYANUS: Using user defined neutron spec');
            load(specName);
        elseif exist(fullfile(cyanus_path,'data','spec_neutron',specName))
            % Input file in userdata
            disp('Loading spec...');
            load(fullfile(cyanus_path,'data','spec_neutron',specName));
        end
        ttt = varargin{3};
        
        [table_gamma,table_gamma_element_tot,...
            table_gamma_element_max] = ...
            cyanus_specimen(table_specimen,[spec_neutron(:,1),spec_neutron(:,2)],ttt);
        
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
        
        specName = varargin{3};
        if isnumeric(specName) && size(specName,2)>=2
            % Input spectrum
            spec_neutron = specName;
        elseif exist(fullfile(pwd,specName))
            % Input file exist
            disp('CYANUS: Using user defined neutron spec');
            load(specName);
        elseif exist(fullfile(cyanus_path,'data','spec_neutron',specName))
            % Input file in userdata
            disp('Loading spec...');
            load(fullfile(cyanus_path,'data','spec_neutron',specName));
        end
        
        ttt = varargin{4};
        
        [table_gamma,table_gamma_element_tot,...
            table_gamma_element_max] = ...
            cyanus_specimen(table_specimen,[spec_neutron(:,1),spec_neutron(:,2)],ttt);
        if size(table_specimen,1)==1
            % only one element
            disp('--------CYANUS result---------');
            disp(['Element: ',table_gamma_element_max{1,'element'}{1}, ...
                ' (Z=',num2str(table_gamma_element_max{1,'z'}),')']);
            disp(['Total count: ',num2str(table_gamma_element_tot{1,'ngamma'})]);
            disp(['Max gamma count: ', ...
                num2str(table_gamma_element_max{1,'ngamma'}), ...
                ' @ ',num2str(table_gamma_element_max{1,'energy_MeV'}),' MeV']);
            disp('-------------end--------------');
        else
            % many elements, show all gamma-ray
            disp('--------CYANUS result---------');
            table_gamma
            disp('-------------end--------------');
        end
    otherwise
end

toc;
disp('CYANUS finish! Load cyanus-output.mat to check the results');
end

