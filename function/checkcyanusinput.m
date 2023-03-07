function msg = checkcyanusinput(spec,input_path)
% 验证spec和相关档案是否曾经被计算并保存在input_path文件夹下
% 若已经预计算，输出计算结果的.mat文件名
% 若未被预计算，输出:保存即将进行的计算的结果的matlab命令

str_spec = num2str(reshape(spec,1,[]));
try
    load(fullfile(input_path,'cyanus_input_index.mat'));
catch ME
    disp('CYANUS: checkcyanusinput creating cyanus_input_index.mat');
    nspec = [];matName = [];
    cyanus_input_index = table(nspec,matName);
    save(fullfile(input_path,'cyanus_input_index.mat'),'cyanus_input_index');
end

for i = 1:size(cyanus_input_index,1)
    if strcmp(str_spec,cyanus_input_index{i,'nspec'}{1,1})
        msg = cyanus_input_index{i,2}{1};
        msg = fullfile(input_path,[msg,'.mat']); % return the mat file
        if exist(msg,'file')
            disp('CYANUS: cyanus_input for input neutron spec already exist: ');
            disp(['    ',msg]);
            return;
        else
            break;
        end
    end
end

% do not exist the mat file
thisMat = ['cyanus_input_',num2str(size(cyanus_input_index,1)+1)];
cyanus_input_index = [cyanus_input_index;{str_spec,thisMat}];
save(fullfile(input_path,'cyanus_input_index.mat'),'cyanus_input_index');
msg = ['save ',fullfile(input_path,thisMat)];

end