function spec = getspec(specName,cyanus_path)
% 寻找输入的能谱并规范化输出
% Input:
%    specName : 字符串：.mat文件名称，寻找顺序：工作路径，cyanus\data\spec_neutron
%                两列数组：第一列MeV格式能量，第二列注量率cm-2s-1
%    cyanus_path : cyanus软件目录

if isnumeric(specName) && size(specName,2)==2
    % Input spectrum
    spec = specName;
    return;
    
elseif exist(fullfile(pwd,specName))
    % Input file exist in pwd
    disp('CYANUS: Using user defined neutron spec');
    load(specName);
    spec = spec_neutron;
elseif exist(fullfile(cyanus_path,'data','spec_neutron',specName))
    % Input file in userdata
    disp('CYANUS: Using built-in neutron spec');
    load(fullfile(cyanus_path,'data','spec_neutron',specName));
    spec = spec_neutron;
else
    error('Could not find the spectrum.');
end

% 需要一段代码判断spec是否合法

end % of the function

