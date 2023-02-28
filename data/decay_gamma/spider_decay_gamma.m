%% 读取在线数据库的所有衰变数据
% http://nucleardata.nuclear.lu.se/
% url like
% Au198
% http://nucleardata.nuclear.lu.se/toi/nuclide.asp?iZA=790198
% http://nucleardata.nuclear.lu.se/toi/nuclide.asp?iZA=790498
clear;close all;fclose all;
load('list_isotope.mat','list_isotope');
list_za=[];
list_decaygamma = cell(0,0);
for i = 14:size(list_isotope,1)
    thisZ = list_isotope{i,'Z'};
    tryA0 = list_isotope{i,'A'};
    tryA = [tryA0-1:tryA0+1];
    for j = 1:length(tryA)
        readwritewebdecay(thisZ,tryA(j),'');
        readwritewebdecay(thisZ,tryA(j),'m');
        readwritewebdecay(thisZ,tryA(j),'n');
        % disp(['Processed: isotope #',num2str(i),'/',num2str(size(list_isotope,1)),...
        %     ' isomer #',num2str(j),'/',num2str(length(tryA))]);
        disp(['Processed:',num2str(i),'/',num2str(size(list_isotope,1)),' isotopes']);
    end
end
