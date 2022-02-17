clear all
Yourdata_path = '';
load(strcat(Yourdata_path,'\group_networks.mat'))
group_pre_FC_r2 = zeros(360,1);
for i = 1:360
    disp(i);
    stat = regstats(averageFC(:,i),[averageSC(:,i),averageCO(:,i),averagePL(:,i),averageMyelin(:,i),averageThi(:,i),averageSulc(:,i),averageCC(:,i),averageSA(:,i)]);
    group_pre_FC_r2(i,1) = stat.adjrsquare;
end
save('result\group_level\group_pre_FC_r2.mat','group_pre_FC_r2');
surf_plot(group_pre_FC_r2,'BNV_option_BlueRed_11colors.mat')
%% mediation analysis

% please download the ToolBoxs from : https://github.com/canlab/MediationToolbox
% addpath('function\CanlabCore');
% addpath('function\MediationToolbox');
load('result\group_level\PC1.mat');
load('result\group_level\FC_FinalVar_average8.mat');
load('result\group_level\fit_FCIV_SVR.mat');
load('result\group_level\group_pre_FC_r2.mat')
%% SC-FC coupling
% for PC1
[paths1,stats1] = mediation(zscore(PC1),zscore(FC_FinalVar_average8),zscore(group_pre_FC_r2),'plots','verbose','boot','bootsamples',10000,'doCIs');
% for Fit_FCIV_SVR
[paths2,stats2] = mediation(zscore(fit_FCIV_SVR),zscore(FC_FinalVar_average8),zscore(group_pre_FC_r2),'plots','verbose','boot','bootsamples',10000,'doCIs');


