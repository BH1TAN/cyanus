function input_name = cyanus_preparation(spec_neutron)
% Preparing the 5 tables for element, isotope, decay, gamma datas

cyanus_path = which('cyanus_preparation');
cyanus_path = cyanus_path(1:end-30);
input_path = fullfile(cyanus_path,'data','cyanus_input');
msg = checkcyanusinput(spec_neutron,input_path);
if strncmp(msg,'save',4)
    % spectrum not seen before, creat a new .mat file
    disp('CYANUS: Preparing cyanus_input.mat');
    table_element = readtable( ...
        fullfile(cyanus_path,'data','element.csv'),'ReadRowNames',true);
    disp('Success: Prepared table_element');
    
    table_isotope = gen_table_isotope(cyanus_path,2);
    disp('Success: Prepared table_isotopes');
    
    table_active = gen_table_active(cyanus_path,table_isotope,spec_neutron);
    disp('Success: Prepared table_active');
    
    table_decay = gen_table_decay(cyanus_path,table_active);
    disp('Success: Prepared table_decay');
    
    table_gamma = gen_table_gamma(cyanus_path,table_decay);

    eval(msg);
    input_name = msg(6:end);
    
else
    % found .mat file
    input_name = msg;
    return;
end

end