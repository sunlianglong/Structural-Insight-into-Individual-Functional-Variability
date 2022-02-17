load R1R2_ind.mat % Index for all nodes, here R1R2_ind is a 360x1 vector

PDir=pwd;
SphereSurf=cell(2,1);
SphereSurf{1}=fullfile(PDir, 'Q1-Q6_RelatedParcellation210.L.sphere.32k_fs_LR.surf.gii');
SphereSurf{2}=fullfile(PDir, 'Q1-Q6_RelatedParcellation210.R.sphere.32k_fs_LR.surf.gii');

LV=gifti(fullfile(PDir, 'Glasser180_210P_L.func.gii')); % FS_LR 32k
RV=gifti(fullfile(PDir, 'Glasser180_210P_R.func.gii'));
NumHemi=size(LV.cdata, 1);
NumNode=360;

%% Spin Test
GlasserLR=[LV.cdata; RV.cdata];
LabelLR=zeros(size(GlasserLR));

for i=1:NumNode
    ind=GlasserLR==i;
    LabelLR(ind, 1)=R1R2_ind(i, 1);
end
Label=cell(2,1);
Label{1}=LabelLR(1:NumHemi, 1);
Label{2}=LabelLR(NumHemi+1:end, 1);

NumPerm=10000;
mkdir('PermLabel');
parfor i=1:NumPerm
    OutFile=fullfile(PDir, 'PermLabel', sprintf('Rand_%.5d', i));
    fprintf('Performing %s\n', OutFile);
    GetRotateLabel(SphereSurf, Label, OutFile);
end
%%
