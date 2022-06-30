## Structural-Insight-into-Individual-Functional-Variability

This repository provides code and intermediate data that support the findings of the article entitled "Structural insight into the individual variability architecture of the functional brain connectome" by Sun et al., 2022, NeuroImage, [https://www.sciencedirect.com/science/article/pii/S1053811922005067](https://www.sciencedirect.com/science/article/pii/S1053811922005067)

If you use the code and/or data of this repository, please reference our work: Sun L, Liang X, Duan D, et al. Structural insight into the individual variability architecture of the functional brain connectome[J]. NeuroImage, 2022: 119387.


### Data
- Parcellation : Glasser 360 atlas <sup>[1]</sup>.
- SystemID_in_Glasser360 : The hierarchical label of each brain region. 1 primary, 2 unimodal, 3 heteromodal, 4 paralimbic <sup>[2,3]</sup>. 
- Behavior: [Due to the restricted behavioral data usage imposed by the HCP](https://www.humanconnectome.org/study/hcp-young-adult/document/restricted-data-usage), the individual weights for the behavioral dimensions cannot be made publicly available. We thank Dr. Ye Tian for generously sharing those preprocessed behavioral data <sup>[4]</sup>.
- plot_surface: Surface maps and Colorbar maps. Brain map were visualized on the inflated cortical 32K surface <sup>[1]</sup> using BrainNet Viewer <sup>[5]</sup>.
- group_networks.mat: Group-level Functional connectome(FC) and structural connectomes (SCs) of The HCP TRT dataset (subjects averaged, scans averaged).
- group_networks_1012.mat: Group-level FC and SCs of The HCP S1200 dataset (subjects averaged, scans averaged).
- mean_areal_Distortion.mat: The subject-averaged surface deformation map that occurred in cross-subject registration.
- MeanCBF_data360.mat: The regional cerebral blood flow pattern <sup>[6]</sup>.

### Code
- fig2_Variability_for_all_connectomes.m : Estimating Interindividual Variability Patterns at the Group Level
- fig3_PCA_results.R : Principal Component Analysis
- fig3_SVR_results.m : Predicting Interindividual FC Variability Using a Multivariate Prediction Model
- fig4_MediationAnalysis_and_StructuralFunctionalCoupling.m : Calculating Direct SC-FC Coupling and Performing [Mediation Analysis](https://github.com/canlab/MediationToolbox)
- fig5_Individual_deviation.m : Estimating Individual Uniqueness at the Individual Level
- fig6_Behavioral_association.m : Relevance for Cognition and Behavioral Performance
- figS_Validation.m : Relevance for Cognition and Behavioral Performance
- function : [PLS analysis toolbox](https://github.com/danizoeller/myPLS) and several MATLAB functions
- spintest : Spatial Permutation Testing

### Result
1. Group level （group-level results of the HCP TRT dataset）
   - FC_FinalVar_average8.mat ：session-averaged interindividual functional variability
   - PC1.mat ：session-averaged principal interindividual structural variability
   - PC1_Var.mat ：session-averaged principal structural variability estimated by SC variability without regressing out intraindividual variation
   - SIV_FinalVar_8variables_average_scans.mat ：SC variability with regressing out intraindividual variation
   - SIV_Var_8variables_average_scans.mat ：SC variability without regressing out intraindividual variation
   - finalVar_CorrMatrix.mat ：feature-feature correlation matrix
   - fit_FCIV_SVR.mat ：predicted FC variability across whole brain and in four hierarchical systems
   - fit_FCIV_SVR_vE7.mat ：predicted FC variability in seven cytoarchitectonic classes
   - group_pre_FC_r2.mat ：the fitted adjusted R<sup>2</sup>, characterize the regional SC-FC coupling
2. Individual level (individual-level results of the HCP TRT dataset）
   - FC_FinalDeviation_session*.mat : individual FC deviation in a given session
   - FC_FinalDeviation_session_average.mat : individual FC deviation averaged across sessions
   - forPCA.mat : individual SC deviation
   - PC1_Deviation_42.mat : individual principal SC deviation in any given session and averaged across sessions
   - fit_FC_IV_SVR.mat : predicted FC deviation
   - results_Corr : the spatial relationships between the functional and structural deviation maps using correlational analysis
   - results_SVR : the spatial relationships between the functional and structural deviation maps using predictive models
3. Group level S1200 (individual-level results of the HCP S1200 dataset）
4. Individual level S1200 (individual-level results of the HCP S1200 dataset）

### Reference
1. *Glasser, M.F., Coalson, T.S., Robinson, E.C., Hacker, C.D., Harwell, J., Yacoub, E., Ugurbil, K., Andersson, J., Beckmann, C.F., Jenkinson, M., et al. (2016). A multi-modal parcellation of human cerebral cortex. Nature 536, 171-178. 10.1038/nature18933.*
2. *Mesulam, M.M. (1998). From sensation to cognition. Brain 121, 1013-1052. 10.1093/brain/121.6.1013.*
3. *Liu, J., Xia, M., Wang, X., Liao, X., and He, Y. (2020). The spatial organization of the chronnectome associates with cortical hierarchy and transcriptional profiles in the human brain. Neuroimage 222, 117296. 10.1016/j.neuroimage.2020.117296.*
4. *Tian, Y., Margulies, D.S., Breakspear, M., and Zalesky, A. (2020). Topographic organization of the human subcortex unveiled with functional connectivity gradients. Nat Neurosci 23, 1421-1432. 10.1038/s41593- 020-00711-6.*
5. *Xia, M., Wang, J., and He, Y. (2013). BrainNet Viewer: a network visualization tool for human brain connectomics. PLoS One 8, e68910. 10.1371/journal.pone.0068910.*
6. *Satterthwaite T.D., Shinohara R.T., Wolf D.H, et al. (2014) Impact of puberty on the evolution of cerebral perfusion during adolescence. Proceedings of the National Academy of Sciences 111, 8643-8648. 10.1073/pnas.1400178111*

