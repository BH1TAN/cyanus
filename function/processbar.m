function [] = processbar(thisNum,maxmax,modnum)
% Show the process bar in the console
if thisNum == 1
    fprintf(['[          ] ','  0 %%']);
elseif thisNum == maxmax
    for j = 1:18
        fprintf('%c',8); % delete printed content
    end
    fprintf(['[==========] ','100 %%\n']);
else
    if mod(thisNum,modnum)==0
        for j = 1:18
            fprintf('%c',8); % delete printed content
        end
        num = floor(thisNum/maxmax*10);
        fprintf('[');
        for j = 1:num
            fprintf('=');
        end
        for j = num+1:10
            fprintf(' ');
        end
        fprintf('] ');
        fprintf('%3d',round(thisNum/maxmax*100));
        fprintf(' %%');
    end
end

