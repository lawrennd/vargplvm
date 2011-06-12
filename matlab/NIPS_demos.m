% NIPS_demos Reproduce all results and plots used for the NIPS 2011 paper.
%
% NOTE: In case you wish to reproduce the results without doing the whole optimisation procedure
% but instead by loading the precomputed results, you will need to have in the path the following
% .mat files with the precomputed results:

% cmu35TaylorScaleBias.mat
% demCmu35gplvmReconstructBody33.mat
% demCmu35gplvmReconstructBody34.mat
% demCmu35gplvmReconstructLegs33.mat
% demCmu35gplvmReconstructLegs34.mat
% demCmu35gplvmVargplvm33.mat
% demCmu35gplvmVargplvm34.mat
% demCmu35Vargplvm33PredBody.mat
% demCmu35Vargplvm33PredLegs.mat
% demCmu35Vargplvm34PredBody.mat
% demCmu35Vargplvm34PredLegs.mat
% demDogVargplvm61.mat
% demDogVargplvm61Pred.mat
% demDogVargplvm65.mat
% demDogVargplvm65Pred.mat
% demMissaVargplvm59.mat
% demMissaVargplvm59Pred.mat
% demOceanVargplvm60.mat
% demOceanVargplvm60Pred.mat

% Also, you will need the datasets for 'missa', 'ocean' and 'dog' demos.

% These files are not stored in the SVN.

% COPYRIGHT : Andreas C. Damianou, 2011
% VARGPLVM

% If this variable is set to one, then all the models will be retrained, no
% stored results will be used, everything will be computed from the
% beginning. This might take a log of time though. It this variable is set
% to zero, then the precomputed model will be loaded. In that case,however,
% the precomputed results should be included in the path as .mat files.
retrainModels = 0;

% Like the global above, by setting this to 1 you can repeat only the test
% phase, provided that the .mat files for the training phase (the trained
% model) is included in the path. Again, this needs a lot of time but, of
% course, it's better than also retraining the model.
rePredict = 0;

% Note: if both retrainModels and rePredict are set to zero, then the
% precomputed results are loaded an the program just prints the plots.

% Save the above options because the script clears the workspace
save 'opts.mat' 'retrainModels' 'rePredict'
system('mkdir images');
%% 

% ########################## OCEAN ######################################
%{
% Note: The ocean demo is optimised so that we work with an NxN matrix
% instead of an NxD. However, this is done for the long optimisation
% procedure. For quick tasks (posteriorMeanVar, NN predictions) and for the
% plots we work with the full matrix. However, it is so large that regular
% machines cannot load at once. This can be fixed (e.g. to process the
% matrices in parts) easily or we can work on the server machine. For the
% plots, at least, we need the full matrix in any case.
clear; load opts
fprintf(1,'\n\n#-----  OCEAN DEMO ----#\n');
dataSetName = 'ocean';
experimentNo=60;
indPoints=-1; latentDim=20;
fixedBetaIters=200; reconstrIters = 2000;
itNo=[1000 2000 5000 8000 4000];
dynamicKern={'rbf','white','bias'};
whiteVar = 0.1;  vardistCovarsMult=1.7;
dataSetSplit = 'randomBlocks';
if retrainModels
    demHighDimVargplvm3
elseif rePredict
    demHighDimVargplvmTrained
else
    load demOceanVargplvm60Pred
    demHighDimVargplvmLoadPred
end
% Produce plots
fr=reshape(Varmu(27,:),height,width); imagesc(fr); colormap('gray'); % VGPDS
print -depsc images/images/oceanGpdsframe27.eps; system('epstopdf images/images/oceanGpdsframe27.eps');
fr=reshape(NNmuPartBest(27,:),height,width); imagesc(fr); colormap('gray'); % NN
print -depsc images/images/oceanNNframe27.eps; system('epstopdf images/images/oceanNNframe27.eps');
%}
%%

% ############################ MISSA ###################################
clear; load opts
fprintf(1,'\n\n#-----  MISSA DEMO ----#\n');
experimentNo = 59;
dataSetName = 'missa';
indPoints = -1; latentDim=25;
fixedBetaIters=50; reconstrIters = 4000;
itNo=[1000 2000 5000 8000 2000]; % 18000
dynamicKern={'matern32','white','bias'};
vardistCovarsMult=1.6;
dataSetSplit = 'blocks';
blockSize = 4; whiteVar = 0.1;
msk = [48 63 78 86 96 111 118];
if retrainModels
    demHighDimVargplvm3
elseif rePredict
    demHighDimVargplvmTrained
