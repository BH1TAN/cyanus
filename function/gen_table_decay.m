function table_decay = gen_table_decay(cyanuspath,table_active)
% Read radioactive isotopes from table_active, then fill in their
% halflife and partial integral int_part
% Input:
% cyanuspath: filename or path of the data containing decay isotopes
% table_active: table containing radioactive isotopes
compound = cell(0,0);
z = [];
a = [];
stat = cell(0,0);
int_part = [];
disp('Storing the decay parameters of table_decay');
load(fullfile(cyanuspath,'data','nubase_light.mat'));
for i = 1:size(table_active,1)
    for j = 1:3
        thisCompound=table_active{i,'compound'}{1,j};
        if isempty(thisCompound)
            break;
        else
            compound = [compound;thisCompound];
            z = [z;table_active{i,'z'}];
            a = [a;table_active{i,'a'}];
            switch j
                case 1
                    stat = [stat;'g'];
                case 2
                    stat = [stat;'m'];
                case 3
                    stat = [stat;'n'];
            end
            int_part = [int_part; ...
                table_active{i,'intint'}*table_active{i,'probmeta'}(1,j)];
        end
    end
end
halflife_s = zeros(size(z,1),1);
table_decay = table(compound,z,a,stat,halflife_s,int_part);
table_decay.Properties.RowNames = compound;
% Delete the isotopes not produced in the activation
table_decay = table_decay(find(table_decay{:,'int_part'}>0),:);

disp('Filling in the halflifes in table_decay');
for i = 1:size(table_decay,1) % fill in the halflifes
    processbar(i,size(table_decay,1),10);
    table_decay{i,'halflife_s'} = ...
        gethalflife(table_decay{i,'z'},table_decay{i,'a'},table_decay{i,'stat'}{1},nubase);
end
lineNo = find(~isnan(table_decay{:,'halflife_s'})); % line No. of radioactive isotopes
table_decay = table_decay(lineNo,:);
end % of the function

