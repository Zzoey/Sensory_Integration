clc;
clear;
close all;

%% Load Data

load('All2.mat');



%temp = I_mod(:,:,1);

%X=data.X;

%% Run DBSCAN 

epsilon=0.3;
MinPts=10;
IDX=DBSCAN(X,epsilon,MinPts);


%% Plot Results

PlotClusterinResult(X, IDX);
title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
