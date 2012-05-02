


% DEMOIL100VARGPLVM1 Run variational GPLVM on 100 points from the oil data.

% VARGPLVM
clear
close all
% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

experimentNo = 1;
printDiagram = 1;

dataSetName = 'oil100';
[Y,lbls] = vargplvmLoadData(dataSetName);

% dataSetName = 'bc/wine';
% addpath(genpath('../../bc-vargplvm/matlab'));
% globalOpt.dataSetName = dataSetName;
% globalOpt.dataPerClass = 30;
% globalOpt.dataToKeep = -1;
% [globalOpt, Y,lbls] = bc_LoadData(globalOpt);
% lbls = Y.lbls;
% Y = Y.Y;
% dataSetName = 'wine';

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'linard2', 'bias', 'white'};
options.numActive = 50;
Xpca = ppcaEmbed(Y,10);
options.initX = rand(size(Xpca));
%options.tieParam = 'tied';

options.optimiser = 'scg2';
latentDim = 10;
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
model = vargplvmCreate(latentDim, d, Y, options);
%
model = vargplvmParamInit(model, model.m, model.X);
model.vardist.covars = 0.5*ones(size(model.vardist.covars)) + 0.001*randn(size(model.vardist.covars));
model.beta = 100 / var(Y(:));
%model.vardist.covars = 0.2*ones(size(model.vardist.covars));

% Optimise the model.
iters = 500; % Default: 2000
display = 1;

modelInit = model;
model.learnBeta = 0;
model = vargplvmOptimise(model, display, 200);
model.learnBeta = 1;
model = vargplvmOptimise(model, display, iters);
fprintf('1/model.beta = %.5f, var(Y(:))=%.5f\n', 1/model.beta, var(Y(:)));

capName = dataSetName;;
capName(1) = upper(capName(1));
modelType = model.type;
modelType(1) = upper(modelType(1));
save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');

% order wrt to the inputScales
mm = vargplvmReduceModel(model,2);
modelInit.kern.comp{1}.inputScales = model.kern.comp{1}.inputScales;
mmInit = vargplvmReduceModel(modelInit,2);
% plot the two largest twe latent dimensions
if exist('printDiagram') & printDiagram
    % Plot Vargplvm:
    vargplvmPrintPlot(mm, lbls, capName, experimentNo);
    title('vargplvm')
    % PLot PCA:
    mm.XOrig = mm.X;
    mm.X = ppcaEmbed(Y,2);
    vargplvmPrintPlot(mm, lbls, capName, experimentNo);
    title('pca')
    % VargplvmInit
    vargplvmPrintPlot(mmInit, lbls, capName, experimentNo);
    title('INIT vargplvm')
    % Plot scales
    figure
    subplot(1,2,1)
    bar(sort(model.kern.comp{1}.inputScales, 'descend'))
    subplot(1,2,2)
    bar(pca(Y,10))
    
    mm.X = mm.XOrig;
end
% For 3D plots:
%labels = transformLabels(lbls); dims = [1 2 3];
%plot3k({model.X(:,dims(1)) model.X(:,dims(2)) model.X(:,dims(3))}, 'ColorData', labels, 'Marker', {'x',6});
