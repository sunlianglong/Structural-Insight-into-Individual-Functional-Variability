clear all
% R corr, with Age and Gender covariance regression
load('function\myPLS\Brain_data.mat') 
load('function\myPLS\Behavior_data.mat')
%% PlS analysis
X0=r_Data_corr;
[input,pls_opts,save_opts] = myPLS_inputs(X0,Y0behav,10000,1000);
[input,pls_opts,save_opts] = myPLS_initialize(input,pls_opts,save_opts);
rng('default')
res = myPLS_analysis(input,pls_opts);
myPLS_plot_results(res,save_opts);

