%% 1.1 calculate variability for structural connectomes
%   by Lianglong Sun, 20191010.
clear all
Yourdata_path = '';
load(strcat(Yourdata_path,'\structural_connectomes.mat'))
output_file = 'result\group_level\SIV_Result_360_42';
mkdir(output_file)
datalist = {'SC','CO','PL','SD','CC','SA','CT','IM'};
for i = 1:8
    for j = 1:2
        if j ==1
            str = ['tmp = ',datalist{i},';'];
            eval(str);
            fun_FinalVariability_trt([tmp(:,1),tmp(:,2)], 'pearson', strcat(datalist{i},'_scan1'), output_file);
        else
            fun_FinalVariability_trt([tmp(:,2),tmp(:,1)], 'pearson', strcat(datalist{i},'_scan2'), output_file);
        end
    end
end
for i = 1:8
    load(strcat(output_file,'\',datalist{i},'_scan1_FinalVar.mat'))
    load(strcat(output_file,'\',datalist{i},'_scan2_FinalVar.mat'))
    str = ['tmp = ',datalist{i},';'];
    eval(str);
    str = [datalist{i},'_FinalVar = (',datalist{i},'_scan1_FinalVar + ',datalist{i},'_scan2_FinalVar)/2;'];
    eval(str);
    save(strcat(output_file,'\',datalist{i},'_FinalVar.mat'),strcat(datalist{i},'_FinalVar'));
end
%% 1.2 calculate variability for functional connectomes
clear all
load(strcat(Yourdata_path,'\functional_connectomes.mat'))
output_file = 'result\group_level\FCIV_Result_360_42';
mkdir(output_file)
FC_FinalVar_average8 = zeros(360,1);
tmp = FC(:,1);
for i = 1:8
    alldata = FC;
    alldata(:,1) = alldata(:,i);
    alldata(:,i) = tmp;
    [FinalVar] = fun_FinalVariability_trt(alldata,'pearson',strcat('FC_scan',int2str(i)),output_file);
    FC_FinalVar_average8 = FC_FinalVar_average8 + FinalVar;
end
FC_FinalVar_average8 = FC_FinalVar_average8/8;
save(strcat(output_file,'\FC_FinalVar.mat'),'FC_FinalVar_average8');

%% 1.3 plot inter-individual variability at the whole brain level
load('result\group_level\SIV_FinalVar_8variables_average_scans.mat')
load('result\group_level\FC_FinalVar_average8.mat')
datalist = {'SC','CO','PL','SD','CC','SA','CT','IM'};
for i = 1:8
    str = ['tmp = ',datalist{i},'_FinalVar;'];
    eval(str);
    tmp = inormal(tmp);
    surf_plot(tmp,'BNV_option_color__3_3.mat');
    pause(3);
end
% plot FC variability
tmp = inormal(FC_FinalVar_average8);
surf_plot(tmp,'BNV_option_color__3_3.mat');

%% 1.4 plot feature-by-feature correlational matrix
load('result\group_level\SIV_FinalVar_8variables_average_scans.mat')
% pre diss matrix
corr_matrix = zeros(8,8);
data(1,:) = zscore(SC_FinalVar);
data(2,:) = zscore(CO_FinalVar);
data(3,:) = zscore(PL_FinalVar);
data(4,:) = zscore(SD_FinalVar);
data(5,:) = zscore(CC_FinalVar);
data(6,:) = zscore(SA_FinalVar);
data(7,:) = zscore(CT_FinalVar);
data(8,:) = zscore(IM_FinalVar);
for i = 1:8
    for j = 1:8
        corr_matrix(i,j) = corr(data(i,:)',data(j,:)');
    end
end
imagesc(corr_matrix)

Z = linkage(data,'complete')
cutoff = median([Z(end-2,3) Z(end-1,3)]);
dendrogram(Z,'ColorThreshold',cutoff)


for i = 1:8
    corr(FC_FinalVar_average8,data(i,:)')
end






