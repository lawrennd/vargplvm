% Initialise options. If the field name of 'defaults' already exists as a
% variable, the globalOpt will take this value, otherwise the default one.

defaults.experimentNo = 404;
defaults.itNo =2000;
defaults.indPoints = 49;
defaults.latentDim = 40; 
% Set to 1 to use dynamics or to 0 to use the standard var-GPLVM
defaults.dynUsed = 1;
defaults.fixedBetaIters = 0;
% Set to 1 to tie the inducing points with the latent vars. X
defaults.fixInd = 0;
defaults.dynamicKern = {'rbf', 'white', 'bias'};
defaults.mappingKern = 'rbfardjit'; % {'rbfard2', 'bias', 'white'};
defaults.reconstrIters = 1000;
% 0.1 gives around 0.5 init.covars. 1.3 biases towards 0.
defaults.vardistCovarsMult=1.3;
defaults.dataSetSplit = 'everyTwo';
defaults.blockSize = 8;
% 720x1280
defaults.dataSetName = 'missa';
defaults.testReoptimise = 1;
defaults.invWidthMultDyn = 100;
defaults.invWidthMult = 5;
defaults.initX ='ppca';
defaults.regularizeMeans = 0;
defaults.initVardistIters = 0;
defaults.enableParallelism = false;
defaults.DgtN = 1;
defaults.doPredictions = false;
defaults.initSNR = 100;
defaults.scale2var1 = 0;
defaults.initVardistIters = 50;
defaults.diaryFile = [];

 fnames = fieldnames(defaults);
 for i=1:length(fnames)
    if ~exist(fnames{i})
        globalOpt.(fnames{i}) = defaults.(fnames{i});
    else
        globalOpt.(fnames{i}) = eval(fnames{i});
    end
 end
 
 
 clear('defaults', 'fnames');