else
    load demMissaVargplvm59Pred
    demHighDimVargplvmLoadPred
end

% Produce plots
fr=reshape(Varmu(46,:),height,width); imagesc(fr); colormap('gray'); % VGPDS
print -depsc images/missaGpdsframe46.eps; system('epstopdf images/missaGpdsframe46.eps');
fr=reshape(YtsOriginal(46,:),height,width); imagesc(fr); colormap('gray'); % Original
print -depsc images/missaYtsOrigframe46.eps; system('epstopdf images/missaYtsOrigframe46.eps');
fr=reshape(NNmuPartBest(46,:),height,width); imagesc(fr); colormap('gray'); % NN for best k
print -depsc images/missaNNframe46.eps; system('epstopdf images/missaNNframe46.eps');
% The following two pictures are edited in the paper so that they fit in
% the place of one single picture
fr=reshape(Yts(17,:),height,width); imagesc(fr); colormap('gray'); 
print -depsc images/missaGpdsPredFrame17_part1.eps; system('epstopdf images/missaGpdsPredFrame17_part1.eps');
fr=reshape(Varmu(17,:),height,width); imagesc(fr); colormap('gray');
print -depsc images/missaGpdsPredFrame17_part2.eps; system('epstopdf images/missaGpdsPredFrame17_part2.eps');
%%


% ############################ DOG #######################################

%------------ GENERATION -------
% Train
clear; load opts
fprintf(1,'\n\n#-----  DOG DEMO: Generation ----#\n');
dataSetName = 'dog';
experimentNo=61;
indPoints=-1; latentDim=35;
fixedBetaIters=400;
reconstrIters = 1; % no reconstruction needed here
itNo=[1000 1000 1000 1000 1000 1000 500 500 500 500 1000 1000 1000 1000 1000 1000 1000 500 500]; %16000
periodicPeriod = 4.3983; % Recalculated for dataToKeep=60
dynamicKern={'rbfperiodic','whitefixed','bias','rbf'};
vardistCovarsMult=0.8;
whiteVar = 1e-6;
dataToKeep = 60; dataSetSplit = 'custom';
indTr = [1:60];
indTs = 60; % We don't really reconstruct in this experiment
learnSecondVariance = 0;
if retrainModels
    demHighDimVargplvm3
end

%-- Then generate:
clear; load opts; close all 
dataSetName = 'dog'; 
experimentNo=61; dataToKeep = 60; dataSetSplit = 'custom';
indTr = [1:60]; indTs = 60;
futurePred = 40; doSampling = 0; demHighDimVargplvmTrained
%clear Yts; clear YtsOriginal; clear Testmeans2; clear Testcovars2;
%playMov(height, width, [], [Ytr(end-5:end,:); Varmu2]);

% Produce plots
bar(prunedModelInit.kern.comp{1}.inputScales)
print -depsc images/dog_scalesInit.eps; system('epstopdf images/dog_scalesInit.eps');
bar(model.kern.comp{1}.inputScales)
print -depsc images/dog_scalesOpt.eps; system('epstopdf images/dog_scalesOpt.eps');

fr=reshape(Ytr(end,:),height,width); imagesc(fr); colormap('gray'); % Last training image
print -depsc images/dogGeneration_lastOfTraining.eps; system('epstopdf images/dogGeneration_lastOfTraining.eps');
fr=reshape(Varmu2(1,:),height,width); imagesc(fr); colormap('gray');  % First predicted
print -depsc images/dogGeneration_firstOfTest.eps; system('epstopdf images/dogGeneration_firstOfTest.eps');
fr=reshape(Varmu2(13,:),height,width); imagesc(fr); colormap('gray'); % A subsequent frame
print -depsc images/dogGeneration_frame14.eps; system('epstopdf images/dogGeneration_frame14.eps');


% The following is for interpolation
%dt = 0.103; subs=4; futurePred = 0:(dt/subs):(dt/subs)*(size(Ytr,1)-1)*subs; 
%demHighDimVargplvmTrained
%playMov(height, width, [0.03 subs], Varmu2, Ytr );

%%

%--------- Reconstruction
% Train
clear; load opts
fprintf(1,'\n\n#-----  DOG DEMO: Reconstruction ----#\n');
dataSetName = 'dog';
experimentNo=65;
indPoints=-1; latentDim=35;
fixedBetaIters=400;
reconstrIters = 2;
itNo=[1000 1000 1000 1000 1000 1000 500 500 500 500 1000 1000 1000 1000 1000 1000 1000 500 500]; %16000
periodicPeriod = 2.8840;
dynamicKern={'rbfperiodic','whitefixed','bias','rbf'};
vardistCovarsMult=0.8;
whiteVar = 1e-6;
dataSetSplit = 'custom';
indTr = 1:54;
indTs = 55:61;
learnSecondVariance = 0;
if retrainModels
    demHighDimVargplvm3
