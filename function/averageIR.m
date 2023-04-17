function ir_ave = averageIR(matIR,spec)
% 从中子能量与IR对应关系 和 中子能谱 生成平均IR

% INPUT:
%    matIR: 第一列MeV能量，第二列IR
%    neutronSpec:第一列中子MeV能量，第二列flux


matIR = [0,matIR(1,2);matIR]; % matIR最低能量以下的IR视为最低能量的IR
% matIR = [matIR;11,matIR(end,2)]; 
% energy range in matIR should cover the maximum energy in neutron
% spectrum, or the estimation of isomeric ratio will be bad.

% 计算各能点IR，
% 由于spec的能点一般是bin的右边界，而非bin的平均值，本算法会有微小偏差
spec(:,3) = interp1(matIR(:,1),matIR(:,2),spec(:,1)); 
ir_ave = spec(:,2)'*spec(:,3)/sum(spec(:,2));
if isnan(ir_ave)
    error(['averageIR.m appears nan result.', ...
        ' The maximum energy in spec is larger than that in matIR ?', ...
        ' The energy unit of neutron spec should be MeV']);
end
end

