%% fig S3 
% mediation analysis, using predicted functional variability by SVR model
clear all
load('function\myPLS\Brain_data.mat') 
load('function\myPLS\Behavior_data.mat')
% PlS analysis
X0=r_Data_rbf;
[input,pls_opts,save_opts] = myPLS_inputs(X0,Y0behav,10000,1000);
[input,pls_opts,save_opts] = myPLS_initialize(input,pls_opts,save_opts);
rng('default')
res = myPLS_analysis(input,pls_opts);
myPLS_plot_results(res,save_opts);

%% fig S4
clear all
% principal SC variability with removing intra-subject variability
load('result\group_level\PC1.mat');
surf_plot(inormal(PC1),'BNV_option_color__3_3.mat')
% principal SC variability without removing intra-subject variability
load('result\group_level\PC1_Var.mat')
surf_plot(inormal(PC1_Var),'BNV_option_color__3_3.mat')
[r,p] = corr(PC1,PC1_Var)
% FC variability with removing intra-subject variability
load('result\group_level\FCIV_Result_360_42\FC_Var.mat');
surf_plot(inormal(FC_Var),'BNV_option_color__3_3.mat')
% FC variability without removing intra-subject variability
load('result\group_level\FC_FinalVar_average8.mat')
surf_plot(inormal(FC_FinalVar_average8),'BNV_option_color__3_3.mat')
[r,p] = corr(FC_FinalVar_average8,FC_Var)

%% fig S5
load('result\S1200_group_level\FC_FinalVar_1012.mat')
load('result\S1200_group_level\PC1_1012.mat')
load('result\group_level\FC_FinalVar_average8.mat')
load('result\group_level\PC1.mat')
surf_plot(inormal(FC_FinalVar_average8),'BNV_option_color__3_3.mat')
surf_plot(inormal(FC_FinalVar_1012),'BNV_option_color__3_3.mat')
[r,p] = corr(FC_FinalVar_average8,FC_FinalVar_1012)
surf_plot(inormal(PC1),'BNV_option_color__3_3.mat')
surf_plot(inormal(PC1_1012),'BNV_option_color__3_3.mat')
[r,p] = corr(PC1,PC1_1012)

%% fig S11
load('data\mean_areal_Distortion.mat')
surf_plot(mean_areal_Distortion)
stats=regstats(PC1,mean_areal_Distortion,'linear');
ResPC1 = stats.beta(1) + stats.r;
stats=regstats(FC_FinalVar_average8,mean_areal_Distortion,'linear');
ResFCIV = stats.beta(1) + stats.r;
corr(ResFCIV,ResPC1)

