% DEMROBOTWIRELESSVARGPLVM1 Run variational GPLVM on robot wireless data.
%
%	Description:
%	

% VARGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'robotWireless';
clear timeStamps; % in case it's left from a previous experiment

% load data
%[Y, lbls] = lvmLoadData(dataSetName);
%%% Like lvmLoadData but also parse times.
    fprintf(1,'# Preparing the dataset...\n');
    baseDir = datasetsDirectory;
    dirSep = filesep;
    [Ydat, timeStamps, wireless_x, wireless_y, storedMacs] = parseWirelessData([baseDir 'uw-floor.txt']);
    Ydat = (Ydat + 85)/15;
    lbls = 'connect';
    %Y = Ydat;
    Y = Ydat(1:215, :);
    timeStamps = timeStamps(1:215,:);
    %Ytest = Ydat(216:end, :);
%%%

%%% TEMP NOTE: Run with minimal params:
%%% clear;model=runDemoDynamics('demRobotWirelessVargplvmDyn1', 404,2,3,5,3,1,[]);

if ~exist('expNo')
    expNo = 404;
end
if ~exist('itNo')
    itNo = 100; % Default: 2000
end
if ~exist('indPoints')
    indPoints = 5; % Default: 50
end
if ~exist('latentDim')
    latentDim = 10;
end
if ~exist('dynUsed')
    dynUsed = 1;
end
if ~exist('dataToKeep')
    dataToKeep = size(Y,1);
    dataToKeep = 11; %% temp
end
if dataToKeep == -1
    dataToKeep = size(Y,1);
end

printDiagram = 1;
experimentNo = expNo;


% for fewer data
if dataToKeep < size(Y,1)
    fprintf(1,'# Using only a subset of %d datapoints...\n', dataToKeep);
    Y = Y(1:dataToKeep,:);
    timeStamps = timeStamps(1:dataToKeep,:);
end

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'rbfard2', 'bias', 'white'};
options.numActive = indPoints; % Default: 50
%options.tieParam = 'tied';  

options.optimiser = 'scg';
%options.optimiser = 'optimiMinimize';
%latentDim = 10; % Default: 10
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
fprintf(1,'# Creating the model...\n');
model = vargplvmCreate(latentDim, d, Y, options);
%
model = vargplvmParamInit(model, model.m, model.X); 
model.vardist.covars = 0.5*ones(size(model.vardist.covars)) + 0.001*randn(size(model.vardist.covars));



%{
% For scripts: set "dynUsed = 1" to add dynamics. Set to 0 otherwise.
if dynUsed
    fprintf(1,'# Adding dynamics to the model...\n');
    %optionsDyn = vargplvmOptions('ftc'); %%% TODO

    %optionsDyn.prior = 'gaussian';
    optionsDyn.initX = 'ppca'; %probably not needed

    % Create time vector for each dimension (later change that if t is given)
    if exist('timeStamps')
        t = timeStamps;
    else
        fprintf(1, 'Time vector unknown; creating random, equally spaced time vector\n');
        t = linspace(0, 2*pi, size(model.X, 1)+1)';  
        t = t(1:end-1, 1);
    end

    %%% Create Kernel -this should go to the vargplvmOptions
    kern = kernCreate(t, {'rbf','white'});    

    kern.comp{2}.variance = 1e-3; % 1e-1
    kern.comp{1}.inverseWidth = 5./(((max(t)-min(t))).^2);
    kern.comp{1}.variance = 1;
    optionsDyn.kern = kern;
    %optionsDyn.means = model.vardist.means;
    %optionsDyn.covars = model.vardist.covars;

    model = vargplvmAddDynamics(model, 'vargpTime', optionsDyn, t, 0, 0);
end
%}
%-------- Add dynamics to the model -----
if dynUsed
    model = addDefaultVargpTimeDynamics(model, timeStamps);
end
%------------------ 

return %%


% model.dynamics.vardist.covars =
% ones(size(model.dynamics.vardist.covars)); % Good initialization

% Optimise the model.
iters = itNo; % Default: 2000
display = 1;
fprintf(1,'# Optimising the model...\n');
model = vargplvmOptimise(model, display, iters);

fprintf(1,'# Saving the model...\n');
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
%lvmResultsDynamic(model.type, dataSetName, experimentNo, 'robotWireless',
%'vector')

