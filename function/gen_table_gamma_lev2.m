function table_gamma2 = gen_table_gamma_lev2(cyanus_path,decay_info_lev2)
% Generate table of decay gammas
% Input:
%    cyanus_path: path to the cyanus folder
%    decay_info_lev2: radioisotopes have a grandparent

energy_MeV = [];
radioisotope = cell(0,0);
z = [];
a = [];
state = cell(0,0);
halflife_s = [];
branch = [];
isotope_grand = cell(0,0);
lambda_grand = [];
br_grand = [];
isotope_parent = cell(0,0);
lambda_parent = [];
br_parent = [];

disp('Storing the decay gammas of table_gamma_lev2');
for i = 1:size(decay_info_lev2,1)
    thisIso = decay_info_lev2{i,'iso'}{1};
    tmp = isstrprop(thisIso,'alpha');
    pos_ele = find(tmp(1:end-1)); % delete the possible state
    pos_a = find(~tmp);
    thisZ = element(thisIso(pos_ele));
    thisA = str2num(thisIso(pos_a));
    if ~tmp(end) % ground state
        thisS = 'g';
        fileName = fullfile(cyanus_path,'data','decay_gamma', ...
            ['decay_',num2str(thisZ),'_',num2str(thisA),'.txt']);
    else
        thisS = thisIso(tmp(end));
        fileName = fullfile(cyanus_path,'data','decay_gamma', ...
            ['decay_',num2str(thisZ),'_',num2str(thisA),'_',thisS,'.txt']);
    end
    if exist(fileName)
        gammas = importdata(fileName);
        for j = 1:size(gammas,1)
            energy_MeV = [energy_MeV;gammas(j,1)];
            radioisotope = [radioisotope;decay_info_lev2.iso{i}];
            z = [z;thisZ];
            a = [a;thisA];
            state = [state;thisS];
            halflife_s = [halflife_s;decay_info_lev2{i,'halflife'}];
            branch = [branch;gammas(j,2)];
            isotope_grand = [isotope_grand;decay_info_lev2.iso_parent2{i}];
            lambda_grand = [lambda_grand;log(2)/decay_info_lev2.h2(i)];
            br_grand = [br_grand;decay_info_lev2.br2(i)];
            isotope_parent = [isotope_parent;decay_info_lev2.iso_parent1{i}];
            lambda_parent = [lambda_parent;log(2)/decay_info_lev2.h1(i)];
            br_parent = [br_parent;decay_info_lev2.br1(i)];
        end
    end
end
table_gamma2 = table(energy_MeV,radioisotope,z,a,state,halflife_s, ...
    branch,isotope_grand,lambda_grand,br_grand, ...
    isotope_parent,lambda_parent,br_parent);

end % of the function

