function GetRotateLabel(SphereSurf, Label, OutFile)

L_SpSurf=gifti(SphereSurf{1});
R_SpSurf=gifti(SphereSurf{2});
NumV=size(L_SpSurf.vertices, 1);
P=zeros(12, 1);
%P(7:9)=1;
P(4:6, 1)=2*pi*rand(3, 1);
LM=spm_matrix(P, 'R');
P(4:6, 1)=2*pi*rand(3, 1);
RM=spm_matrix(P, 'R');

LOldCoord=L_SpSurf.vertices;
ROldCoord=R_SpSurf.vertices;
LOldCoordV=[LOldCoord, ones(NumV, 1)];
ROldCoordV=[ROldCoord, ones(NumV, 1)];

LNewCoordV=(LM*LOldCoordV')';
RNewCoordV=(RM*ROldCoordV')';

LNewCoord=LNewCoordV(:, 1:3);
RNewCoord=RNewCoordV(:, 1:3);

%L_LabelV=gifti(Label{1});
%R_LabelV=gifti(Label{2});
LOldLabel=uint16(Label{1});
ROldLabel=uint16(Label{2});

LNewLabel=FindNewLabel(LOldCoord, LNewCoord, LOldLabel);
RNewLabel=FindNewLabel(ROldCoord, RNewCoord, ROldLabel);

save(OutFile, 'LNewLabel', 'RNewLabel');

function NewLabel=FindNewLabel(OldCoord, NewCoord, OldLabel)
NumV=size(OldLabel, 1);
NewLabel=uint16(zeros(NumV, 1));
for i=1:NumV
    new_coord=NewCoord(i, :);
    D=bsxfun(@minus, OldCoord, new_coord);
    Dis=sqrt(sum(D.^2, 2));
    [~, ind]=min(Dis);
    NewLabel(i, 1)=OldLabel(ind, 1);
end