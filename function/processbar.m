function [] = processbar(thisNum,max,modmod)
% Show the process bar in the console
if thisNum == 1
    fprintf(['[          ] ','  0 %%']);
elseif thisNum == max
    for j = 1:18
        fprintf('%c',8); % delete printed content
    end
    fprintf(['[==========] ','100 %%\n']);
else
    if mod(thisNum,modmod)==0
        for j = 1:18
            fprintf('%c',8); % delete printed content
        end
        num = floor(thisNum/max*10);
        fprintf('[');
        for j = 1:num
            fprintf('=');
        end
        for j = num+1:10
            fprintf(' ');
        end
        fprintf('] ');
        fprintf('%3d',round(thisNum/max*100));
        fprintf(' %%');
    end
end

