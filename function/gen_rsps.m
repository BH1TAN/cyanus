function rsps_det = gen_rsps(rsps,eee,ebin)
% 基于蒙卡模拟的分立单能伽马响应能谱，得到指定点的能谱
% 
% Inputs:
%    rsps：结构体，包括
%       rsps.e_src: 蒙卡模拟的分立能量值（MeV） 
%       rsps.e_axs: 能量轴（MeV）
%       rsps.gamma: 每一个源粒子对应的该能区计数
%    eee: 指定的入射粒子能量（MeV）
%    ebin: 指定的能量轴（MeV）
% Outputs:
%    rsps_det: 单列能谱，ebin指定的能量划分中的单伽马响应

% 找到距离最近的能谱，在能谱轴上放缩
[~,num] = min(abs(rsps.e_src-eee));
thisE = rsps.e_src(num);

ratio = eee/thisE;

eaxs = rsps.e_axs * ratio; % 伸缩能量轴
thisrsps = rsps.gamma(:,num)/ratio; % 伸缩伽马数

rsps_det = interp1(eaxs,cumsum(thisrsps),ebin);
rsps_det = [0;diff(rsps_det)];

disp(['输入能谱总计数：',num2str(sum(rsps.gamma(:,num)))]);
disp(['输入能谱总计数：',num2str(sum(rsps_det))]);
end

