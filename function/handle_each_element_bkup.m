%% 从 cyanus output文件中分离各元素制造伽马过程的所有信息
% extract used info for each element, generate excel sheet for each element

clear;close all;
outputName = 'cyanus-output.mat';
zRange = [8:83,90,92]';
zRange = 8:92';
outputfolder = 'output-each-isotope';
mkdir(outputfolder);
disp('Please wait: Extracting each isotope...');
for i = 1:length(zRange)
    [msg,flag] = extract_output_1_isotope(zRange(i),outputName,outputfolder);
    if flag % failed to extract
        disp(msg)
    else
        % disp([num2str(i),'/',num2str(length(zRange))]);
    end
end
disp(['Finish extract info for each isotope, see folder: ',outputfolder]);
