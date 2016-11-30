clear;

load('data.mat');

[mem cent] = kShape(FluoTraces, 16);

filemname = 'kshape.mat';
save(filename);