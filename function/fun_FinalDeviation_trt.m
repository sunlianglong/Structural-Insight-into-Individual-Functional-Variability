function fun_FinalDeviation_trt(input_data,distance,fname,output_path)
%-------------------------------------------------------------------------%
%   Caclulate inter-individual deviation of brain connectome
%   Input:
%   input_data   - The connectome data, N*M cell (N:subjects numbers; M:test-retest times)
%                - each cell store a n*n brain connectome
%   distance  - The Similarity measure
%               - cosine similarity
%               - pearson coefficient
%   output_path
%   fname     - The prefix of the output variable
%-------------------------------------------------------------------------%
%   Lianglong Sun, version 1.1,20201010.
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

if strcmp(fname,'FC_run_1_4')
    alldata = input_data(:,1:4);
elseif strcmp(fname,'FC_run_5_8')
    alldata = input_data(:,5:8);
else
    alldata = input_data;
end
trt_num = length(alldata(1,:));
node_num = length(alldata{1,1}(:,1));
node_begin = 1;
node_end = 360;

% Individual Deviation
disp('calculating the Inter-individual Deviation ...')
for session = 1:trt_num
    data = alldata(:,session);
    subs_num = length(data);
    expr = ['Deviation_' fname '_session' num2str(session) ' = zeros(subs_num,node_num);'];
    eval(expr);
    for i = 1:node_num
        node_i = i;
        disp(node_i);
        n=0;
        for j = 1:subs_num
            tmp=0;
            for k = 1:subs_num
                if strcmp(distance,'pearson')
                    Corr_value = corr(data{j,1}(node_begin:node_end,node_i),data{k,1}(node_begin:node_end,node_i));
                end
                if strcmp(distance,'cosine')
                    tmp1 = data{j,1}(node_begin:node_end,node_i);
                    tmp2 = data{k,1}(node_begin:node_end,node_i);
                    Corr_value = 1 - squareform(pdist([tmp1,tmp2]','cosine'));
                    Corr_value = Corr_value(1,2);
                end
                if isnan(Corr_value)
                    Corr_value = 0;
                end
                tmp = tmp + (Corr_value);
                n = n+1;
            end
            tmp = tmp/(subs_num-1);
            expr = ['Deviation_' fname '_session' num2str(session) '(j,i) = 1 - tmp;'];
            eval(expr);
        end
    end
end

%Intra-individual Variability
disp('calculating the Intra-individual Variability ...')
IntraVar_subjects = zeros(subs_num,node_num);
for n = 1:subs_num
    disp(n);
    for i = 1:node_num
        node_i = i;
        count=0;
        for j = 1:trt_num-1
            for k = j+1:trt_num
                if strcmp(distance,'pearson')
                    Corr_value = corr(alldata{n,j}(node_begin:node_end,node_i),alldata{n,k}(node_begin:node_end,node_i));
                end
                if strcmp(distance,'cosine')
                    tmp1 = alldata{n,j}(node_begin:node_end,node_i);
                    tmp2 = alldata{n,k}(node_begin:node_end,node_i);
                    Corr_value = 1 - squareform(pdist([tmp1,tmp2]','cosine'));
                    Corr_value = Corr_value(1,2);
                end
                if isnan(Corr_value)
                    Corr_value = 0;
                end
                IntraVar_subjects(n,i) = IntraVar_subjects(n,i) + Corr_value;
                count = count+1;
            end 
        end
        IntraVar_subjects(n,i) = 1 - abs((IntraVar_subjects(n,i)/count));
    end
end

%Final individual Deviation
disp('calculating the Final individual Deviation ...')

expr = ['FinalDeviation_' fname '_session_average = zeros(subs_num,node_num);'];
eval(expr);
for session = 1:trt_num
    expr = ['FinalDeviation_' fname '_session' num2str(session) '= zeros(subs_num,node_num);'];
    eval(expr);
    for n = 1:subs_num
        disp(n);
        expr = ['Deviation = Deviation_' fname '_session' num2str(session) ';'];
        eval(expr);
        stats=regstats(Deviation(n,:),IntraVar_subjects(n,:),'linear');
        expr = ['FinalDeviation_' fname '_session' num2str(session) '(n,:) = abs(stats.beta(1) + stats.r);'];
        eval(expr);
    end
    expr = ['FinalDeviation_' fname '_session_average = FinalDeviation_' fname '_session_average + FinalDeviation_' fname '_session' num2str(session) ';'];
    eval(expr);
end
expr = ['FinalDeviation_' fname '_session_average = FinalDeviation_' fname '_session_average/' num2str(trt_num) ';'];
eval(expr);

% save data
for session = 1:trt_num
    dir=strcat(output_path,'\',fname,'_Deviation_session',num2str(session),'.mat');
    save(dir,strcat('Deviation_', fname, '_session',num2str(session)));
    dir=strcat(output_path,'\',fname,'_FinalDeviation_session',num2str(session),'.mat');
    save(dir,strcat('FinalDeviation_', fname, '_session',num2str(session)));
end
dir=strcat(output_path,'\',fname,'_IntraVar.mat');
save(dir,'IntraVar_subjects');
dir=strcat(output_path,'\',fname,'_FinalDeviation_session_average.mat');
save(dir,strcat('FinalDeviation_', fname, '_session_average'));
