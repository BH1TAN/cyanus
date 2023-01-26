function table_element = gen_table_element(cyanuspath,method)
% generate element table for code TINAA
% Input:
% cyanuspath: path to the cyanus folder
% method: 1: read from https://www-nds.iaea.org/pgaa/databases.htm
%         2: read from database "nubase"
switch method
    case 1 % from https://www-nds.iaea.org/pgaa/databases.htm
        thistable = readtable('E:\myDataBase\TINAA-simulation-tool\naa-database\element.xls','Sheet','import');
        table_element = thistable(:,1:3);
        table_element.Properties.RowNames = table_element.element;
        table_element = table_element(:,2:end);
        table_element = sortrows(table_element,1);
    case 2
        table_element = readtable(fullfile(cyanuspath,'data','element.csv'),'ReadRowNames',true);
    otherwise
        
        
end
end % of the function