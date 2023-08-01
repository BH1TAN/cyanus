function out = isotope(in)
% Convert the name of isotope
% 将字符串+数字+字符串（可选）的格式变换为latex格式

% sym = { 'H';'He';'Li';'Be'; 'B'; 'C'; 'N'; 'O'; 'F';'Ne'; ...
%        'Na';'Mg';'Al';'Si'; 'P'; 'S';'Cl';'Ar'; 'K';'Ca'; ...
%        'Sc';'Ti'; 'V';'Cr';'Mn';'Fe';'Co';'Ni';'Cu';'Zn'; ...
%        'Ga';'Ge';'As';'Se';'Br';'Kr';'Rb';'Sr'; 'Y';'Zr'; ...
%        'Nb';'Mo';'Tc';'Ru';'Rh';'Pd';'Ag';'Cd';'In';'Sn'; ...
%        'Sb';'Te'; 'I';'Xe';'Cs';'Ba';'La';'Ce';'Pr';'Nd'; ...
%        'Pm';'Sm';'Eu';'Gd';'Tb';'Dy';'Ho';'Er';'Tm';'Yb'; ...
%        'Lu';'Hf';'Ta'; 'W';'Re';'Os';'Ir';'Pt';'Au';'Hg'; ...
%        'Tl';'Pb';'Bi';'Po';'At';'Rn';'Fr';'Ra';'Ac';'Th'; ...
%        'Pa'; 'U';'Np';'Pu';'Am';'Cm';'Bk';'Cf';'Es';'Fm'; ...
%        'Md';'No';'Lr';'Rf';'Db';'Sg';'Bh';'Hs';'Mt';'Ds'; ...
%        'Rg';'Cn';'Nh';'Fl';'Mc';'Lv';'Ts';'Og'};


pos_digit = min(find(isstrprop(in,'digit'))); % 数字的位置
seg1 = in(1:pos_digit-1);
seg2 = in(pos_digit:end);
out = ['$\rm ^{',seg2,'}$',seg1];

end % of the function

