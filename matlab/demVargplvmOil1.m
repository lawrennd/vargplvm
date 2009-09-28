
% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'oil100';
experimentNo = 1;
printDiagram = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);
%Y = Y(50:100,:);
%Y = zscore(Y);

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = 'rbfard2';
%options.kern = 'linard2';
options.numActive = 50; 

options.optimiser = 'scg';
latentDim = 4;
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
model = vargplvmCreate(latentDim, d, Y, options);
%model.X = model.y;
model = vargplvmParamInit(model, model.y, model.X); 
%model.beta = 1;

%logtheta0(1:D,1) = log((max(X)-min(X))'/2);
%logtheta0(D+1,1) = 0.5*log(var(y,1));
%logtheta0(D+2,1) = 0.5*log(var(y,1)/4);

% Optimise the model.
iters = 1000;
display = 1;

model = vargplvmOptimise(model, display, iters);

capName = dataSetName;;
capName(1) = upper(capName(1));
modelType = model.type;
modelType(1) = upper(modelType(1));
save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');

% place the variational means to the X (since lvmPrintPlot plots X)
model.X = model.vardist.means; 
if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, capName, experimentNo);
end
