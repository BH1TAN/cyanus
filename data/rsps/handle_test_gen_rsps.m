%% 测试 gen_rsps
clear;close all;
load('rsps_HPGe34_standard_ore_density_2.mat');

eee = 0.411;
ebin = (0.001:0.001:6)';
rsps_det = gen_rsps(rsps,eee,ebin);

figure;
subplot(211)
semilogy(rsps.e_axs,rsps.gamma(:,1:5:end),'-');
xlabel('Energy(MeV)');
ylabel(['count per ',num2str(rsps.e_axs(3)-rsps.e_axs(2)),' MeV per 1 src gamma']);

subplot(212)
semilogy(ebin,rsps_det,'.-');
xlabel('Energy(MeV)');

