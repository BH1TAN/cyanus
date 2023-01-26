function [ME,z,a,b] = readwritewebdecay(z,a,b)
% z: 质子数
% a:质量数
% b: ''基态  'm'第一激发态   'n'第二激发态

ME = [];
try
    if strcmp(b,'m') 
        tmp = 300;  % 第一激发态 在网页url中以A+300表示
    elseif strcmp(b,'n') 
        tmp = 600; % 第二激发态 在网页url中以A+600表示
    else  
        tmp = 0; % 基态
    end
    data = read1webdecay([num2str(z),'0',num2str(a+tmp,'%03d')]);    
    if ~isempty(data)
        if isempty(b) % 基态
            save(['decay_',num2str(z),'_',num2str(a),'.txt'],'data','-ascii');
            disp(['Write: decay_',num2str(z),'_',num2str(a), ...
                '.txt. Intensity summation:',num2str(sum(data(:,2)))]);
        else % 同质异能态
            save(['decay_',num2str(z),'_',num2str(a),'_',b,'.txt'],'data','-ascii');
            disp(['Write: decay_',num2str(z),'_',num2str(a),'_',b, ...
                '.txt. Intensity summation:',num2str(sum(data(:,2)))]);
        end
    end
catch ME
    disp(['Error: Reading web file ',num2str(z),'0',num2str(a+tmp,'%03d')]);
end
end