%% regression model
load('result\group_level\SIV_FinalVar_8variables_average_scans.mat');
load('result\group_level\PC1.mat');
load('result\group_level\FC_FinalVar_average8.mat');
load('data\SystemID_in_Glasser360\hier4_atlas.mat');
stat  = regstats(FC_FinalVar_average8,PC1);
sqrt(stat.adjrsquare)
for hier = 1:4
    disp(hier);
    stat  = regstats(FC_FinalVar_average8(final_hier_360==hier),PC1(final_hier_360==hier));
    sqrt(stat.adjrsquare)
end
surf_plot(inormal(PC1),'BNV_option_color__3_3.mat');% plot

%% SVR
kernel = 'rbf';% alteration:'rbf'
X = [SC_FinalVar,CO_FinalVar,PL_FinalVar,IM_FinalVar,CT_FinalVar,SD_FinalVar,CC_FinalVar,SA_FinalVar];
% X = [SC_Var_1012,CO_Var_1012,PL_Var_1012,IM_Var_1012,CT_Var_1012,SD_Var_1012,CC_Var_1012,SA_Var_1012];

X=mapminmax(X',0,1)';
Y = FC_FinalVar_average8;
% Y = FC_FinalVar_1012;
fit_FCIV_SVR = zeros(360,1);
for i=1:360
    disp(i);
    X1 = X;
    Y1 = Y;
    X1(i,:) = [];
    Y1(i,:) = [];
    model_svr = fitrsvm(X1,Y1,'KernelFunction',kernel); 
    fit_FCIV_SVR(i,1) = predict(model_svr,X(i,:));
end
[p,q] = corr(fit_FCIV_SVR,Y)
% save('result\group_level\fit_FCIV_SVR_whole.mat','fit_FCIV_SVR');
surf_plot(inormal(fit_FCIV_SVR),'BNV_option_color__3_3.mat');% plot

% for 4 systems
X = ([SC_FinalVar,CO_FinalVar,PL_FinalVar,IM_FinalVar,CT_FinalVar,SD_FinalVar,CC_FinalVar,SA_FinalVar]);
% X = [SC_Var_1012,CO_Var_1012,PL_Var_1012,IM_Var_1012,CT_Var_1012,SD_Var_1012,CC_Var_1012,SA_Var_1012];
X=mapminmax(X',0,1)';
Y = FC_FinalVar_average8;
% Y = FC_FinalVar_1012;
for hier = 1:4
    disp(hier);
    flag=hier;
    X_tmp = X(final_hier_360==flag,:);
    X_tmp=mapminmax(X_tmp',0,1)';
    Y_tmp = Y(final_hier_360==flag);
    fit_FCIV_SVR_tmp = zeros(length(Y_tmp),1);
    for i=1:length(Y_tmp)
        X1 = X_tmp;
        Y1 = Y_tmp;
        X1(i,:) = [];
        Y1(i,:) = [];
        model_svr = fitrsvm(X1,Y1,'KernelFunction',kernel);
        fit_FCIV_SVR_tmp(i,1) = predict(model_svr,X_tmp(i,:));
    end
    stat  = regstats(Y(final_hier_360==flag),fit_FCIV_SVR_tmp);
    sqrt(stat.adjrsquare)
end



