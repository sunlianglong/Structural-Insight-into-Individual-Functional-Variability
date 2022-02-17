library(sparcl)
library(MASS)
library("R.matlab")
library("FactoMineR")
library("factoextra")
data <-file.path('result\\group_level\\SIV_FinalVar_8variables_average_scans_v6.mat')
#data <-file.path('result\\S1200_group_level\\Structural_8var_1012_v6.mat')
PCAdata <- readMat(data)
res.pca = PCA(PCAdata, scale.unit = TRUE, graph = TRUE)
eig.val <- get_eigenvalue(res.pca)
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
# Contributions of variables to PC1
fviz_contrib(res.pca, choice = "var", axes = 1, top = 10)


res.pca$var$contrib
