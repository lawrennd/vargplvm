% DEMOIL100VARGPLVMDYN1 Run variational GPLVM on 100 points from the oil data.

% VARGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'oil100';
%dataSetName = 'oil';
experimentNo = 1;
printDiagram = 1;


% load data
[Y, lbls] = lvmLoadData(dataSetName);

%%% TEMP: for fewer data
%Y = Y(1:20,:); 


% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'rbfard2', 'bias', 'white'};
options.numActive = 50; % default 50 
%options.tieParam = 'tied';  

options.optimiser = 'scg';
%options.optimiser='optimiMinimize';
latentDim = 10; %Default:10
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
model = vargplvmCreate(latentDim, d, Y, options);
%
model = vargplvmParamInit(model, model.m, model.X); 
model.vardist.covars = 0.5*ones(size(model.vardist.covars)) + 0.001*randn(size(model.vardist.covars));
%model.vardist.covars = 0.2*ones(size(model.vardist.covars));


% NEW_
%%% Add dynamics to the model 
optionsDyn = vargplvmOptions('ftc'); %%% TODO
% Create time vector for each dimension (later change that if t is given)  

t = linspace(0, 2*pi, size(model.X, 1)+1)';  
t = t(1:end-1, 1);
%t=ones(1,size(model.X, 1))';
        %%% This should go to the vargplvmOptions
        %kern = kernCreate(t, {'rbfperiodic', 'white'});
        %kern = kernCreate(t,  {'rbfard2', 'bias', 'white'});
        kern = kernCreate(t,  {'rbf','white'});
       % kern.transforms = [];
        %%% Maybe kernCreate and kernCompute must be operated on the repmat
        %%% of t?? so as to have more lengthscales?
       
       %         kern.comp{2}.variance = 1e-5;
%         %kern.whiteVariance = kern.comp{2}.variance;
%         %optionsDyn.whiteVariance = kern.comp{2}.variance; % not sure this is needed
%         kern.comp{1}.inverseWidth = 1;
%         kern.comp{1}.variance = 1;
        optionsDyn.kern = kern;
        optionsDyn.means = model.vardist.means;
        optionsDyn.covars = model.vardist.covars;
        %%%
   %model = vargplvmAddDynamics(model, 'vargpTime', optionsDyn, t, 0, 0);
%%% 
% _NEW

% Optimise the model.
 iters = 100;
 display = 1;
% 
fprintf('# Optimising the model...\n');
 model = vargplvmOptimise(model, display, iters);
% 
 capName = dataSetName;
 capName(1) = upper(capName(1));
 modelType = model.type;
 modelType(1) = upper(modelType(1));
 save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');

% order wrt to the inputScales
 mm = vargplvmReduceModel(model,2);
 % plot the two largest twe latent dimensions 
 if exist('printDiagram') & printDiagram
   lvmPrintPlot(mm, lbls, capName, experimentNo);
 end


%Load the results and display dynamically.
%lvmResultsDynamic(model.type, dataSetName, experimentNo, 'vector')

