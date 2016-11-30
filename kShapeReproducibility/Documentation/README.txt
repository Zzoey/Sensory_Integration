###########################
####### DIRECTORIES #######
###########################

List of directories: 

“Code“				 - Contains the datasets and the source code for all methods and distance measures compared in our paper 
“Documentation“			 - Contains this README file, with details on how to run the code and how to reproduce all tables in our paper
“Friedman-Nemeyi Test"		 - Contains code to run the Friedman and Nemenyi statistical tests
“Paper"				 - Contains our paper in pdf
“Results"			 - Contains the spreadsheet with all our experimental results 

########################
####### DATASETS #######
########################

Under “Code/DATASETS" directory we have the 48 datasets used in our experiments. 

We present them here sorted alphabetically. This is the sequence used in the output files of our code too (e.g., accuracy value in line 20 corresponds to dataset “Haptics").

1. 50words2. Adiac3. Beef4. CBF5. Car6. ChlorineConcentration7. CinC_ECG_torso8. Coffee9. Cricket_X10. Cricket_Y11. Cricket_Z12. DiatomSizeReduction13. ECG20014. ECGFiveDays15. FaceAll16. FaceFour17. FacesUCR18. Fish19. Gun_Point20. Haptics21. InlineSkate22. Insect23. ItalyPowerDemand24. Lighting225. Lighting726. MALLAT27. MedicalImages28. Motes29. NonInvasiveFatalECG_Thorax130. NonInvasiveFatalECG_Thorax231. OSULeaf32. OliveOil33. Plane34. SonyAIBORobotSurface35. SonyAIBORobotSurfaceII36. StarLightCurves37. SwedishLeaf38. Symbols39. Synthetic_control40. Trace41. TwoLeadECG42. Two_Patterns43. Wafer44. WordsSynonyms45. Yoga46. uWaveGestureLibrary_X47. uWaveGestureLibrary_Y48. uWaveGestureLibrary_Z

########################
####### TUNE DTW #######
########################

For all datasets we have computed their optimal parameter for the cDTW distance measure. Code performs leave-one-out classification on the training set of each dataset for all possible parameters (i.e., from 0% to 100% of the time-series length).

Run for *all* datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r “TuningDTWonTRAIN(1,48)" -logfile nohup_TuningDTWonTRAIN_1_48.out </dev/null &

or for only the 25th dataset:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r “TuningDTWonTRAIN(25,25)" -logfile nohup_TuningDTWonTRAIN_25_25.out </dev/null &

NOTE: 

Find on “TuningDTWonTRAIN.m" the line “matlabpool close force local; matlabpool local 12;" and change 12 to the number of cores you have (up to 12).

####################################
####### DISSIMILARITY MATRIX #######
####################################

For all datasets we have computed their dissimilarity matrices for ED, SBD, and cDTW5. These matrices are used as input for Hierarchical, Spectral, and PAM methods.

To recompute these matrices:

For ED:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "DMComputation(1,48,1)" -logfile nohup_DMComputation_1_48_1.out </dev/null &

For SBD:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "DMComputation(1,48,2)" -logfile nohup_DMComputation_1_48_2.out </dev/null &

For cDTW5:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "DMComputation(1,48,3)" -logfile nohup_DMComputation_1_48_3.out </dev/null &

NOTE: 

“DMComputation.m" calls 3 files depending on which distance you want to compute: “ParallelDM_ED.m", “ParallelDM_NCCc.m", and “ParallelDM_DTW.m". As they use the Parallel Toolbox you need to specify in each one of these files how many cores you want to use (up to 12):

e.g., find lines “matlabpool close force local; matlabpool local 12;"

#########################################################
####### 1-NN CLASSIFICATION FOR DISTANCE MEASURES #######
#########################################################

Run without LBKeogh pruning/lower bounding method:

Distance choices:

1. ED
2. NCCc (SBD)
3. NCCc_fftnopower2 (SBD_NoPow2)
4. NCCc_nofft (SBD_NoFFT)
5. DTW
6. cDTWOptimal
7. cDTW5
8. cDTW10

Run for all datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r “ParallelRunOneNN(1,48,Distance#)" -logfile nohup_ParallelRunOneNN_1_48_Distance#.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r “ParallelRunOneNN(25,25,Distance#)" -logfile nohup_ParallelRunOneNN_25_25_Distance#.out </dev/null & 

Run with LBKeogh pruning/lower bounding method:

Distance choices:

1. DTWLBKeogh
2. cDTWOptimalLBKeogh
3. cDTW5LBKeogh
4. cDTW10LBKeogh

Run for all datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r “ParallelRunOneNNLBKeogh(1,48,Distance#)" -logfile nohup_ParallelRunOneNNLBKeogh_1_48_Distance#.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r “ParallelRunOneNNLBKeogh(25,25,Distance#)" -logfile nohup_ParallelRunOneNNLBKeogh_25_25_Distance#.out </dev/null & 

NOTE #1: For cDTWOptimal we have already integrated in our code the values from “Tune DTW" code.

NOTE #2: Depending on the # of cores you will use in parallelization, you might have to multiple/divide the runtime of distance measures. However, the ratios (as we report them on the paper should be similar).

#######################################
####### HIERARCHICAL CLUSTERING #######
#######################################

Single linkage:

Run for *ALL* datasets:

With ED:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalSingle(1,48,1)" -logfile nohup_ClusteringHierarchicalSingle_1_48_1.out </dev/null &

With SBD:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalSingle(1,48,2)" -logfile nohup_ClusteringHierarchicalSingle_1_48_2.out </dev/null &

With cDTW5
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalSingle(1,48,3)" -logfile nohup_ClusteringHierarchicalSingle_1_48_3.out </dev/null &


Average linkage:

Run for *ALL* datasets:

With ED:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalAverage(1,48,1)" -logfile nohup_ClusteringHierarchicalAverage_1_48_1.out </dev/null &

With SBD:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalAverage(1,48,2)" -logfile nohup_ClusteringHierarchicalAverage_1_48_2.out </dev/null &

With cDTW5:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalAverage(1,48,3)" -logfile nohup_ClusteringHierarchicalAverage_1_48_3.out </dev/null &

Complete linkage:

Run for *ALL* datasets:

With ED:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalComplete(1,48,1)" -logfile nohup_ClusteringHierarchicalComplete_1_48_1.out </dev/null &

With SBD:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalComplete(1,48,2)" -logfile nohup_ClusteringHierarchicalComplete_1_48_2.out </dev/null &

With cDTW5:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalComplete(1,48,3)" -logfile nohup_ClusteringHierarchicalComplete_1_48_3.out </dev/null &

Example for the 25th dataset:

With cDTW5:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringHierarchicalComplete(25,25,3)" -logfile nohup_ClusteringHierarchicalComplete_25_25_3.out </dev/null &


###################################
####### SPECTRAL CLUSTERING #######
###################################

Run for *ALL* datasets:

With ED:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringSpectral(1,48,1)" -logfile nohup_ClusteringSpectral_1_48_1.out </dev/null &

With SBD:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringSpectral(1,48,2)" -logfile nohup_ClusteringSpectral_1_48_2.out </dev/null &

With cDTW5:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringSpectral(1,48,3)" -logfile nohup_ClusteringSpectral_1_48_3.out </dev/null &


Example for 1 dataset:

For dataset 25:

With cDTW5:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringSpectral(25,25,3)" -logfile nohup_ClusteringSpectral_25_25_3.out </dev/null &


########################################
####### PAM/k-medoids CLUSTERING #######
########################################

Run for *ALL* datasets:

With ED:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringPAM(1,48,1)" -logfile nohup_ClusteringPAM_1_48_1.out </dev/null &

With SBD:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringPAM(1,48,2)" -logfile nohup_ClusteringPAM_1_48_2.out </dev/null &

With cDTW5:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringPAM(1,48,3)" -logfile nohup_ClusteringPAM_1_48_3.out </dev/null &


Example for 1 dataset:

For dataset 25:

With cDTW5:
nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringPAM(25,25,3)" -logfile nohup_ClusteringPAM_25_25_3.out </dev/null &


#############$$$$$#################
####### k-AVG+ED CLUSTERING #######
##################$$$$$############

Run for *ALL* datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKMeans(1,48)" -logfile nohup_ClusteringKMeans_1_48.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKMeans(25,25)" -logfile nohup_ClusteringKMeans_25_25.out </dev/null &

#############$$$$$##################
####### k-AVG+SBD CLUSTERING #######
##################$$$$$#############

Run for *ALL* datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKMeansSBD(1,48)" -logfile nohup_ClusteringKMeansSBD_1_48.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKMeansSBD(25,25)" -logfile nohup_ClusteringKMeansSBD_25_25.out </dev/null &

#############$$$$$##################
####### k-AVG+DTW CLUSTERING #######
##################$$$$$#############

Run for *ALL* datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKMeansDTW(1,48)" -logfile nohup_ClusteringKMeansDTW_1_48.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKMeansDTW(25,25)" -logfile nohup_ClusteringKMeansDTW_25_25.out </dev/null &

##############################
####### KSC CLUSTERING #######
##############################

Run for *ALL* datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKSC(1,48)" -logfile nohup_ClusteringKSC_1_48.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKSC(25,25)" -logfile nohup_ClusteringKSC_25_25.out </dev/null &

################################
####### k-DBA CLUSTERING #######
################################

Run for *ALL* datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKDBA(1,48)" -logfile nohup_ClusteringKDBA_1_48.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKDBA(25,25)" -logfile nohup_ClusteringKDBA_25_25.out </dev/null &

######################################
####### k-Shape+DTW CLUSTERING #######
######################################

Run for *ALL* datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKShapeDTW(1,48)" -logfile nohup_ClusteringKShapeDTW_1_48.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKShapeDTW(25,25)" -logfile nohup_ClusteringKShapeDTW_25_25.out </dev/null &

##################################
####### k-Shape CLUSTERING #######
##################################

Run for *ALL* datasets:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r “ClusteringKShape(1,48)" -logfile nohup_ClusteringKShape_1_48.out </dev/null &

Run for the 25th dataset only:

nohup /usr/local/MATLAB/R2012b/bin/matlab -singleCompThread -r "ClusteringKShape(25,25)" -logfile nohup_ClusteringKShape_25_25.out </dev/null &

#########################################
####### Better/Equal/Worse Tables #######
#########################################

To produce Table 6, Table 7, and Table 8 in our “Experiments.xlsx":

- Copy all values from first 8 columns of Table 1 (without dataset names or header) to a ’dists’ matrix in MATLAB

For Table 6 run:

- comparisons=[];for j=1:8 for k=1:8 w=0; for i=1:48 if (dists(i,j)>dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

For Table 7 run:

- comparisons=[];for j=1:8 for k=1:8 w=0; for i=1:48 if (dists(i,j)==dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

For Table 8 run:

- comparisons=[];for j=1:8 for k=1:8 w=0; for i=1:48 if (dists(i,j)<dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

#

To produce Table 15, Table 16, and Table 17 in our “Experiments.xlsx":

- Copy all values from Table 10 (without dataset names or header) to a ’dists’ matrix in MATLAB

For Table 15 run:

- comparisons=[];for j=1:7 for k=1:7 w=0; for i=1:48 if (dists(i,j)>dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

For Table 16 run:

- comparisons=[];for j=1:7 for k=1:7 w=0; for i=1:48 if (dists(i,j)==dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

For Table 17 run:

- comparisons=[];for j=1:7 for k=1:7 w=0; for i=1:48 if (dists(i,j)<dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

#

To produce Table 23, Table 24, and Table 25 in our “Experiments.xlsx":

- Copy all values from Table 19 (without dataset names or header) to a ’dists’ matrix in MATLAB

For Table 23 run:

- comparisons=[];for j=1:16 for k=1:16 w=0; for i=1:48 if (dists(i,j)>dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

For Table 24 run:

- comparisons=[];for j=1:16 for k=1:16 w=0; for i=1:48 if (dists(i,j)==dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

For Table 25 run:

- comparisons=[];for j=1:16 for k=1:16 w=0; for i=1:48 if (dists(i,j)<dists(i,k)) w=w+1; comparisons(j,k)=w;end;end;end;end;

#############################
####### Wilcoxon Test #######
#############################

To produce Table 4 and Table 5 in our “Experiments.xlsx":

- Copy all values from first 8 columns of Table 1 (without dataset names or header) to a ’dists’ matrix in MATLAB

For (Table 4) binary result run:

- tests=[]; for i=1:8 for j=1:8 [pvalue h] = signrank(dists(:,i),dists(:,j),0.01); tests(i,j)=h; end;end;

For (Table 5) pvalues results:

- tests=[]; for i=1:8 for j=1:8 [pvalue h] = signrank(dists(:,i),dists(:,j),0.01); tests(i,j)=pvalue; end;end;

#

To produce Table 13 and Table 14 in our “Experiments.xlsx":

- Copy all values from Table 10 (without dataset names or header) to a ’dists’ matrix in MATLAB

For (Table 13) binary result run:

- tests=[]; for i=1:7 for j=1:7 [pvalue h] = signrank(dists(:,i),dists(:,j),0.01); tests(i,j)=h; end;end;

For (Table 14) pvalues results:

- tests=[]; for i=1:7 for j=1:7 [pvalue h] = signrank(dists(:,i),dists(:,j),0.01); tests(i,j)=pvalue; end;end;

#

To produce Table 21 and Table 22 in our “Experiments.xlsx":

- Copy all values from Table 19 (without dataset names or header) to a ’dists’ matrix in MATLAB

For (Table 21) binary result run:

- tests=[]; for i=1:16 for j=1:16 [pvalue h] = signrank(dists(:,i),dists(:,j),0.01); tests(i,j)=h; end;end;

For (Table 22) pvalues results:

- tests=[]; for i=1:16 for j=1:16 [pvalue h] = signrank(dists(:,i),dists(:,j),0.01); tests(i,j)=pvalue; end;end;

######################################
####### Friedman/Nemenyi Tests #######
######################################

Under “Friedman-Nemeyi Test" directory we have the implementation of Friedman test followed by the post-hoc Nemenyi-test.

To produce Table 9 (used in Figure 6 in our paper) in our “Experiments.xlsx" run:

- perl friedman-nemenyi-test.pl distances.data

- in distances.data we have the appropriate columns from Table 1 of our Experiments.xlsx"

#

To produce Table 18 (used in Figure 8 in our paper) in our Experiments.xlsx" run:

- perl friedman-nemenyi-test.pl scalablemethods.data

- in scalablemethods.data we have the appropriate columns from Table 10 of our Experiments.xlsx"

#

To produce Table 26 (used in Figure 9 in our paper) in our Experiments.xlsx" run:

- perl friedman-nemenyi-test.pl nonscalablemethods.data

- in nonscalablemethods.data we have the appropriate columns from Table 19 of our Experiments.xlsx"
