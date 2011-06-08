% DEMOSTOKEEP Log script, to load precomputed results.

% VARGPLVM

%--------------------    DOG  ------------------------------%
%% rbf + rbfperiodic with period = 3*true period with 60 frames to train
clear; close all 
dataSetName = 'dog'; 
experimentNo=61; dataToKeep = 60; dataSetSplit = 'custom';
indTr = [1:60]; indTs = 60;
futurePred = 40; doSampling = 0; demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;
playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);

dt = 0.103; subs=4; futurePred = 0:(dt/subs):(dt/subs)*(size(Ytr,1)-1)*subs; 
demHighDimVargplvmTrained
playMov(height, width, [0.03 subs], Varmu2, Ytr );
% Comments: !!! probably the best so far

%%
clear
dataSetName = 'dog';
experimentNo=65;
dataSetSplit = 'custom';
indTr = 1:54;
indTs = 55:61;
load demDogVargplvm65Pred
demHighDimVargplvmLoadPred
%--------------------


%-------------  MISSA -------------------------%

%% !!!!!!!!!!! FINAL
clear
experimentNo = 59;
dataSetName = 'missa';
dataSetSplit = 'custom';
dataSetSplit = 'blocks';
blockSize = 4;
msk = [48 63 78 86 96 111 118];
load demMissaVargplvm59Pred
demHighDimVargplvmLoadPred
% 12 lengthscales

%%

clear
experimentNo = 53;
dataSetName = 'missa';
dataSetSplit = 'custom';
cutP=round(288/(1.6));
indTr = [1:10 14:20 23:27 33:40 45:52 56:60 67:75 80:85 89:98];
indTs = [11:13 21:22 28:32 41:44 53:55 61:66 76:79 85:88];
load demMissaVargplvm53Pred
demHighDimVargplvmLoadPred
% 20 lengthscales

%%
clear
experimentNo = 58;
dataSetName = 'missa';
dataSetSplit = 'custom';
cutP=round(288/(1.6));
indTr = [1:10 14:20 23:27 33:40 45:52 56:60 67:75 80:85 89:100];
indTs = [11:13 21:22 28:32 41:44 53:55 61:66 76:79 85:88];
load demMissaVargplvm58Pred
demHighDimVargplvmLoadPred
% 20 lengthscales


%%
clear
dataSetName = 'missa';
experimentNo=27;
dataSetSplit = 'blocks';
blockSize = 4;
load demMissaVargplvm27Pred
demHighDimVargplvmLoadPred
% 10 lengthscales
%%




%--------------- OCEAN
%%
clear
dataSetName = 'ocean';
experimentNo=24;
dataSetSplit = 'randomBlocks';
load demOceanVargplvm24Pred
demHighDimVargplvmLoadPred
%%

clear
dataSetName = 'ocean';
experimentNo=24;
dataSetSplit = 'randomBlocks';
load demOceanVargplvm200Pred
demHighDimVargplvmLoadPred
%%





























%---------- OLD -------------------------------------------%
%% rbf + rbfperiodic with period = 2*true period
clear; close all 
dataSetName = 'dog';
experimentNo=51; dataSetSplit = 'custom';
indTr = [1:61];  indTs = 61;
futurePred = 30; doSampling = 0; demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;
playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);
% Comments: The head is a bit blurry



%% As above with more ind. pts
clear; close all 
dataSetName = 'dog';
experimentNo=56; dataSetSplit = 'custom';
indTr = [1:61];  indTs = 61;
futurePred = 30; doSampling = 0; demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;
playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);
% Comments: Not any better than above


%% rbf + rbfperiodic with period = 3*true period
clear; close all 
dataSetName = 'dog';
experimentNo=55; dataSetSplit = 'custom';
indTr = [1:61]; indTs = 61;
futurePred = 30; doSampling = 0; demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;
playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);
% Comments: 





%% as above with more ind. pts
clear; close all 
dataSetName = 'dog'; 
experimentNo=62; dataToKeep = 60; dataSetSplit = 'custom';
indTr = [1:60]; indTs = 60;
futurePred = 30; doSampling = 0; demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;
playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);



%% rbf + rbfperiodic with period = true period
clear; close all 
dataSetName = 'dog';
experimentNo=21;
dataSetSplit = 'custom';
indTr = [1:61];
indTs = 61;
futurePred = 60;
doSampling = 0;
demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;

disp('You are seeing the last 5 frames of Ytr concatenated with Varmu2')
playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);

pause
doSampling = 0;
dt = 0.103; subs=4; futurePred = 0:(dt/subs):(dt/subs)*(size(Ytr,1)-1)*subs; 
demHighDimVargplvmTrained
disp('You are seeing a supersampling effect: Ytr (left) Varmu2 (right)')
playMov(height, width, [0.03 subs], Varmu2, Ytr );

pause

disp('You are seeing samples from the covariance')
x = gsamp(zeros(model.N, 1), model.dynamics.Kt, 2)';
plot(x(:, 1), x(:, 2))








%--------- Older (only rbfperiodic)

%%

% Train on 1:60, period is 2pi
clear; close all 
dataSetName = 'dog';
experimentNo=2;
dataSetSplit = 'custom';
indTr = [1:60];
indTs = 61;
futurePred=20;
doSampling = 0;
demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;
playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);
pause

dt = 0.103; subs=4; futurePred = 0:(dt/subs):(dt/subs)*(size(Ytr,1)-1)*subs; 
demHighDimVargplvmTrained
playMov(height, width, [0.03 subs], Varmu2, Ytr );

% Comments: Transition is very bad

%%

% Train on whole 1:61, period is 2pi
clear; close all 
dataSetName = 'dog';
experimentNo=11;
dataSetSplit = 'custom';
indTr = 1:61;
indTs = [];
futurePred=20;
doSampling = 0;
demHighDimVargplvmTrained
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;

playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);

pause

dt = 0.103; subs=2; futurePred = 0:(dt/subs):(dt/subs)*(size(Ytr,1)-1)*subs;  
demHighDimVargplvmTrained
playMov(height, width, [0.05 subs], Varmu2, Ytr ); 


%%

% Train on frames corresponding to an integer number of periods (4)
clear; close all
dataSetName = 'dog';
experimentNo=13;
dataSetSplit = 'custom';
dataToKeep = 56;
indTr = 1:56;
indTs = 56;
futurePred = 40;
doSampling = 0;
demHighDimVargplvmTrained
playMov(height, width, [], [Ytr(end-5:end,:);Varmu2]);
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;

pause

dt = 0.103; subs=2; futurePred = 0:(dt/subs):(dt/subs)*(size(Ytr,1)-1)*subs;  
demHighDimVargplvmTrained
playMov(height, width, [0.05 subs], Varmu2, Ytr ); 

%%

% The period is set to the correct period.
clear; close all
dataSetName = 'dog';
experimentNo=19;
dataSetSplit = 'custom';
indTr = 1:61;
indTs = 61;
futurePred = 40;
doSampling = 0;
demHighDimVargplvmTrained
playMov(height, width, [], [Ytr(end-5:end,:);Varmu2]);
clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;

pause

dt = 0.103; subs=2; futurePred = 0:(dt/subs):(dt/subs)*(size(Ytr,1)-1)*subs;  
demHighDimVargplvmTrained
playMov(height, width, [0.05 subs], Varmu2, Ytr ); 
