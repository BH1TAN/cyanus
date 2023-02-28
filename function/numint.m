function intint = numint(spe,xs,n_bin)
% 计算 注量率能量对数间隔直方图与截面曲线的数值积分
% Input：
%     spe 射线能谱,第一列能量，第二列为该能点与上一个能点之间的粒子数
%     xs  (n,g)截面，第一列能量，第二列截面；
%     n_bin: 插值点数量(可选)
%     注意： spe和xs能量轴单位需统一
%            spe能点中，大于xs最大能点的点，对应的截面视为xs最大能点处的截面
% Output:
%     intint(1): 截面与注量的数值积分值

switch nargin
    case 2
        % 中子活化问题中，1e6插值点数可保证任意稳定核素的积分误差小于0.3%
        n_bin = 1e6; 
    case 3
        % 指定了插值点数，不再使用默认值
    otherwise 
        error('Number of inputs of numint.m is not right');
end
spe = sortrows(spe,1);
xs = sortrows(xs,1);
if isempty(xs)||isempty(spe)
    intint=0;
    return;
end
if spe(1,1)<xs(1,1)
    % 低于最小能量的截面视为最小能量对应截面
    xs = [spe(1,1)/2,xs(1,1);xs];
end
if xs(end,1)<spe(end,1)
    % 高于最大能量的截面视为最大能量对应截面
    xs = [xs;spe(end,1)*2,xs(end,2)];
end
pos = find(diff(xs(:,1))==0); % xs能点重复的位置
for i = 1:length(pos)
    % 将与下一个能点重复的能点向前微调
    xs(pos(i),1)=xs(pos(i),1)-1e-2*(xs(pos(i),1)-xs(pos(i)-1,1));
end
for i = 1:length(pos)
    if xs(pos(i),1)==xs(pos(i)+1,1)
        % 微调后依旧没错开则直接删除该点
        xs(pos(i),[1 2])=[0 0];
    end
end
xs = sortrows(xs,1);
xs = xs(find(xs(:,1)>0),:);
pt = linspace(log(spe(1,1)),log(spe(end,1)),n_bin)'; % 对数等间隔取能点
xs2 = interp1(xs(:,1),xs(:,2),exp(pt));
spe2 = interp1(log(spe(:,1)),cumsum(spe(:,2)),pt);
spe2 = diff([spe2(1);spe2]);
intint = xs2'*spe2;

end