end

%%

% Test
clear; load opts
dataSetName = 'dog';
experimentNo=65;
dataSetSplit = 'custom';
indTr = 1:54; indTs = 55:61;
predWithMs = 1; % Do reconstruction
reconstrIters = 18000; 
doSampling = 0;
if rePredict
    demHighDimVargplvmTrained
else
    load demDogVargplvm65Pred
    demHighDimVargplvmLoadPred
end
% Produce plots (these go to the supplementary)
fr=reshape(Varmu(5,:),height,width); imagesc(fr); colormap('gray'); 
print -depsc images/supplDogPredGpds5.eps; system('epstopdf images/supplDogPredGpds5.eps');
fr=reshape(Yts(5,:),height,width); imagesc(fr); colormap('gray'); 
print -depsc images/supplDogPredYts5.eps; system('epstopdf images/supplDogPredYts5.eps');
fr=reshape(Varmu(6,:),height,width); imagesc(fr); colormap('gray'); 
print -depsc images/supplDogPredGpds6.eps; system('epstopdf images/supplDogPredGpds6.eps');
fr=reshape(Yts(6,:),height,width); imagesc(fr); colormap('gray'); 
print -depsc images/supplDogPredYts6.eps; system('epstopdf images/supplDogPredYts6.eps');

%%

% ############################ CMU ###################################
%rbf
clear; load opts
fprintf(1,'\n\n#-----  CMU DEMO: Rbf ----#\n');
experimentNo=34; 
itNo = [300 300 400 200 200 300 400 400];
dynamicKern = {'rbf', 'white', 'bias'};
vardistCovarsMult = 0.152;
if retrainModels 
    if rePredict
        doReconstr = 1;
    else
        doReconstr=0;
    end
    demCmu35gplvmVargplvm3;
elseif rePredict
    % 'demCmu35gplvmVargplvm34.mat' must be included in the path
    demCmu35vargplvmReconstructTaylor
end
predictPart = 'Legs';  plotRange = [];
demCmu35VargplvmPlotsScaled
% demCmu35VargplvmAnimate
fprintf(1,'# VGPDS RBF error on Legs reconstr:');
errStruct

predictPart = 'Body';  plotRange = [];
demCmu35VargplvmPlotsScaled
% demCmu35VargplvmAnimate
fprintf(1,'# VGPDS RBF error on Body reconstr:');
errStruct

bar(model.kern.comp{1}.inputScales);
print -depsc images/supplMocapScalesRbf.eps; system('epstopdf images/supplMocapScalesRbf.eps');


% matern32 for legs
clear; load opts
fprintf(1,'\n\n#-----  CMU DEMO: Matern32 ----#\n');
experimentNo=33; 
itNo = [300 300 400 200 200 300 400 400];
dynamicKern = {'matern32', 'white', 'bias'};
vardistCovarsMult = 0.24;
if retrainModels 
    if rePredict
        doReconstr = 1;
    else
        doReconstr=0;
    end
    demCmu35gplvmVargplvm3;
elseif rePredict
    % 'demCmu35gplvmVargplvm33.mat' must be included in the path
    demCmu35vargplvmReconstructTaylor
end
predictPart = 'Legs'; plotRange = 10;
demCmu35VargplvmPlotsScaled
print -depsc images/supplMocapLeg5GpdsMatern.eps; system('epstopdf images/supplMocapLeg5GpdsMatern.eps');
% demCmu35VargplvmAnimate
fprintf(1,'# VGPDS Matern error on Legs reconstr:');
errStruct

predictPart = 'Body'; plotRange = 28;
demCmu35VargplvmPlotsScaled
print -depsc images/supplMocapBody28GpdsMatern.eps; system('epstopdf images/supplMocapBody28GpdsMatern.eps');
% demCmu35VargplvmAnimate
fprintf(1,'# VGPDS Matern error on Body reconstr:');
errStruct
close all
bar(model.kern.comp{1}.inputScales);
print -depsc images/supplMocapScalesMatern.eps; system('epstopdf images/supplMocapScalesMatern.eps');


%% ---------
fprintf(1,'\n\n#---- FINISHED reproducing plots and results!! \n');
delete opts.mat
