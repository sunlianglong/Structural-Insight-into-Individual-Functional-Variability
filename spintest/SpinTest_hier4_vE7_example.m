clear all
%% load atlas and data
% load atlas 
load('data\SystemID_in_Glasser360\hier4_atlas.mat')
load('data\SystemID_in_Glasser360\vE_atlas.mat')
load('data\SystemID_in_Glasser360\Yeo7_atlas.mat')
LV=gifti('data\Parcellation\Glasser180_210P_L.func.gii'); % in FS_LR_32k space
RV=gifti('data\Parcellation\Glasser180_210P_R.func.gii'); 
GlasserLR=[LV.cdata; RV.cdata];
LabelLR=zeros(size(GlasserLR));
% load data
load('result\group_level\FC_FinalVar_average8.mat')
load('result\group_level\PC1.mat')
load('result\group_level\fit_FCIV_SVR.mat')
load('result\group_level\group_pre_FC_r2.mat')
load('result\group_level\SIV_FinalVar_8variables_average_scans.mat')

%% Spatial Perm
datalist = {'SC','CO','PL','CT','IM','CC','SD','SA'};
Perm_data_lib = [SC_FinalVar,CO_FinalVar,PL_FinalVar,IM_FinalVar,CT_FinalVar,SD_FinalVar,CC_FinalVar,SA_FinalVar];

i=1;    
% task FC variability as an example
Flag=datalist{i};
Flag = 'PL'
    
    mkdir(strcat('SpinTest\Inter_individual_Variability\',Flag));
    dataDir = strcat('SpinTest\Inter_individual_Variability\',Flag);
    Perm_data = zscore(PL);

    %%% Using the spin test code in SpinTest\SpinTestCode_Liu2020NeuroImage, we
    %%% generate 10000 spatial permutation maps. Here, take 100 maps for example.

    perm_number = 10000;
    % perm_number = 100;
    Perm_360_Results = zeros(360,perm_number);
    for k=1:perm_number
        disp(k);
    %     rand_file=['SpinTest\PermLabel\Rand_' sprintf('%05d.mat',k)];
        rand_file=['D:\9419HeLab\Brain_Matlab\HCP\Analyze_Script\SpinTest\Liu-2019-master\SpinTest\PermLabel\Rand_' sprintf('%05d.mat',k)];

        load(rand_file);
        Rand_Label = [LNewLabel;RNewLabel];
        for i=1:360
            index = find(GlasserLR==i);
            perm_roi = mode(Rand_Label(index));
            if perm_roi == 0
                Perm_360_Results(i,k)=0;
                continue;
            end
            Perm_360_Results(i,k) = Perm_data(perm_roi);
        end
    end

    %% for 4 hier
    null_models = zeros(perm_number,4);
    for k = 1:perm_number
        tmp = Perm_360_Results(:,k);
        null_models(k,1) = mean(tmp(final_hier_360==1));
        null_models(k,2) = mean(tmp(final_hier_360==2));
        null_models(k,3) = mean(tmp(final_hier_360==3));
        null_models(k,4) = mean(tmp(final_hier_360==4));
    end
    for i = 1:4
        mean_hier4(i) = mean(Perm_data(final_hier_360==i));% mean value in 4 hier 
    end
    for i = 1:4
        % mean R-square for real community ii
        x = mean_hier4(i);
        % mean R-square for permuted community ii
        mu = mean(squeeze(null_models(:,i)));
        % standard devitation of R-square for permuted community ii
        sigma = std(squeeze(null_models(:,i)));
        % z-score
        z_values(i) = (x - mu) / sigma;
    end

    for i=1:4
        data = null_models(:,i);
        if mean_hier4(i)>0
            mean_hier4_p(i) =  numel(find(data > mean_hier4(i))) / perm_number;
        else
            mean_hier4_p(i) =  numel(find(data < mean_hier4(i))) / perm_number;
        end
    end
    data_hier4 = [z_values;mean_hier4_p];
    save(strcat(dataDir,'\forBar_hier4.mat'),'data_hier4');


    % plot bar : vE7
    load(strcat(dataDir, '\forBar_vE7.mat'));
    plot_data = data_vE7;
    figure
    set(gca,'FontSize',28);
    set(gcf,'position',[100 100 400 500]);
    hold on
    for i = 1:7
        [plot_data_sort,plot_data_sort_Index] = sort(plot_data(1,:),'descend');
    end
    b = bar(plot_data_sort(1,:),'FaceColor',[.8 .8 .8]);
    data_max = max(plot_data_sort(1,:));
    data_min = min(plot_data_sort(1,:));
    ylim([data_min - 1,data_max + 1]);
    set(gca,'xtick',[1:7],'xticklabel',plot_data_sort_Index);
    b.FaceColor = 'flat';
    for i = 1:length(plot_data)
        if plot_data(2,plot_data_sort_Index(i)) < 0.05
                  b.CData(i,:) = [.4 0.58 .92];
%                    b.CData(i,:) = [.9 0.4 .4];
        end
    end
    box off
    print(gcf, strcat(dataDir,'\',Flag,'_InterVar_spintest_vE7.png'),'-r600','-dpng');





