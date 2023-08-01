function [] = processbar2(thisNum,maxmax,modnum)
% Show the process of iteration
if nargin == 2
    modnum = 1;
end
if mod(thisNum,modnum)==0
    disp([num2str(thisNum),'/',num2str(maxmax), ...
        ' ( ',num2str(thisNum/maxmax*100),' % )']);
end

end % of the function