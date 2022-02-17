function [FinalVar] = fun_FinalVariability_trt(alldata, distance, fname, output_path)
%-------------------------------------------------------------------------%
%   Caclulate inter-individual variability of brain connectome
%   Input:
%   alldata   - The connectome data, N*M cell (N:subjects numbers; M:test-retest times)
%             - each cell store a n*n brain connectome
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


data = alldata(:,1);
trt_num = length(alldata(1,:));
% Inter-individual Varability
node_num = length(data{1,1}(:,1));
node_begin = 1;
node_end = 360;
Sum_Sim = zeros(1,node_num);
Var = zeros(node_num,1);
subs_num = length(data);
for i = 1:node_num
    node_i = i;
    disp(node_i);
    n=0;
    for j = 1:subs_num-1
        for k = j+1:subs_num
            if j==k
                continue;
            end
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
            Sum_Sim(1,i) = Sum_Sim(1,i) + Corr_value;
            n = n+1;
        end 
    end
    Var(i,1) = 1 - (Sum_Sim(1,i)/n);
end
filename1 = strcat(fname,'_Var');
str = [filename1,'= Var;'];
eval(str);
dir=strcat(output_path,'\',fname,'_Var.mat');
save(dir,strcat(filename1));

% Intra-individual Varability
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
        IntraVar_subjects(n,i) = 1 - (IntraVar_subjects(n,i)/count);
    end
end
IntraVar = mean(IntraVar_subjects)';

filename2 = strcat(fname,'_IntraVar');
str = [filename2,'= IntraVar;'];
eval(str);
dir=strcat(output_path,'\',fname,'_IntraVar.mat');
save(dir,strcat(filename2));

stats=regstats(Var,IntraVar,'linear');
FinalVar = stats.beta(1) + stats.r;

filename3 = strcat(fname,'_FinalVar');
str = [filename3,'= FinalVar;'];
eval(str);
dir=strcat(output_path,'\',fname,'_FinalVar.mat');
save(dir,strcat(filename3));











