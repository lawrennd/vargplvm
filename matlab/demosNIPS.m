%------------ MOCAP ------------------------------%
%% Matern
experimentNo=33; 
itNo = [300 300 400 200 200 300 400 400];
dynamicKern = {'matern32', 'white', 'bias'};
vardistCovarsMult = 0.24;
demCmu35gplvmVargplvm3;

%% RBF
experimentNo=34; 
itNo = [300 300 400 200 200 300 400 400];
dynamicKern = {'rbf', 'white', 'bias'};
vardistCovarsMult = 0.152;
tic;demCmu35gplvmVargplvm3; toc


%%------------  DOG  GENERATION --------------------------------%
%--- TRAINING
 dataSetName = 'dog';
 experimentNo=65;
 indPoints=-1;
 latentDim=35;
 fixedBetaIters=400;
 %reconstrIters = 2; % This does not play any role now, reconstruction is done later
 % 16K training iterations were used for the paper. However, even setting
 % this to a much lower number should not affect the results dramatically
 itNo=[1000 1000 1000 1000 1000 1000 500 500 500 500 1000 1000 1000 1000 1000 1000 1000 500 500]; %16000
 periodicPeriod = 2.8840;
 dynamicKern={'rbfperiodic','whitefixed','bias','rbf'};
 vardistCovarsMult=0.8; %or initial variational covariances
 whiteVar = 1e-6; % dynamic kernel's white variance
 dataSetSplit = 'custom';
 indTr = 1:54;
 indTs = 55:61;
 learnSecondVariance = 0;
 demHighDimVargplvm3
 
 
%----- RECONSTRUCTION
clear
dataSetName = 'dog';
experimentNo=65;
dataSetSplit = 'custom';
indTr = 1:54;
indTs = 55:61;
predWithMs = 1;
% 18K reconstruction iterations were used for the paper. However, even setting
% this to a much lower number should not affect the results dramatically
reconstrIters = 18000; 
doSampling = 0;
demHighDimVargplvmTrained


%%
%%------------ DOG RECONSTRUCTION

%------ TRAINING
 dataSetName = 'dog';
 experimentNo=61;
 diaryFile = ['LOG_demDogVargplvm' num2str(experimentNo) '.txt'];
 delete(diaryFile)
 diary(diaryFile)
 indPoints=-1;
 latentDim=35;
 fixedBetaIters=400;
 reconstrIters = 2;
 itNo=[1000 1000 1000 1000 1000 1000 500 500 500 500 1000 1000 1000 1000 1000 1000 1000 500 500]; %16000
 periodicPeriod = 4.3983;
 dynamicKern={'rbfperiodic','whitefixed','bias','rbf'};
 vardistCovarsMult=0.8;
 whiteVar = 1e-6;
 dataToKeep = 60;
 dataSetSplit = 'custom';
 indTr = [1:60];
 indTs = 60;
 learnSecondVariance = 0;
demHighDimVargplvm3

%------- PREDICTIONS  (generation)
clear; close all 
dataSetName = 'dog'; 
experimentNo=61; dataToKeep = 60; dataSetSplit = 'custom';
indTr = [1:60]; indTs = 60;
futurePred = 40; doSampling = 0; demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;
playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);

%-- You can also do supersampling
% dt = 0.103; subs=4; futurePred = 0:(dt/subs):(dt/subs)*(size(Ytr,1)-1)*subs; 
% demHighDimVargplvmTrained
% playMov(height, width, [0.03 subs], Varmu2, Ytr );




%%
%-------------  MISSA ------------------------------%



%%
%------------   OCEAN ---------------------------------%
 dataSetName = 'ocean';
 experimentNo=60;
 indPoints=-1;
 latentDim=20;
 fixedBetaIters=200; reconstrIters = 2000;
 itNo=[1000 2000 5000 8000 4000];
 dynamicKern={'rbf','white','bias'};
 whiteVar = 0.1;
 vardistCovarsMult=1.7;
 dataSetSplit = 'randomBlocks';
 demHighDimVargplvm3



