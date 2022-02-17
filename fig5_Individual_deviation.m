%% 4.1 get individual deviations
% principal structural deviation
Yourdata_path = '';
load(strcat(Yourdata_path,'\structural_connectomes.mat'))
datalist = {'SC','CO','PL','SD','CC','SA','CT','IM'};
for i = 1:8
    output_file = strcat('result\individual_level\',datalist{i},'_Deviation_42');
    mkdir(output_file)
    str = ['tmp = ',datalist{i},';'];
    eval(str);
    fun_FinalDeviation_trt(tmp, 'pearson', datalist{i},output_file);
end
% function deviation
load('connectomes\functional_connectomes_8runs.mat');
output_file = strcat('result\individual_level\FC_Deviation_42');
mkdir(output_file)
data = FC;
fun_FinalDeviation_trt(data,'pearson','FC',output_file);

%% 4.2 Mean and STD of individual deviation
load('result\individual_level\FC_Deviation_42\FC_FinalDeviation_session_average.mat')
FinalDeviation_FC = FinalDeviation_FC_session_average;
mean_FCdeviation = mean(FinalDeviation_FC)';
std_FCdeviation = std(FinalDeviation_FC)';
surf_plot(std_FCdeviation);

load('result\individual_level\PC1_Deviation_42.mat')
mean_PCdeviation = mean(PC1_Deviation_42_session_average)';
std_PC1deviation = std(PC1_Deviation_42_session_average)';
surf_plot(std_PC1deviation);


%% 4.3 Deviation similarity
load('result\individual_level\PC1_Deviation_42.mat')
load('result\individual_level\FC_Deviation_42\FC_FinalDeviation_session1_4.mat')
load('result\individual_level\FC_Deviation_42\FC_FinalDeviation_session5_8.mat')
load('data\SystemID_in_Glasser360\hier4_atlas.mat')
output_file = 'result\individual_level\Deviation_similarity';
mkdir (output_file)
% for FC
for i = 1:42
    FC_data_p(i,1) = corr(FinalDeviation_FC_session1_4(i,:)',FinalDeviation_FC_session5_8(i,:)');
    tmpFC = FinalDeviation_FC_session1_4(i,:)';
    tmpPC1 = FinalDeviation_FC_session5_8(i,:)';
    for j = 1:4
        tmp1 = tmpFC(final_hier_360==j,:);
        tmp2 = tmpPC1(final_hier_360==j,:);
        FC_data_p(i,j+1) = corr(tmp1,tmp2);
    end
end

FC_s1_2_s2 = zeros(42,5);
for i = 1:42
    p_data = zeros(5,1);
    tmpS1 = FinalDeviation_FC_session1_4(i,:)';
    for j = 1:42
        tmpS2 = FinalDeviation_FC_session5_8(j,:)';
        p_data(1) = p_data(1) + corr(tmpS1,tmpS2);
        for sy = 1:4
            tmp1 = tmpS1(final_hier_360==sy,:);
            tmp2 = tmpS2(final_hier_360==sy,:);
            p_data(sy+1) = p_data(sy+1) + corr(tmp1,tmp2);
        end
    end
    FC_s1_2_s2(i,:) = p_data/42;
end

FC_s2_2_s1 = zeros(42,5);
for i = 1:42
    p_data = zeros(5,1);
    tmpS1 = FinalDeviation_FC_session5_8(i,:)';
    for j = 1:42
        tmpS2 = FinalDeviation_FC_session1_4(j,:)';
        p_data(1) = p_data(1) + corr(tmpS1,tmpS2);
        for sy = 1:4
            tmp1 = tmpS1(final_hier_360==sy,:);
            tmp2 = tmpS2(final_hier_360==sy,:);
            p_data(sy+1) = p_data(sy+1) + corr(tmp1,tmp2);
        end
    end
    FC_s2_2_s1(i,:) = p_data/42;
end

% for PC1
for i = 1:42
    PC1_data_p(i,1) = corr(PC1_Deviation_42_scan1(i,:)',PC1_Deviation_42_scan2(i,:)');
    tmpFC = PC1_Deviation_42_scan1(i,:)';
    tmpPC1 = PC1_Deviation_42_scan2(i,:)';
    for j = 1:4
        tmp1 = tmpFC(final_hier_360==j,:);
        tmp2 = tmpPC1(final_hier_360==j,:);
        PC1_data_p(i,j+1) = corr(tmp1,tmp2);
    end
end

PC1_s1_2_s2 = zeros(42,5);
for i = 1:42
    p_data = zeros(5,1);
    tmpS1 = PC1_Deviation_42_scan1(i,:)';
    for j = 1:42
        tmpS2 = PC1_Deviation_42_scan2(j,:)';
        p_data(1) = p_data(1) + corr(tmpS1,tmpS2);
        for sy = 1:4
            tmp1 = tmpS1(final_hier_360==sy,:);
            tmp2 = tmpS2(final_hier_360==sy,:);
            p_data(sy+1) = p_data(sy+1) + corr(tmp1,tmp2);
        end
    end
    PC1_s1_2_s2(i,:) = p_data/42;
end

PC1_s2_2_s1 = zeros(42,5);
for i = 1:42
    p_data = zeros(5,1);
    tmpS1 = PC1_Deviation_42_scan2(i,:)';
    for j = 1:42
        tmpS2 = PC1_Deviation_42_scan1(j,:)';
        p_data(1) = p_data(1) + corr(tmpS1,tmpS2);
        for sy = 1:4
            tmp1 = tmpS1(final_hier_360==sy,:);
            tmp2 = tmpS2(final_hier_360==sy,:);
            p_data(sy+1) = p_data(sy+1) + corr(tmp1,tmp2);
        end
    end
    PC1_s2_2_s1(i,:) = p_data/42;
end
% prepate for visualization
A = PC1_data_p(:,1);
B = PC1_s1_2_s2(:,1);
B2 = PC1_s2_2_s1(:,1);
save(strcat(output_file,'\PC1_whole_brain.mat'),'A','B','B2');
A = PC1_data_p(:,2);
B = PC1_s1_2_s2(:,2);
B2 = PC1_s2_2_s1(:,2);
save(strcat(output_file,'\PC1_pri.mat'),'A','B','B2');
A = PC1_data_p(:,3);
B = PC1_s1_2_s2(:,3);
B2 = PC1_s2_2_s1(:,3);
save(strcat(output_file,'\PC1_uni.mat'),'A','B','B2');
A = PC1_data_p(:,4);
B = PC1_s1_2_s2(:,4);
B2 = PC1_s2_2_s1(:,4);
save(strcat(output_file,'\PC1_heter.mat'),'A','B','B2');
A = PC1_data_p(:,5);
B = PC1_s1_2_s2(:,5);
B2 = PC1_s2_2_s1(:,5);
save(strcat(output_file,'\PC1_para.mat'),'A','B','B2');

A = FC_data_p(:,1);
B = FC_s1_2_s2(:,1);
B2 = FC_s2_2_s1(:,1);
save(strcat(output_file,'\FC_whole_brain.mat'),'A','B','B2');
A = FC_data_p(:,2);
B = FC_s1_2_s2(:,2);
B2 = FC_s2_2_s1(:,2);
save(strcat(output_file,'\FC_pri.mat'),'A','B','B2');
A = FC_data_p(:,3);
B = FC_s1_2_s2(:,3);
B2 = FC_s2_2_s1(:,3);
save(strcat(output_file,'\FC_uni.mat'),'A','B','B2');
A = FC_data_p(:,4);
B = FC_s1_2_s2(:,4);
B2 = FC_s2_2_s1(:,4);
save(strcat(output_file,'\FC_heter.mat'),'A','B','B2');
A = FC_data_p(:,5);
B = FC_s1_2_s2(:,5);
B2 = FC_s2_2_s1(:,5);
save(strcat(output_file,'\FC_para.mat'),'A','B','B2');


%% 4.4 fingerprint
% FC variability
load('result\individual_level\FC_Deviation_42\FC_FinalDeviation_session1_4.mat')
load('result\individual_level\FC_Deviation_42\FC_FinalDeviation_session5_8.mat')
for i = 1:42
    for j = 1:42
        FC_data_p_1to2(i,j) = corr(FinalDeviation_FC_session1_4(i,:)',FinalDeviation_FC_session5_8(j,:)');
        FC_data_p_2to1(i,j) = corr(FinalDeviation_FC_session5_8(i,:)',FinalDeviation_FC_session1_4(j,:)');
    end
end
SR_1to2 = zeros(42,1);
SR_2to1 = zeros(42,1);
for i = 1:42
    [a,b] = max(FC_data_p_1to2(i,:));
    if b == i
       SR_1to2(i,1) = 1;
    end
    [a,b] = max(FC_data_p_2to1(i,:));
    if b == i
       SR_2to1(i,1) = 1;
    end
end
ratio = sum([SR_1to2;SR_2to1])/84
% principal SC variability
load('result\individual_level\PC1_Deviation_42.mat')
for i = 1:42
    for j = 1:42
        PC1_data_p_1to2(i,j) = corr(PC1_Deviation_42_scan1(i,:)',PC1_Deviation_42_scan2(j,:)');
        PC1_data_p_2to1(i,j) = corr(PC1_Deviation_42_scan2(i,:)',PC1_Deviation_42_scan1(j,:)');
    end
end
SR_1to2 = zeros(42,1);
SR_2to1 = zeros(42,1);
for i = 1:42
    [a,b] = max(PC1_data_p_1to2(i,:));
    if b == i
       SR_1to2(i,1) = 1;
    end
    [a,b] = max(PC1_data_p_2to1(i,:));
    if b == i
       SR_2to1(i,1) = 1;
    end
end
ratio = sum([SR_1to2;SR_2to1])/84


%% 4.5 the correspondence between principal structural deviation and functional deviation
load('result\individual_level\FC_Deviation_42\FC_FinalDeviation_session_average.mat')
load('result\individual_level\PC1_Deviation_42.mat')
load('data\SystemID_in_Glasser360\hier4_atlas.mat')
output_file = strcat('result\individual_level\results_Corr');
mkdir(output_file)
% whole brain level & system level
for subs = 1:42
    tmp1 = PC1_Deviation_42_session_average(subs,:)';
    tmp2 = FinalDeviation_FC_session_average(subs,:)';
    r_corr_wholebrain(subs,1) = corr(tmp1,tmp2);
    r_corr_pri(subs,1) = corr(tmp1(final_hier_360==1),tmp2(final_hier_360==1));
    r_corr_uni(subs,1) = corr(tmp1(final_hier_360==2),tmp2(final_hier_360==2));
    r_corr_heter(subs,1) = corr(tmp1(final_hier_360==3),tmp2(final_hier_360==3));
    r_corr_para(subs,1) = corr(tmp1(final_hier_360==4),tmp2(final_hier_360==4));
end
save(strcat(output_file,'\r_corr.mat'),'r_corr_wholebrain','r_corr_pri','r_corr_uni','r_corr_heter','r_corr_para');

%% 4.6 The  predictive power of structural deviation on functional deviation
clear all
load('result\individual_level\FC_Deviation_42\FC_FinalDeviation_session_average.mat')
load('data\SystemID_in_Glasser360\hier4_atlas.mat')
datalist = {'SC','CO','PL','SD','CC','SA','CT','IM'};
for i = 1:length(datalist)
    load(strcat('result\individual_level\',datalist{i},'_Deviation_42\',datalist{i},'_FinalDeviation_session_average.mat'));
end
fit_FC_IV_SVR = zeros(360,42);
output_file = strcat('result\individual_level\results_SVR');
mkdir(output_file)
% whole brain level
for subs = 1:42
    disp(subs);
    %% SVR
    X = ([FinalDeviation_SC_session_average(subs,:)',FinalDeviation_CO_session_average(subs,:)',FinalDeviation_PL_session_average(subs,:)',FinalDeviation_CT_session_average(subs,:)',FinalDeviation_IM_session_average(subs,:)',FinalDeviation_SD_session_average(subs,:)',FinalDeviation_CC_session_average(subs,:)',FinalDeviation_SA_session_average(subs,:)']); 
    Y_real = FinalDeviation_FC_session_average(subs,:)';
    % Min-Max scaling
    X=mapminmax(X',0,1)';
    for i=1:360
        X1 = X;
        Y1 = Y_real;
        X1(i,:) = [];
        Y1(i,:) = [];
        model_svr = fitrsvm(X1,Y1,'KernelFunction','rbf');
        fit_FC_IV_SVR(i,subs) = predict(model_svr,X(i,:));
    end
    r_rbf_wholebrain(subs,1) = corr(fit_FC_IV_SVR(:,subs),Y_real);
end

% system level
clear fit_FC_IV_SVR;
for subs = 1:42
    disp(subs);
    X = [FinalDeviation_SC_session_average(subs,:)',FinalDeviation_CO_session_average(subs,:)',FinalDeviation_PL_session_average(subs,:)',FinalDeviation_CT_session_average(subs,:)',FinalDeviation_IM_session_average(subs,:)',FinalDeviation_SD_session_average(subs,:)',FinalDeviation_CC_session_average(subs,:)',FinalDeviation_SA_session_average(subs,:)']; 
    Y_real = FinalDeviation_FC_session_average(subs,:)';
    X=mapminmax(X',0,1)';
    X_primary = X(final_hier_360==1,:);
    Y_primary = Y_real(final_hier_360==1);
    for i=1:length(Y_primary)
        X1 = X_primary;
        Y1 = Y_primary;
        X1(i,:) = [];
        Y1(i,:) = [];
        model_svr = fitrsvm(X1,Y1,'KernelFunction','rbf');
        fit_FC_IV_SVR(i,subs) = predict(model_svr,X_primary(i,:));
    end
    r_rbf_pri(subs,1) = corr(fit_FC_IV_SVR(:,subs),Y_real(final_hier_360==1));
end
clear fit_FC_IV_SVR;
for subs = 1:42
    disp(subs);
    X = [FinalDeviation_SC_session_average(subs,:)',FinalDeviation_CO_session_average(subs,:)',FinalDeviation_PL_session_average(subs,:)',FinalDeviation_CT_session_average(subs,:)',FinalDeviation_IM_session_average(subs,:)',FinalDeviation_SD_session_average(subs,:)',FinalDeviation_CC_session_average(subs,:)',FinalDeviation_SA_session_average(subs,:)']; 
    Y_real = FinalDeviation_FC_session_average(subs,:)';
    X=mapminmax(X',0,1)';
    X_uni = X(final_hier_360==2,:);
    Y_uni = Y_real(final_hier_360==2);
    for i=1:length(Y_uni)
        X1 = X_uni;
        Y1 = Y_uni;
        X1(i,:) = [];
        Y1(i,:) = [];
        model_svr = fitrsvm(X1,Y1,'KernelFunction','rbf');
        fit_FC_IV_SVR(i,subs) = predict(model_svr,X_uni(i,:));
    end
    r_rbf_uni(subs,1) = corr(fit_FC_IV_SVR(:,subs),Y_real(final_hier_360==2));
end
clear fit_FC_IV_SVR;
for subs = 1:42
    disp(subs);
    X = [FinalDeviation_SC_session_average(subs,:)',FinalDeviation_CO_session_average(subs,:)',FinalDeviation_PL_session_average(subs,:)',FinalDeviation_CT_session_average(subs,:)',FinalDeviation_IM_session_average(subs,:)',FinalDeviation_SD_session_average(subs,:)',FinalDeviation_CC_session_average(subs,:)',FinalDeviation_SA_session_average(subs,:)']; 
    Y_real = FinalDeviation_FC_session_average(subs,:)';
    X=mapminmax(X',0,1)';
    X_heter = X(final_hier_360==3,:);
    Y_heter = Y_real(final_hier_360==3);
    for i=1:length(Y_heter)
        X1 = X_heter;
        Y1 = Y_heter;
        X1(i,:) = [];
        Y1(i,:) = [];
        model_svr = fitrsvm(X1,Y1,'KernelFunction','rbf');
        fit_FC_IV_SVR(i,subs) = predict(model_svr,X_heter(i,:));
    end
    r_rbf_heter(subs,1) = corr(fit_FC_IV_SVR(:,subs),Y_real(final_hier_360==3));
end
clear fit_FC_IV_SVR;
for subs = 1:42
    disp(subs);
    X = [FinalDeviation_SC_session_average(subs,:)',FinalDeviation_CO_session_average(subs,:)',FinalDeviation_PL_session_average(subs,:)',FinalDeviation_CT_session_average(subs,:)',FinalDeviation_IM_session_average(subs,:)',FinalDeviation_SD_session_average(subs,:)',FinalDeviation_CC_session_average(subs,:)',FinalDeviation_SA_session_average(subs,:)']; 
    Y_real = FinalDeviation_FC_session_average(subs,:)';
    X=mapminmax(X',0,1)';
    X_paralimbic = X(final_hier_360==4,:);
    Y_paralimbic = Y_real(final_hier_360==4);
    for i=1:length(Y_paralimbic)
        X1 = X_paralimbic;
        Y1 = Y_paralimbic;
        X1(i,:) = [];
        Y1(i,:) = [];
        model_svr = fitrsvm(X1,Y1,'KernelFunction','rbf');
        fit_FC_IV_SVR(i,subs) = predict(model_svr,X_paralimbic(i,:));
    end
    r_rbf_para(subs,1) = corr(fit_FC_IV_SVR(:,subs),Y_real(final_hier_360==4));
end
save(strcat(output_file,'\r_rbf.mat'),'r_rbf_wholebrain','r_rbf_pri','r_rbf_uni','r_rbf_heter','r_rbf_para');










