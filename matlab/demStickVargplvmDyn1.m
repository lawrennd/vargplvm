% DEMSTICKVARGPLVM1 Run variational GPLVM on stick man data.

% VARGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';

clear timeStamps; % in case it's left from a previous experiment
% load data
[Y, lbls] = lvmLoadData(dataSetName);


if ~exist('expNo')
    expNo = 404;
end
if ~exist('itNo')
    itNo = 150; % Default: 2000
end
if ~exist('indPoints')
    indPoints = 50; % Default: 50
end
if ~exist('latentDim')
    latentDim = 10;
end
if ~exist('dynUsed')
    dynUsed =1;
end
if ~exist('dataToKeep')
    dataToKeep = size(Y,1);
end
if dataToKeep == -1
    dataToKeep = size(Y,1);
end

experimentNo = expNo;
printDiagram = 0;

% Temp: for fewer data
if dataToKeep < size(Y,1)
    fprintf(1,'# Using only a subset of %d datapoints...\n', dataToKeep);
    Y = Y(1:dataToKeep,:);
end

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'rbfard2', 'bias', 'white'};
options.numActive = indPoints; 
%options.tieParam = 'tied';  

options.optimiser = 'scg';
%latentDim = 10;
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
fprintf(1,'# Creating the model...\n');
model = vargplvmCreate(latentDim, d, Y, options);
%
model = vargplvmParamInit(model, model.m, model.X); 
model.vardist.covars = 0.5*ones(size(model.vardist.covars)) + 0.001*randn(size(model.vardist.covars));
%model.vardist.covars = 0.2*ones(size(model.vardist.covars));


%{
%-------- Add dynamics to the model -----
optionsDyn = vargplvmOptions('ftc'); %%% TODO
% Create time vector for each dimension (later change that if t is given)  

t = linspace(0, 2*pi, size(model.X, 1)+1)';  
t = t(1:end-1, 1);

%%% Create Kernel -this should go to the vargplvmOptions
kern = kernCreate(t,  {'rbf','white'});     

optionsDyn.kern = kern;
optionsDyn.means = model.vardist.means;
optionsDyn.covars = model.vardist.covars;

% For scripts: set "dynUsed = 1" to add dynamics. Set to 0 otherwise.
if dynUsed
    fprintf(1,'# Adding dynamics to the model...\n');
    model = vargplvmAddDynamics(model, 'vargpTime', optionsDyn, t, 0, 0);
end
%}

% Stickman data are equally-spaced (t(n+1) = t(n) + 0.0083).
%-------- Add dynamics to the model -----
if dynUsed
    model = addDefaultVargpTimeDynamics(model);
end
%------------------ 

%return %%%

% Optimise the model.
iters = itNo; % default: 2000
display = 1;

fprintf(1,'# Optimising the model...\n');
model = vargplvmOptimise(model, display, iters);

% Save the results.
fprintf(1,'# Saving the model...\n');
%modelWriteResult(model, dataSetName, experimentNo);
 capName = dataSetName;
 capName(1) = upper(capName(1));
 modelType = model.type;
 modelType(1) = upper(modelType(1));
 save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');


if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end

%%%% load connectivity matrix
%[void, connect] = mocapLoadTextData('run1');
%%%% Load the results and display dynamically.
%lvmResultsDynamic(model.type, dataSetName, experimentNo, 'stick', connect)


