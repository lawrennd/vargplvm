% DEMSTICKVARGPLVM1 Run variational GPLVM on stick man data.

% VARGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';
experimentNo = 1;
printDiagram = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'rbfard2', 'bias', 'white'};
options.numActive = 50; 
%options.tieParam = 'tied';  

options.optimiser = 'scg';
latentDim = 10;
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
model = vargplvmCreate(latentDim, d, Y, options);
%
model = vargplvmParamInit(model, model.m, model.X); 
model.vardist.covars = 0.5*ones(size(model.vardist.covars)) + 0.001*randn(size(model.vardist.covars));
%model.vardist.covars = 0.2*ones(size(model.vardist.covars));

% Optimise the model.
iters = 2000; % default: 2000
display = 1;

model = vargplvmOptimise(model, display, iters);

% Save the results.
%modelWriteResult(model, dataSetName, experimentNo);
 capName = dataSetName;
 capName(1) = upper(capName(1));
 modelType = model.type;
 modelType(1) = upper(modelType(1));
 save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');


if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end

% load connectivity matrix
[void, connect] = mocapLoadTextData('run1');
% Load the results and display dynamically.
lvmResultsDynamic(model.type, dataSetName, experimentNo, 'stick', connect)


