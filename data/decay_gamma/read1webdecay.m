function data = read1webdecay(str)
% 读取 http://nucleardata.nuclear.lu.se/ 的decay gamma
%
logFile = 'spider.log';
thisURL = ['http://nucleardata.nuclear.lu.se/toi/nuclide.asp?iZA=',str];
content = webread(thisURL);
content1 = content(strfind(content,'Gammas from'):strfind(content,'X-rays from'));
if isempty(content1)
    content1 = content(strfind(content,'Gammas from'):strfind(content,'Betas from'));
end
content = content1;
content = content(strfind(content,[char(9),char(9)]):end);
pos_start = findstr(content,'<TD>');
pos_end = findstr(content,'&nbsp;');
data = [];
flag = 0;
for i = 1:length(pos_start)
    thisEnd = pos_end(min(find(pos_end>pos_start(i))));
    thisData = content(pos_start(i)+4:thisEnd-1);
    tmp = find(isstrprop(thisData,'digit')); % 检测数字部分
    thisData = thisData(min(tmp):max(tmp)); % 保留数字部分
    if isempty(thisData)
        thisData = '0';
    end
    data = [data;str2num(thisData)];
    if mod(i,2)==1 && ((str2num(thisData)<0.9 || str2num(thisData)>20000))
        % 能量小于0.9keV 或 大于20MeV判断为读取出错,能量最小伽马为Eu-154m的0.91keV
        flag = 1;
    end
    if mod(i,2)==0 && (str2num(thisData)>100)
        % 强度大于100%
        flag = 2;
    end
end

flag_solved = 0;
switch str
    case '140027'
        data(end,:)=[]; % 缺最后一行强度，删除最后一行
        flag_solved = 1;
    case '340073'
        data(2:2:end) = data(2:2:end)*97/108;
        flag_solved = 1;
    case '420093'
        % *值已设为0
    case '500421'
        % *值已设为0
    case '560429'
        % 相对强度且产率低，直接忽视
        data = [0;0];
    case '560430'
        data(2:2:end) = data(2:2:end)*96.5/106;
        flag_solved = 1;
    case '560436'
        data(2:2:end) = data(2:2:end)*99.82/100.1;
        flag_solved = 1;
    case '600441'
        % *值已设为0
    case '630450'
        % *值已设为0
    case '770492'
        % *值已设为0
    otherwise
        
end

% 转换data为两列数据原始数据单位是keV,百分比,转换至：MeV,1
data = [data(1:2:end)/1000,data(2:2:end)*0.01];

% 输出data合理性的log信息
fid = fopen(logFile,'a');
if flag_solved
    disp('Solved ');
    fprintf(fid,'\n Solved ');fprintf('%c',8);
end
switch flag
    case 1
        disp(['Error: decay gamma table of ZA=',str,' appears < 1keV or >20 MeV gamma.']);
        fprintf(fid,['Error: decay gamma table of ZA=',str,' appears < 1keV or >20 MeV gamma.']);
    case 2
        disp(['Error: decay gamma table of ZA=',str,' appears > 100 %% intensity']);
        fprintf(fid,['Error: decay gamma table of ZA=',str,' appears > 100 %% intensity.']);
end
fclose(fid);
end

