% DEMSWISSROLLVARGPLVM1 Run variational GPLVM on swiss roll data.

% VARGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'swissRoll';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'rbfard2', 'bias', 'white'};
options.numActive = 50; 
options.initX = 'isomap';
%options.scale2var1 = 1; % scale data to have variance 1
options.tieParam = 'tied';  

options.optimiser = 'scg';
latentDim = 3;
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
model = vargplvmCreate(latentDim, d, Y, options);

% intilialize from the training data 
%model.X = model.m; 
%ind = randperm(model.N);
%ind = ind(1:model.k);
%model.X_u = model.X(ind, :);
%model.vardist.means = model.X; 
%
model = vargplvmParamInit(model, model.m, model.X); 
%model.vardist.covars = 10*ones(model.N,model.q) + 0.001*randn(model.N,model.q);

% Optimise the model.
iters = 1000;
display = 1;

model = vargplvmOptimise(model, display, iters);

capName = dataSetName;;
capName(1) = upper(capName(1));
modelType = model.type;
modelType(1) = upper(modelType(1));
save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');

% order wrt to the inputScales
mm = vargplvmReduceModel(model,2);
%% plot the two largest twe latent dimensions 
if exist('printDiagram') & printDiagram
  lvmPrintPlot(mm, lbls, capName, experimentNo);
end

