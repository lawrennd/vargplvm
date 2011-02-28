% DEMBRENDANVARGPLVM1 Run variational GPLVM on Brendan face data.

% VARGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'brendan';

clear timeStamps; % in case it's left from a previous experiment
% load data
[Y, lbls] = lvmLoadData(dataSetName);


if ~exist('expNo')
    expNo = 404;
end
if ~exist('itNo')
    itNo = 5; % Default: 2000
end
if ~exist('indPoints')
    indPoints = 20; % Default: 50
end
if ~exist('latentDim')
    latentDim = 10; % Default: 30
end
if ~exist('dynUsed')
    dynUsed = 0;
end
if ~exist('dataToKeep')
    dataToKeep = size(Y,1);
end
if dataToKeep == -1
    dataToKeep = size(Y,1);
end

experimentNo = expNo;
printDiagram = 1;



% Temp: for fewer data
if dataToKeep < size(Y,1)
    fprintf(1,'# Using only a subset of %d datapoints...\n', dataToKeep);
    Y = Y(1:dataToKeep,:);
end

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'rbfard2', 'white'};
options.numActive = indPoints; % Default: 100
options.scale2var1 = 1; % scale data to have variance 1
%options.tieParam = 'tied';  

options.optimiser = 'scg';
%latentDim = 10; % Default: 30
d = size(Y, 2);

% create the model
fprintf(1,'# Creating the model...\n');
model = vargplvmCreate(latentDim, d, Y, options);
%
model = vargplvmParamInit(model, model.m, model.X); 


%-------- Add dynamics to the model -----
if dynUsed
    model = addDefaultVargpTimeDynamics(model);
end
%------------------ 


% Optimise the model.
iters = itNo; % DEfault: 1500
display = 1;

fprintf(1,'# Optimising the model...\n');
model = vargplvmOptimise(model, display, iters);

% Save the results.
fprintf(1,'# Saving the model...\n');
modelWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end

% load connectivity matrix
%[void, connect] = mocapLoadTextData('run1');
% Load the results and display dynamically.
%lvmResultsDynamic(model.type, dataSetName, experimentNo, 'image', [20 28], 1, 0, 1)
